import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xmed/assets/constants/app_icons.dart';
import 'package:xmed/assets/constants/colors.dart';
import 'package:xmed/core/widgets/w_button.dart';

import 'package:xmed/core/widgets/w_scale_animation.dart';
import 'package:xmed/core/widgets/w_textfield.dart';
import 'package:xmed/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:xmed/features/auth/presentation/pages/example.dart';
import 'package:xmed/features/auth/presentation/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController mailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    mailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    mailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(100 + MediaQuery.of(context).padding.top),
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(color: white, boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.16),
              blurRadius: 16,
            )
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WScaleAnimation(
                onTap: () {
                  
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SvgPicture.asset(AppIcons.arrowLeft),
                ),
              ),
              Align(child: SvgPicture.asset(AppIcons.logoMain)),
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(width: 24),
              ),
            ],
          ),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const ExampleScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
              child: Column(
                children: [
                  Text(
                    "Kirish".trim(),
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 34),
                  WTextField(
                    title: 'Email',
                    fillColor: white,
                    hintText: 'Email...',
                    controller: mailController,
                    onChanged: (_) {},
                    onEditCompleted: () {
                      FocusScope.of(context).unfocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  WTextField(
                    title: 'Maxfiylik kaliti',
                    fillColor: white,
                    hintText: 'Maxfiylik kalitini kiriting...',
                    keyBoardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    onChanged: (_) {},
                    isObscureText: true,
                    onEditCompleted: () {
                      FocusScope.of(context).unfocus();
                    },
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  WButton(
                    margin: const EdgeInsets.all(0),
                    border: Border.all(width: 1, color: stroke),
                    onTap: () {
                      context.read<AuthBloc>().add(
                            AuthenticationLoginRequestedEvent(
                              email: mailController.text,
                              password: passwordController.text,
                              onSuccess: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => const ExampleScreen()),
                                  (route) => false,
                                );
                              },
                              onFailure: (message) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)));
                              },
                            ),
                          );
                    },
                    text: "Kirish",
                    textStyle:
                        Theme.of(context).textTheme.headline1!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          WButton(
            margin: const EdgeInsets.all(16),
            color: white,
            border: Border.all(width: 1, color: stroke),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SignUpScreen()),
              );
            },
            text: "Ro'yxatdan o'tish",
            textStyle: Theme.of(context).textTheme.headline1!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
