import 'package:autofy_warranty_app/Model/userProductModelForHive.dart';
import 'package:autofy_warranty_app/controllers/apiController.dart';
import 'package:autofy_warranty_app/controllers/authController.dart';
import 'package:autofy_warranty_app/controllers/ocrController.dart';
import 'package:autofy_warranty_app/pages/homepage/homepageController.dart';
import 'package:autofy_warranty_app/pages/homepage/homepageScreen.dart';
import 'package:autofy_warranty_app/pages/repairScreen/repairScreenController.dart';
import 'package:autofy_warranty_app/pages/signIn/signInPage.dart';
import 'package:autofy_warranty_app/services/apiService.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:get/instance_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapter(UserProductModelForHiveAdapter());
  await Hive.openBox<UserProductModelForHive>(BoxNames.userProductBoxName);
  await Hive.openBox('UserData');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(backgroundColor: AppColors.primaryColor),
      ),
      initialBinding: BindingsBuilder(
        () {
          Get.put(ApiService());
          Get.put(AuthController());
          Get.put(OcrController());
          Get.put(ApiController());
          Get.put(HomePageController());
        },
      ),
      title: 'Autofy',
      home: GetDesign(),
    );
  }
}

class GetDesign extends StatefulWidget {
  @override
  _GetDesignState createState() => _GetDesignState();
}

class _GetDesignState extends State<GetDesign> {
  bool alreadyLoggedIn = false;
  @override
  void initState() {
    var userBox = Hive.box('userData');
    alreadyLoggedIn = userBox.get("token") != null ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return alreadyLoggedIn ? HomePageScreen() : SignInPage();
  }
}
