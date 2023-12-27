import 'package:drip/data/repositories/authentication/authentication_repository.dart';
import 'package:drip/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:drip/app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {

  // Widgets Binding 
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // GetX Local Storage
  await GetStorage.init();

  // Todo: Await Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Init Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
   .then((FirebaseApp value) => Get.put(AuthenticationRepository()));
  
  runApp(App());

}