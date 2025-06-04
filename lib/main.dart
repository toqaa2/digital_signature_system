import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:signature_system/firebase_options.dart';
import 'package:signature_system/src/features/login_screen/view/login_screen.dart';
import 'package:signature_system/src/features/login_screen/view/update_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ScreenUtil.ensureScreenSize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> remoteConfig() async {
    PackageInfo packageinfo = await PackageInfo.fromPlatform();
    String appVersion = packageinfo.version;
    final remoteConfig = FirebaseRemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 1)));
    await remoteConfig.fetchAndActivate();
    String remoteConfigVersion = remoteConfig.getString('version');

    print("Appversion = ${appVersion}");
    print("remote version = ${remoteConfigVersion}");
    print(remoteConfigVersion.compareTo(appVersion));
    return remoteConfigVersion.compareTo(appVersion)==1;
  }

  @override
  void initState() {
    remoteConfig();
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Document',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          listTileTheme: ListTileThemeData(
            tileColor: Colors.transparent,
          ),
          useMaterial3: true,
        ),
        home: ScreenUtilInit(
          child: FutureBuilder(
            future: remoteConfig(),
            builder: (context, snapshot) {
              return snapshot.data == false ? UpdatePage() : LoginScreen();
            },
          ),
        ));
  }
}
