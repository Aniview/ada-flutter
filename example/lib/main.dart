import 'dart:async';
import 'package:ada/ada_config.dart';
import 'package:ada/ada_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profiles.dart';
import 'package:ada/ada.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // UMP writes IABTCF_* keys with no prefix; drop the plugin's default
  // "flutter." prefix so we can read them back. Must run before getInstance().
  SharedPreferences.setPrefix('');

  await Ada.initialize(iosStoreUrl: "https://apps.apple.com/us/app/demo-app/id9999999");
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

  /// Delay before triggering consent, giving time to attach Safari's Web
  /// Inspector to the consent form's WKWebView before it loads. Tweak or
  /// remove once done debugging.
  static const _consentDebugDelay = Duration(seconds: 8);

  @override
  void initState() {
    super.initState();
    _createController();
    Future.delayed(_consentDebugDelay, _requestConsentAndInitAds);
  }

  /// Runs the UMP GDPR/TCF consent flow: refreshes consent info, shows the
  /// consent form if one is due, then hands off to [_finishConsentFlow].
  void _requestConsentAndInitAds() {
    final params = ConsentRequestParameters();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () {
        ConsentForm.loadAndShowConsentFormIfRequired((formError) {
          if (formError != null) {
            debugPrint(
              '[TCF] Consent form error ${formError.errorCode}: ${formError.message}',
            );
          }

          _finishConsentFlow();
        });
      },
      (FormError error) {
        debugPrint(
          '[TCF] Consent info update failed ${error.errorCode}: ${error.message}',
        );

        // Fall back to the previous session's consent decision, if any.
        _finishConsentFlow();
      },
    );
  }

  /// Initializes Mobile Ads if consent allows it, then logs a "granted" /
  /// "not granted" verdict plus the raw IABTCF values read back from
  /// storage, confirming the decision was actually persisted.
  Future<void> _finishConsentFlow() async {
    final granted = await ConsentInformation.instance.canRequestAds();

    if (granted) {
      MobileAds.instance.initialize();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final gdprApplies = prefs.getInt('IABTCF_gdprApplies');
    final tcString = prefs.getString('IABTCF_TCString');

    debugPrint(
      '[TCF] Consent: ${granted ? "granted" : "not granted"} '
      '(gdprApplies=$gdprApplies, TCString=${tcString ?? "<not set>"})',
    );
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