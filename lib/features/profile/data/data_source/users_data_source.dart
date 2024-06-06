import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_snap/features/profile/data/models/connection_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/connection_status.dart';

part 'users_data_source.g.dart';

abstract class UsersDataSource {
  Future<UserModel> getUser(String userId);

  Future<void> updateUserFCMToken(UserModel user, String fcmToken);

  Future<List<ConnectionModel>> getPendingConnections(String localUserId);

  Future<void> removeAllUserConnections(String userId);

  Future<void> addConnection(String localUserId, String userId);

  Future<void> addTaggingConnection(
      String localUserId, String userId, String imageUrl, String postId);

  Future<void> removeTaggingConnection(String localUserId, String userId);

  Future<void> acceptTaggingConnection(String localUserId, String userId);

  Future<void> acceptConnection(String localUserId, String userId);

  Future<void> rejectConnection(String localUserId, String userId);

  Future<void> removeConnection(String localUserId, String userId);

  Future<ConnectionModel> checkConnection(String localUserId, String userId);

  Future<List<Map<String, DateTime>>> getUserConnections(String userId,
      {String? startAfter, int limit = 30});
}

@Riverpod(keepAlive: true)
UsersDataSource usersDataSource(UsersDataSourceRef ref) {
  final firestore = FirebaseFirestore.instance;
  final firebaseApp = Firebase.app();
  final realtimeDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL:
          'https://crowd-snap-default-rtdb.europe-west1.firebasedatabase.app/');
  return UsersDataSourceImpl(firestore, realtimeDatabase);
}

