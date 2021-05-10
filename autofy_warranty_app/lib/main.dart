import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'pages/signIn/signInPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('UserData');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Autofy',
      home: GetDesign(),
    );
  }
}

class GetDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInPage();
  }
}
