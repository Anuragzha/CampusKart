import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'src/app.dart';

export 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Gracefully initialize Firebase if available; bypasses if credentials are placeholders
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization deferred: $e');
  }

  runApp(const ProviderScope(child: CampusKartApp()));
}
