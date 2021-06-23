import 'package:autofy_warranty_app/pages/profile/profileScreen.dart';
import 'package:autofy_warranty_app/pages/serviceRequests/serviceRequestsScreen.dart';
import 'package:autofy_warranty_app/pages/uploadInvoice/uploadInvoiceScreen.dart';
import 'package:autofy_warranty_app/pages/userProduct/userProductScreen.dart';
import 'package:autofy_warranty_app/utils/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final int startingIndex;
  HomePage({Key? key, required this.startingIndex}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    _currentIndex = widget.startingIndex;
  }

  int _currentIndex = 0;
  final List<Widget> listOfScreens = [
    UserProducts(),
    ServiceRequestsScreen(),
    RegisterWarranty(),
    ProfileSreen()
  ];

  final List<String> appBarTitles = [
    "Your Products",
    "Repair Request",
    "Register Warranty",
    "Your Profile",
  ];

  buildAppBar() {
    return AppBar(
      title: Text(appBarTitles[_currentIndex]),
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
    );
  }

  buildBottomBar() {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey,
      selectedItemColor: AppColors.primaryColor,
      showUnselectedLabels: true,
      currentIndex: _currentIndex,
      onTap: (value) {
        setState(() {
          _currentIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(
          label: "Products",
          icon: Icon(
            Icons.list,
          ),
        ),
        BottomNavigationBarItem(
          label: "Repair Request",
          icon: Icon(
            Icons.handyman_outlined,
          ),
        ),
        BottomNavigationBarItem(
          label: "Register Warranty",
          icon: Icon(
            Icons.library_add_rounded,
          ),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          icon: Icon(
            Icons.person,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: buildAppBar(),
      body: listOfScreens[_currentIndex],
      bottomNavigationBar: buildBottomBar(),
    );
  }
}
