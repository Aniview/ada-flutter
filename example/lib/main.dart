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
      environment: "tg1",
      publisherId: "565c56d3181f46bd608b459a",
      tagId: "689c3cb35bdaa4402808f206",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Ada plugin example"),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        body: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: buildBanner(context),
    );
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
      child: AdaView(
        controller: _controller,
      ),
    );
  }
}