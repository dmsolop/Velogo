import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242527),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: _HeaderText(),
            ),
            const _DescriptionText(),
            const _LogoImage(),
            const _GetStartedButton(),
            const _FooterText(),
          ],
        ),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'VELOGO',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
    );
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Track your rides and explore new routes effortlessly.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _LogoImage extends StatelessWidget {
  const _LogoImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://assets.api.uizard.io/api/cdn/stream/4f2572ff-e7da-48c5-b076-a4dccb1d8584.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Обробка натискання кнопки
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF32596A),
        minimumSize: const Size(327, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: const Text(
        'Get started',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _FooterText extends StatelessWidget {
  const _FooterText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already part of the team?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // Обробка переходу на "Sign in"
            },
            child: Text(
              'Sign in',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
