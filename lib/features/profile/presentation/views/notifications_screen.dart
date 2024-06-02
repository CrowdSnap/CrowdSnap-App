import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notifications = prefs.getStringList('notifications') ?? [];
    setState(() {
      _notifications = notifications.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    });
  }

  Future<Image?> _loadImage(String? imageUrl) async {
    if (imageUrl == null) return null;
    final prefs = await SharedPreferences.getInstance();
    final imageData = prefs.getString(imageUrl);
    if (imageData != null) {
      return Image.memory(base64Decode(imageData));
    }
    return null;
  }

  Future<void> _deleteNotification(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notifications = prefs.getStringList('notifications') ?? [];
    notifications.removeAt(index);
    await prefs.setStringList('notifications', notifications);
    setState(() {
      _notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones Recientes'),
      ),
      body: _notifications.isEmpty
          ? const Center(child: Text('No hay notificaciones recientes'))
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key(notification['timestamp']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteNotification(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notificación eliminada')),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: FutureBuilder<Image?>(
                    future: _loadImage(notification['imageUrl']),
                    builder: (context, snapshot) {
                      return ListTile(
                        leading: snapshot.data ?? const Icon(Icons.notifications),
                        title: Text(notification['title'] ?? 'Sin título'),
                        subtitle: Text(notification['body'] ?? 'Sin contenido'),
                        trailing: Text(notification['timestamp'] ?? ''),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}