class UsersDataSourceImpl implements UsersDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseDatabase _realtimeDatabase;

  UsersDataSourceImpl(this._firestore, this._realtimeDatabase);

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        return UserModel.fromJson(userData!);
      } else {
        throw Exception('User not found in Firestore');
      }
    } catch (e) {
      throw Exception('Failed to get user from Firestore');
    }
  }

  @override
  Future<void> updateUserFCMToken(UserModel user, String fcmToken) async {
    try {
      await _firestore.collection('users').doc(user.userId).update({
        'fcmToken': fcmToken,
      });
    } catch (e) {
      throw Exception('Failed to update user FCM token: $e');
    }
  }

  @override
  Future<void> removeAllUserConnections(String userId) async {
    try {
      final connectionRef = _realtimeDatabase.ref().child('connections');
      // Realiza ambas consultas en paralelo
      final connectionQuery1 =
          connectionRef.orderByChild('senderId').equalTo(userId).once();

      final connectionQuery2 =
          connectionRef.orderByChild('receiverId').equalTo(userId).once();

      // Espera a que ambas consultas se completen
      final results = await Future.wait([connectionQuery1, connectionQuery2]);

      final connectedUserIds = <String>[];

      // Procesa los resultados de la primera consulta
      if (results[0].snapshot.exists) {
        for (var connection in results[0].snapshot.children) {
          connectedUserIds.add(connection.child('receiverId').value.toString());
          await connection.ref.remove();
        }
      }

      // Procesa los resultados de la segunda consulta
      if (results[1].snapshot.exists) {
        for (var connection in results[1].snapshot.children) {
          connectedUserIds.add(connection.child('senderId').value.toString());
          await connection.ref.remove();
        }
      }

      // Actualiza el contador de conexiones en Firestore para cada usuario conectado
      for (var connectedUserId in connectedUserIds) {
        final connectedUserRef =
            _firestore.collection('users').doc(connectedUserId);
        await connectedUserRef.update({
          'connectionsCount': FieldValue.increment(-1),
        });
      }
    } catch (e) {
      throw Exception('Failed to remove all user connections: $e');
    }
  }

  @override
  Future<List<ConnectionModel>> getPendingConnections(
      String localUserId) async {
    try {
      final userDoc =
          await _firestore.collection('users').doc(localUserId).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        final pendingConnections =
            List<String>.from(userData!['pendingConnections'] ?? []);
        final connections = <ConnectionModel>[];

        for (var connectionId in pendingConnections) {
          final connectionDoc = await _realtimeDatabase
              .ref()
              .child('connections')
              .child(connectionId)
              .get();
          if (connectionDoc.exists) {
            final connectionData = connectionDoc.value as Map<String, dynamic>;
            final connectionModel = createConnectionModel(connectionData);
            connections.add(connectionModel);
          }
        }

        print('Connections: $connections');

        return connections;
      } else {
        throw Exception('User not found in Firestore');
      }
    } catch (e) {
      throw Exception('Failed to get pending connections: $e');
    }
  }

  @override
  Future<void> addTaggingConnection(
      String localUserId, String userId, String imageUrl, String postId) async {
    try {
      final localUserRef = _firestore.collection('users').doc(localUserId);
      final userRef = _firestore.collection('users').doc(userId);
      final connectionId = '${localUserId}_$userId';
      final connectionRef =
          _realtimeDatabase.ref().child('connections').child(connectionId);

      await _firestore.runTransaction((transaction) async {
        // Realiza todas las lecturas primero
        final userSnapshot = await transaction.get(userRef);
        final localUserSnapshot = await transaction.get(localUserRef);

        // Prepara los datos para las escrituras
        final userPendingConnections = userSnapshot.exists
            ? List<String>.from(
                userSnapshot.data()!['pendingConnections'] ?? [])
            : [];
        userPendingConnections.add(connectionId);

        final localUserPendingConnections = localUserSnapshot.exists
            ? List<String>.from(
                localUserSnapshot.data()!['pendingConnections'] ?? [])
            : [];
        localUserPendingConnections.add(connectionId);

        // Realiza todas las escrituras después de las lecturas
        transaction.update(userRef, {
          'pendingConnections': userPendingConnections,
        });
        transaction.update(localUserRef, {
          'pendingConnections': localUserPendingConnections,
        });
      });

      await connectionRef.set({
        'senderId': localUserId,
        'receiverId': userId,
        'status': ConnectionStatus.taggingRequest.value,
        'connectedAt': DateTime.now().toIso8601String(),
        'imageUrl': imageUrl,
        'postId': postId,
      });
    } catch (e) {
      throw Exception('Failed to add tagging connection: $e');
    }
  }

  @override
  Future<void> removeTaggingConnection(
      String localUserId, String userId) async {
    try {
      final localUserRef = _firestore.collection('users').doc(localUserId);
      final userRef = _firestore.collection('users').doc(userId);

      // Consulta el array de pendingConnections del usuario local
      final localUserSnapshot = await localUserRef.get();
      if (localUserSnapshot.exists) {
        final localUserData = localUserSnapshot.data() as Map<String, dynamic>;
        final pendingConnections =
            List<String>.from(localUserData['pendingConnections'] ?? []);

        // Elimina la conexión pendiente
        pendingConnections
            .removeWhere((connectionId) => connectionId.contains(userId));

        // Actualiza el array de pendingConnections del usuario local
        await localUserRef.update({
          'pendingConnections': pendingConnections,
        });
      }

      // Consulta el array de pendingConnections del usuario receptor
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final pendingConnections =
            List<String>.from(userData['pendingConnections'] ?? []);

        // Elimina la conexión pendiente
        pendingConnections
            .removeWhere((connectionId) => connectionId.contains(localUserId));

        // Actualiza el array de pendingConnections del usuario receptor
        await userRef.update({
          'pendingConnections': pendingConnections,
        });
      }

      // Elimina la conexión
      final connectionRef = _realtimeDatabase
          .ref()
          .child('connections')
          .child('${userId}_$localUserId');
      await connectionRef.remove();
    } catch (e) {
      throw Exception('Failed to remove tagging connection: $e');
    }
  }

  @override
  Future<void> acceptTaggingConnection(
      String localUserId, String userId) async {
    try {
      final localUserRef = _firestore.collection('users').doc(localUserId);
      final userRef = _firestore.collection('users').doc(userId);

      // Consulta el array de pendingConnections del usuario local
      final localUserSnapshot = await localUserRef.get();
      if (localUserSnapshot.exists) {
        final localUserData = localUserSnapshot.data() as Map<String, dynamic>;
        final pendingConnections =
            List<String>.from(localUserData['pendingConnections'] ?? []);

        // Elimina la conexión pendiente
        pendingConnections
            .removeWhere((connectionId) => connectionId.contains(userId));

        // Actualiza el array de pendingConnections del usuario local
        await localUserRef.update({
          'pendingConnections': pendingConnections,
          'connectionsCount': FieldValue.increment(1),
        });
      }

      // Consulta el array de pendingConnections del usuario receptor
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final pendingConnections =
            List<String>.from(userData['pendingConnections'] ?? []);

        // Elimina la conexión pendiente
        pendingConnections
            .removeWhere((connectionId) => connectionId.contains(localUserId));

        // Actualiza el array de pendingConnections del usuario receptor
        await userRef.update({
          'pendingConnections': pendingConnections,
          'connectionsCount': FieldValue.increment(1),
        });
      }

      // Actualiza la conexión a aceptada y la convierte en connected y elimina el postId y la imageUrl
      final connectionRef = _realtimeDatabase
          .ref()
          .child('connections')
          .child('${userId}_$localUserId');
      await connectionRef.update({
        'status': ConnectionStatus.connected.value,
        'postId': null,
        'imageUrl': null,
      });
    } catch (e) {
      throw Exception('Failed to accept tagging connection: $e');
    }
  }

  @override
  Future<void> addConnection(String localUserId, String userId) async {
    try {
      final localUserRef = _firestore.collection('users').doc(localUserId);
      final userRef = _firestore.collection('users').doc(userId);
      final connectionId = '${localUserId}_$userId';
      final connectionRef =
          _realtimeDatabase.ref().child('connections').child(connectionId);

      await _firestore.runTransaction((transaction) async {
        // Realiza todas las lecturas primero
        final userSnapshot = await transaction.get(userRef);
        final localUserSnapshot = await transaction.get(localUserRef);

        // Prepara los datos para las escrituras
        final userPendingConnections = userSnapshot.exists
            ? List<String>.from(
                userSnapshot.data()!['pendingConnections'] ?? [])
            : [];
        userPendingConnections.add(localUserId);

        final localUserPendingConnections = localUserSnapshot.exists
            ? List<String>.from(
                localUserSnapshot.data()!['pendingConnections'] ?? [])
            : [];
        localUserPendingConnections.add(userId);

        // Realiza todas las escrituras después de las lecturas
        transaction.update(userRef, {
          'pendingConnections': userPendingConnections,
        });
        transaction.update(localUserRef, {
          'pendingConnections': localUserPendingConnections,
        });
      });

      await connectionRef.set({
        'senderId': localUserId,
        'receiverId': userId,
        'status': ConnectionStatus.pending.value,
        'connectedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add connection: $e');
    }
  }

  @override
  Future<void> acceptConnection(String localUserId, String userId) async {
    try {
      final localUserRef = _firestore.collection('users').doc(localUserId);
      final userRef = _firestore.collection('users').doc(userId);

      // Consulta el array de pendingConnections del usuario local
      final localUserSnapshot = await localUserRef.get();
      if (localUserSnapshot.exists) {
        final localUserData = localUserSnapshot.data() as Map<String, dynamic>;
        final pendingConnections =
            List<String>.from(localUserData['pendingConnections'] ?? []);

        print('Pending Connections: $pendingConnections');

        // Elimina la conexión pendiente
        pendingConnections
            .removeWhere((connectionId) => connectionId.contains(userId));

        // Actualiza el array de pendingConnections del usuario local
        await localUserRef.update({
          'pendingConnections': pendingConnections,
          'connectionsCount': FieldValue.increment(1),
        });
      }

      // Consulta el array de pendingConnections del usuario receptor
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final pendingConnections =
            List<String>.from(userData['pendingConnections'] ?? []);

        print('Pending Connections: $pendingConnections');

        // Elimina la conexión pendiente
        pendingConnections
            .removeWhere((connectionId) => connectionId.contains(localUserId));

        // Actualiza el array de pendingConnections del usuario receptor
        await userRef.update({
          'pendingConnections': pendingConnections,
          'connectionsCount': FieldValue.increment(1),
        });
      }

      // Actualiza la conexión a aceptada
      final connectionRef = _realtimeDatabase
          .ref()
          .child('connections')
          .child('${userId}_$localUserId');
      await connectionRef.update({
        'status': ConnectionStatus.connected.value,
      });
    } catch (e) {
      throw Exception('Failed to accept connection: $e');
    }
  }

  @override
  Future<void> rejectConnection(String localUserId, String userId) async {
    try {
      final localUserRef = _firestore.collection('users').doc(localUserId);
      final userRef = _firestore.collection('users').doc(userId);

      // Consulta el array de pendingConnections del usuario local
      final localUserSnapshot = await localUserRef.get();
      if (localUserSnapshot.exists) {
        final localUserData = localUserSnapshot.data() as Map<String, dynamic>;
        final pendingConnections =
            List<String>.from(localUserData['pendingConnections'] ?? []);

        // Elimina la conexión pendiente
        pendingConnections
            .removeWhere((connectionId) => connectionId.contains(userId));

        // Actualiza el array de pendingConnections del usuario local
        await localUserRef.update({
          'pendingConnections': pendingConnections,
        });
      }

      // Consulta el array de pendingConnections del usuario receptor
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final pendingConnections =
            List<String>.from(userData['pendingConnections'] ?? []);

        // Elimina la conexión pendiente
        pendingConnections
            .removeWhere((connectionId) => connectionId.contains(localUserId));

        // Actualiza el array de pendingConnections del usuario receptor
        await userRef.update({
          'pendingConnections': pendingConnections,
        });
      }

      // Elimina la conexión
      final connectionRef = _realtimeDatabase
          .ref()
          .child('connections')
          .child('${userId}_$localUserId');
      await connectionRef.update({
        'status': ConnectionStatus.rejected.value,
      });
    } catch (e) {
      throw Exception('Failed to reject connection: $e');
    }
  }

  @override
  Future<void> removeConnection(String localUserId, String userId) async {
    try {
      final localUserRef = _firestore.collection('users').doc(localUserId);
      final userRef = _firestore.collection('users').doc(userId);

      // Realiza ambas consultas en paralelo
      final connectionQuery1 = _realtimeDatabase
          .ref()
          .child('connections')
          .orderByChild('senderId')
          .equalTo(localUserId)
          .once();

      final connectionQuery2 = _realtimeDatabase
          .ref()
          .child('connections')
          .orderByChild('receiverId')
          .equalTo(localUserId)
          .once();

      // Espera a que ambas consultas se completen
      final results = await Future.wait([connectionQuery1, connectionQuery2]);

      String? connectionKey;

      // Procesa los resultados de la primera consulta
      if (results[0].snapshot.exists) {
        for (var connection in results[0].snapshot.children) {
          if (connection.child('senderId').value == localUserId) {
            connectionKey = connection.key;
            break;
          }
        }
      }

      // Procesa los resultados de la segunda consulta si no se encontró en la primera
      if (connectionKey == null && results[1].snapshot.exists) {
        for (var connection in results[1].snapshot.children) {
          if (connection.child('receiverId').value == localUserId) {
            connectionKey = connection.key;
            break;
          }
        }
      }

      if (connectionKey != null) {
        // Elimina el nodo de conexión
        await _realtimeDatabase
            .ref()
            .child('connections')
            .child(connectionKey)
            .remove();

        // Actualiza el conteo de conexiones en Firestore
        await _firestore.runTransaction((transaction) async {
          transaction.update(localUserRef, {
            'connectionsCount': FieldValue.increment(-1),
          });
          transaction.update(userRef, {
            'connectionsCount': FieldValue.increment(-1),
          });
        });
      } else {
        throw Exception('Connection not found');
      }
    } catch (e) {
      throw Exception('Failed to remove connection: $e');
    }
  }

  @override
  Future<ConnectionModel> checkConnection(
      String localUserId, String userId) async {
    try {
      final connectionRef = _realtimeDatabase.ref().child('connections');

      // Realiza ambas consultas en paralelo
      final connectionQuery1 =
          connectionRef.orderByChild('senderId').equalTo(localUserId).once();
      final connectionQuery2 =
          connectionRef.orderByChild('receiverId').equalTo(localUserId).once();

      // Espera a que ambas consultas se completen
      final results = await Future.wait([connectionQuery1, connectionQuery2]);

      // Procesa los resultados de la primera consulta
      if (results[0].snapshot.exists) {
        for (var connection in results[0].snapshot.children) {
          if (connection.child('receiverId').value == userId) {
            final connectionMap =
                Map<String, dynamic>.from(connection.value as Map);
            return createConnectionModel(connectionMap);
          }
        }
      }

      // Procesa los resultados de la segunda consulta
      if (results[1].snapshot.exists) {
        for (var connection in results[1].snapshot.children) {
          if (connection.child('senderId').value == userId) {
            final connectionMap =
                Map<String, dynamic>.from(connection.value as Map);
            return createConnectionModel(connectionMap);
          }
        }
      }

      return ConnectionModel(
        connectedAt: DateTime.now(),
        senderId: '',
        receiverId: '',
        connectionStatus: ConnectionStatus.none,
      );
    } catch (e) {
      throw Exception('Failed to check connection: $e');
    }
  }

  @override
  Future<List<Map<String, DateTime>>> getUserConnections(String userId,
      {String? startAfter, int limit = 30}) async {
    try {
      final connectionRef = _realtimeDatabase.ref().child('connections');

      // Realiza ambas consultas en paralelo con paginación
      final connectionQuery1 = connectionRef
          .orderByChild('senderId')
          .equalTo(userId)
          .limitToFirst(limit)
          .once();

      final connectionQuery2 = connectionRef
          .orderByChild('receiverId')
          .equalTo(userId)
          .limitToFirst(limit)
          .once();

      // Espera a que ambas consultas se completen
      final results = await Future.wait([connectionQuery1, connectionQuery2]);

      final connections = <Map<String, DateTime>>[];

      // Procesa los resultados de la primera consulta
      if (results[0].snapshot.exists) {
        for (var connection in results[0].snapshot.children) {
          final connectionData =
              Map<String, dynamic>.from(connection.value as Map);
          print('Connection Data 1: $connectionData');
          final connectionModel = createConnectionModel(connectionData);

          // Filtra las conexiones con estado 'connected'
          if (connectionModel.connectionStatus == ConnectionStatus.connected) {
            connections.add({
              connectionModel.receiverId: connectionModel.connectedAt,
            });
          }
        }
      }

      // Procesa los resultados de la segunda consulta
      if (results[1].snapshot.exists) {
        for (var connection in results[1].snapshot.children) {
          final connectionData =
              Map<String, dynamic>.from(connection.value as Map);
          print('Connection Data 2: $connectionData');
          final connectionModel = createConnectionModel(connectionData);

          // Filtra las conexiones con estado 'connected'
          if (connectionModel.connectionStatus == ConnectionStatus.connected) {
            connections.add({
              connectionModel.senderId: connectionModel.connectedAt,
            });
          }
        }
      }

      return connections;
    } catch (e) {
      throw Exception('Failed to get user connections: $e');
    }
  }
}
