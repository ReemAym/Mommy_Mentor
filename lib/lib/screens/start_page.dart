import 'package:flutter/material.dart';
import '../component/button.dart';
import '../models/app_colors.dart';
import 'choose_account_page.dart';
import 'signin_page.dart';


class StartPage extends StatelessWidget {
  const StartPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, AppColors.primaryColor])),
          child: Column(children: [
            const Spacer(
              flex: 3,
            ),
            const Text(
              'Get Started',
              style: TextStyle(fontSize: 34),
            ),
            const Spacer(
              flex: 2,
            ),
            const Text(
              'Your Trusted Guide To Baby Care',
              style: TextStyle(fontSize: 18),
            ),
            const Spacer(
              flex: 2,
            ),
            Container(
              width: 400,
              child: const Image(
                image: AssetImage('assets/image/get_started.png'),
              ),
            ),
            const Spacer(
              flex: 3,
            ),
            Button(
                text: 'Sign In',
                background_color: Colors.white,
                text_color: Colors.black,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SignIn();
                  }));
                }),
            const Spacer(
              flex: 2,
            ),
            Button(
                text: 'Create Account ',
                background_color: Colors.white,
                text_color: Colors.black,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ChooseAccount();
                  }));
                }),
            const Spacer(
              flex: 3,
            ),
          ]),
        ),
      ),
    );
  }
}
