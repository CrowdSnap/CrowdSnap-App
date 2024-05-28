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
  Future<List<ConnectionModel>> getUserConnections(String userId);
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
      });

      await _firestore.runTransaction((transaction) async {
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

      // Encuentra el nodo de conexión a eliminar
      final connectionQuery = await _realtimeDatabase
          .ref()
          .child('connections')
          .orderByChild('connectionUserId')
          .equalTo(userId)
          .once();

      if (connectionQuery.snapshot.exists) {
        final connectionKey = connectionQuery.snapshot.children.first.key;

        // Elimina el nodo de conexión
        await _realtimeDatabase
            .ref()
            .child('connections')
            .child(connectionKey!)
            .remove();

        // Actualiza el conteo de conexiones en Firestore
        await _firestore.runTransaction((transaction) async {
          transaction.update(localUserRef, {
            'connectionsCount': FieldValue.increment(-1),
          });
        });

        await _firestore.runTransaction((transaction) async {
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
      final connectionQuery = await _realtimeDatabase
          .ref()
          .child('connections')
          .orderByChild('userId')
          .equalTo(localUserId)
          .once();

      if (connectionQuery.snapshot.exists) {
        for (var connection in connectionQuery.snapshot.children) {
          if (connection.child('connectionUserId').value == userId) {
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
  Future<List<ConnectionModel>> getUserConnections(String userId) async {
    try {
      final connectionQuery = await _realtimeDatabase
          .ref()
          .child('connections')
          .orderByChild('userId')
          .equalTo(userId)
          .once();

      if (connectionQuery.snapshot.exists) {
        final connections = <ConnectionModel>[];
        for (var connection in connectionQuery.snapshot.children) {
          connections.add(ConnectionModel.fromJson(
              connection.value as Map<String, dynamic>));
        }
        return connections;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get user connections: $e');
    }
  }
}
