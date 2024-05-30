import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_snap/features/profile/data/models/connection_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_data_source.g.dart';

abstract class UsersDataSource {
  Future<UserModel> getUser(String userId);
  Future<void> addConnection(String localUserId, String userId);
  Future<void> removeConnection(String localUserId, String userId);
  Future<bool> checkConnection(String localUserId, String userId);
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
  Future<void> addConnection(String localUserId, String userId) async {
    try {
      final localUserRef = _firestore.collection('users').doc(localUserId);
      final userRef = _firestore.collection('users').doc(userId);
      final connectionRef = _realtimeDatabase.ref().child('connections').push();

      await _firestore.runTransaction((transaction) async {
        transaction.update(userRef, {
          'connectionsCount': FieldValue.increment(1),
        });
        transaction.update(localUserRef, {
          'connectionsCount': FieldValue.increment(1),
        });
      });

      await connectionRef.set({
        'userId': localUserId,
        'connectionUserId': userId,
        'connectedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add connection: $e');
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
          .orderByChild('userId')
          .equalTo(localUserId)
          .once();

      final connectionQuery2 = _realtimeDatabase
          .ref()
          .child('connections')
          .orderByChild('connectionUserId')
          .equalTo(localUserId)
          .once();

      // Espera a que ambas consultas se completen
      final results = await Future.wait([connectionQuery1, connectionQuery2]);

      String? connectionKey;

      // Procesa los resultados de la primera consulta
      if (results[0].snapshot.exists) {
        for (var connection in results[0].snapshot.children) {
          if (connection.child('connectionUserId').value == userId) {
            connectionKey = connection.key;
            break;
          }
        }
      }

      // Procesa los resultados de la segunda consulta si no se encontró en la primera
      if (connectionKey == null && results[1].snapshot.exists) {
        for (var connection in results[1].snapshot.children) {
          if (connection.child('userId').value == userId) {
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
  Future<bool> checkConnection(String localUserId, String userId) async {
    try {
      final connectionRef = _realtimeDatabase.ref().child('connections');

      // Realiza ambas consultas en paralelo
      final connectionQuery1 =
          connectionRef.orderByChild('userId').equalTo(localUserId).once();

      final connectionQuery2 = connectionRef
          .orderByChild('connectionUserId')
          .equalTo(localUserId)
          .once();

      // Espera a que ambas consultas se completen
      final results = await Future.wait([connectionQuery1, connectionQuery2]);

      // Procesa los resultados de la primera consulta
      if (results[0].snapshot.exists) {
        for (var connection in results[0].snapshot.children) {
          if (connection.child('connectionUserId').value == userId) {
            return true;
          }
        }
      }

      // Procesa los resultados de la segunda consulta
      if (results[1].snapshot.exists) {
        for (var connection in results[1].snapshot.children) {
          if (connection.child('userId').value == userId) {
            return true;
          }
        }
      }

      return false;
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
      final connectionQuery1 = startAfter != null
          ? connectionRef
              .orderByChild('userId')
              .equalTo(userId)
              .startAt(startAfter)
              .limitToFirst(limit)
              .once()
          : connectionRef
              .orderByChild('userId')
              .equalTo(userId)
              .limitToFirst(limit)
              .once();

      final connectionQuery2 = startAfter != null
          ? connectionRef
              .orderByChild('connectionUserId')
              .equalTo(userId)
              .startAt(startAfter)
              .limitToFirst(limit)
              .once()
          : connectionRef
              .orderByChild('connectionUserId')
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
          final connectionModel = ConnectionModel.fromJson(connectionData);
          connections.add({
            connectionModel.connectionUserId: connectionModel.connectedAt,
          });
        }
      }

      // Procesa los resultados de la segunda consulta
      if (results[1].snapshot.exists) {
        for (var connection in results[1].snapshot.children) {
          final connectionData =
              Map<String, dynamic>.from(connection.value as Map);
          final connectionModel = ConnectionModel.fromJson(connectionData);
          connections.add({
            connectionModel.userId: connectionModel.connectedAt,
          });
        }
      }

      return connections;
    } catch (e) {
      throw Exception('Failed to get user connections: $e');
    }
  }
}
