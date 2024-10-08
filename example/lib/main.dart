import 'package:ada/ada_config.dart';
import 'package:ada/ada_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = AdaViewController(
    config: const AdaConfig(
      environment: "wlgo1.dev4",
      publisherId: "60fff8fbe80e7b248329d192",
      tagId: "66869bd1f9169753980c0c45",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Ada plugin example"),
        ),
        body: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(child: buildBanner(context));
  }

  Widget buildBanner(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.onSurface,
          width: 4,
        ),
      ),
      child: AdaView(controller: _controller),
    );
  }
}
