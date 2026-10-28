import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF160B2E), Color(0xFF42205E), Color(0xFF10071F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.nightlight_round,
                size: 90,
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 30),

              SizedBox(
                height: 110,
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'The Haunted\nSignup Mansion',
                        textStyle: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 90),
                      ),
                    ],
                    totalRepeatCount: 1,
                    isRepeatingAnimation: false,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Your journey begins here...',
                style: TextStyle(fontSize: 17, color: Colors.white70),
              ),
              const SizedBox(height: 45),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.door_front_door),
                label: const Text('Enter If You Dare'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
