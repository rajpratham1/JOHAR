import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStore.init();

  // TODO(johar): enable Firebase once `flutterfire configure` has generated
  // firebase_options.dart and the firebase_* packages are un-commented:
  //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const JoharApp());
}
