import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:foda_admin/services/get_it.dart';
import 'package:foda_admin/utils/common.dart';

import 'app.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyA12Ok2WINHTGrPqa49aT4cPqKtSC3ud3s",
          authDomain: "food-ordering-system-b0880.firebaseapp.com",
          projectId: "food-ordering-system-b0880",
          storageBucket: "food-ordering-system-b0880.appspot.com",
          messagingSenderId: "1078350126846",
          appId: "1:1078350126846:web:55d74fbb16fec7e8e54faf"),
    );

    GetItService.initializeService();
    runApp(const FodaAdmin());
  }, (error, stack) => fodaPrint(error));
}
