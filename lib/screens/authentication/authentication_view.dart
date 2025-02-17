import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:foda_admin/components/foda_button.dart';
import 'package:foda_admin/components/rounded_card.dart';
import 'package:foda_admin/components/textfield.dart';
import 'package:foda_admin/constant/image_path.dart';
import 'package:foda_admin/screens/authentication/authentication_state.dart';
import 'package:foda_admin/themes/app_theme.dart';
import 'package:provider/provider.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  _AuthenticationViewState createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = true;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthenticationState>();
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.cardPadding),
        child: Column(
          children: [
            // Image.asset(ImagePath.logo, width: 120),
            const SizedBox(height: AppTheme.cardPadding * 2),
            SizedBox(
              width: 500,
              child: RoundedCard(
                color: AppTheme.darkBlue,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.cardPadding),
                  child: Column(
                    children: [
                      Text(
                        "Login",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppTheme.cardPadding),
                      FodaTextfield(
                        title: "Email Address",
                        controller: state.emailController,
                        autofillHints: const [
                          AutofillHints.email,
                        ],
                      ),
                      const SizedBox(height: AppTheme.elementSpacing),
                      TextField(
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        controller: state.passwordController,
                        autofillHints: const [
                          AutofillHints.password,
                        ],
                      ),
                      const SizedBox(height: AppTheme.cardPadding),
                      FodaButton(
                        title: "Login to your account",
                        state: state.isLoading
                            ? ButtonState.loading
                            : (state.emailIsValid
                                ? ButtonState.idle
                                : ButtonState.disabled),
                        onTap: state.login,
                      ),
                      const SizedBox(height: AppTheme.cardPadding),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
