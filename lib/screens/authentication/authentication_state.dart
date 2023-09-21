import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foda_admin/components/base_state.dart';
import 'package:foda_admin/constant/route_name.dart';
import 'package:foda_admin/repositories/user_repository.dart';
import 'package:foda_admin/services/get_it.dart';
import 'package:foda_admin/services/navigation_service.dart';

class AuthenticationState extends BaseState {
  final UserRepository userRepository = locate<UserRepository>();
  final NavigationService navigationService = locate<NavigationService>();

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  AuthenticationState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    emailController.addListener(notifier);
    passwordController.addListener(notifier);
  }

  bool get emailIsValid =>
      emailController.text.trim().isNotEmpty &&
      emailController.text.trim().contains("@");

  @override
  void dispose() {
    emailController.removeListener(notifier);
    passwordController.removeListener(notifier);
    super.dispose();
  }

  void notifier() {
    notifyListeners();
  }

  Future<void> login() async {
    if (!isLoading) {
      setLoading(true);

      final enteredEmail = emailController.text.trim();
      final enteredPassword = passwordController.text.trim();

      // Check if the entered credentials match the predefined user credentials
      if (enteredEmail == 'admin101@gmail.com' && enteredPassword == '123456') {
        // Successful login
        emailController.clear();
        passwordController.clear();
        navigatePushReplaceName(overview);
      } else {
        // Invalid credentials
        showDialog(
          context: navigationService.navigatorKey.currentContext!,
          builder: (_) => const CupertinoAlertDialog(
            title: Text("Invalid Credentials"),
            content: Text("Please enter valid credentials."),
          ),
        );
      }

      setLoading(false);
    }
  }
}
