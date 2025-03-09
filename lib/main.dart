import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature_system/firebase_options.dart';
import 'package:signature_system/src/Features/login_screen/view/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
  await Supabase.initialize(
    url: "https://rmpfzdccuxeuyshwqprc.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtcGZ6ZGNjdXhldXlzaHdxcHJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE1MTgyMTgsImV4cCI6MjA1NzA5NDIxOH0.RQJT1W26lkU1M6J9f2Uc-svP_RAzKF6f1fmVTtmJF-c",
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        listTileTheme: ListTileThemeData(
          tileColor: Colors.transparent,
        ),
        useMaterial3: true,
      ),
      home: ScreenUtilInit(child: const LoginScreen()),
    );
  }
}