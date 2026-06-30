import 'dart:async';
import 'package:ada/ada_config.dart';
import 'package:ada/ada_view.dart';
import 'package:flutter/material.dart';
import 'profiles.dart';
import 'package:ada/ada.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Ada.initialize(iosStoreUrl: "https://apps.apple.com/us/app/demo-app/id9999999");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Profile _selectedProfile = Profile.profileA;

  late AdaViewController _controller;
  StreamSubscription? _eventSubscription;
  String _lastEvent = 'No events yet';

  @override
  void initState() {
    super.initState();
    _createController();
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  void _createController() {
    _eventSubscription?.cancel();

    _controller = AdaViewController(
      config: AdaConfig(
        environment: _selectedProfile.config.environment,
        publisherId: _selectedProfile.config.pubId,
        tagId: _selectedProfile.config.tagId,
      ),
    );

    _eventSubscription = _controller.events.listen((event) {
      if (!mounted) return;

      setState(() {
        _lastEvent = event.runtimeType.toString();
      });
    });
  }

  void _changeProfile(Profile profile) {
    if (_selectedProfile == profile) {
      return;
    }

    setState(() {
      _selectedProfile = profile;
      _createController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(_selectedProfile.title),

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.shade300,
                  ),
                ),
                child: DropdownButton<Profile>(
                  value: _selectedProfile,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Icons.arrow_drop_down),
                  onChanged: (profile) {
                    if (profile != null) {
                      _changeProfile(profile);
                    }
                  },
                  items: Profile.values.map((profile) {
                    return DropdownMenuItem<Profile>(
                      value: profile,
                      child: Text(profile.title),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                'Ada plugin example',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Last event:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _lastEvent,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ///
              /// AdaView 
              /// 
              Expanded(
                child: Center(
                  child: AdaView(
                    controller: _controller,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}