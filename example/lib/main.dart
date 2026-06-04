import 'package:ada/ada_config.dart';
import 'package:ada/ada_view.dart';
import 'package:flutter/material.dart';
import 'profiles.dart';

void main() {
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

  @override
  void initState() {
    super.initState();
    _createController();
  }

  void _createController() {
    _controller = AdaViewController(
      config: AdaConfig(
        environment: _selectedProfile.config.environment,
        publisherId: _selectedProfile.config.pubId,
        tagId: _selectedProfile.config.tagId,
      ),
    );
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
          title: const Text('Ada plugin example'),
          backgroundColor: Colors.white,
          elevation: 0,
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

              Text(
                _selectedProfile.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 4,
                      ),
                    ),
                    child: AdaView(
                      controller: _controller,
                    ),
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