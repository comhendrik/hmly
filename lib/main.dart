import 'package:flutter/material.dart';
import 'package:hmly/features/authentication/presentation/pages/auth_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HMLY',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
          primary: false,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            bottom: false,
            child: AuthPage(),
          )
      ),
    );
  }
}


