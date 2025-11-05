import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenWidget();
  }
}

class ProfileScreenWidget extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () async {
                  context.go(AppRoutes.LOGIN_ROUTE_PATH);
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.clear();
                },
                child: Text("Logout"))
          ],
        ),
      ),
    );
  }
}
