import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;
  String _status = 'Waiting for link...';

  @override
  void initState() {
    super.initState();
    initAppLinks();
  }

  Future<void> initAppLinks() async {
    _appLinks = AppLinks();

    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleIncomingLink(initialUri);
      }

      _sub = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          if (uri != null) _handleIncomingLink(uri);
        },
        onError: (err) {
          setState(() => _status = 'Failed to receive link: $err');
        },
      );
    } catch (e) {
      setState(() => _status = 'Error initializing app links: $e');
    }
  }

  void _handleIncomingLink(Uri uri) {
    setState(() => _status = 'Opened link: $uri');

    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'details') {
      final id = uri.queryParameters['id'] ?? 'unknown';
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(id: id)),
      );
      return;
    }

    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'profile') {
      final username = uri.pathSegments.length > 1
          ? uri.pathSegments[1]
          : 'guest';
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProfileScreen(username: username)),
      );
      return;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Link Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Center(child: Text(_status)),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(child: Text('You opened item ID: $id')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String username;
  const ProfileScreen({required this.username, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(child: Text('Hello, $username!')),
    );
  }
}
