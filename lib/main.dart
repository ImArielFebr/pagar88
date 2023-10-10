import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:p88/pages/admin/admin.dart';
import 'package:p88/pages/home/home.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  Intl.defaultLocale = 'id';
  
  FlutterNativeSplash.remove();
  initializeDateFormatting('id', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){

    return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AnimatedSplashScreen(
            splashIconSize: 300,
            curve: Curves.easeInCirc,
              duration: 2500,
              animationDuration: const Duration(seconds: 2),
              splash: Image.asset("assets/logo.png"),
              nextScreen: const authMasuk(),
              splashTransition: SplashTransition.fadeTransition,
              backgroundColor: Colors.lightBlue),

          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
              primaryColor: Colors.lightBlue,
              brightness: Brightness.light,
              textTheme: TextTheme(
                  bodyMedium: GoogleFonts.sourceSansPro(fontSize: 11.0 , ),
                  bodyLarge: GoogleFonts.sourceSansPro(fontSize: 13.0 ,),
                  bodySmall: GoogleFonts.sourceSansPro(fontSize: 9.0,),
                  titleLarge: GoogleFonts.sourceSansPro(fontSize: 18.0 , fontWeight: FontWeight.normal),
                  titleMedium: GoogleFonts.sourceSansPro(fontSize: 16.0 , fontWeight: FontWeight.normal),
                  titleSmall: GoogleFonts.sourceSansPro(fontSize: 14.0 , fontWeight: FontWeight.normal),
                  headlineLarge: GoogleFonts.sourceSansPro(fontSize: 40.0 , fontWeight: FontWeight.bold),
                  headlineMedium: GoogleFonts.sourceSansPro(fontSize: 30.0 , fontWeight: FontWeight.bold),
                  headlineSmall: GoogleFonts.sourceSansPro(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              colorScheme:
              ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue).copyWith(background: Colors.lightBlue),
      ),
    );
  }
}

class authMasuk extends StatelessWidget {
  const authMasuk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            return const Admin();
          } else {
            return const Home();
          }
        },
    )
    );
  }
}

