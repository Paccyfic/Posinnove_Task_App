import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
//import 'login.dart';
import 'sign_up.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    const OnboardingPage(
      title: 'Manage your tasks',
      description: 'You can easily manage all of your daily tasks in DoMe for free',
      image: 'assets/images/onboarding1.png',
    ),
    const OnboardingPage(
      title: 'Create daily routine',
      description: 'In Uptodo  you can create your personalized routine to stay productive',
      image: 'assets/images/onboarding2.png',
    ),
    const OnboardingPage(
      title: 'Organize your tasks',
      description: 'You can organize your daily tasks by adding your tasks into separate categories',
      image: 'assets/images/onboarding3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 18, 20, 22),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    final box = Hive.isBoxOpen('settingsBox')
                        ? Hive.box('settingsBox')
                        : await Hive.openBox('settingsBox');
                    await box.put('onboardingComplete', true);
                    if (!mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    'SKIP',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _pages[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage != 0
                      ? GestureDetector(
                          onTap: () {
                            _controller.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                          child: const Text(
                            'BACK',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : const SizedBox(), 
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => buildDot(index, context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_currentPage == _pages.length - 1) {
                        final box = Hive.isBoxOpen('settingsBox')
                            ? Hive.box('settingsBox')
                            : await Hive.openBox('settingsBox');
                        await box.put('onboardingComplete', true);
                        if (!mounted) return;
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7F68F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'GET STARTED' : 'NEXT',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentPage == index ? 20 : 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class OnboardingPage extends ConsumerWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingPage({super.key, 
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35, 
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 40),

          Text(
            title,
            style:const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            description,
            textAlign: TextAlign.center,
            style:const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
