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
    _appLinks = AppLinks();

    initAppLinks();
  }

  void initAppLinks() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) _handleIncomingLink(initialUri);
    } catch (e) {
      setState(() => _status = 'Failed to get initial link: $e');
    }

    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        if (uri != null) _handleIncomingLink(uri);
      },
      onError: (err) {
        setState(() => _status = 'Failed to receive link: $err');
      },
    );
  }

  void _handleIncomingLink(Uri uri) {
    setState(() => _status = 'Received link: $uri');

    if (uri.host == 'details') {
      final id = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : 'unknown';
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen(id: id)),
      );
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
      title: 'App Link Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Center(child: Text(_status)),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details')),
      body: Center(child: Text('You opened item ID: $id')),
    );
  }
}
