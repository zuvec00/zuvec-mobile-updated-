import 'package:firebase_practice/pages/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../components/my_containers/my_onboarding.dart';
import '../util/onborading_details.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  bool onLastPage = false;

  final OnBoardingDetails details = OnBoardingDetails();

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[100],
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7.5),
              child: Image.asset('lib/assets/paystack_logo.png', width: 45),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    _controller
                        .jumpToPage(details.onBoardingContent.length - 1);
                  },
                  child: Text('skip',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[600]))),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (index) {
                      if (index == details.onBoardingContent.length - 1) {
                        setState(() {
                          onLastPage = true;
                        });
                      } else {
                        setState(() {
                          onLastPage = false;
                        });
                      }
                    },
                    itemCount: details.onBoardingContent.length,
                    itemBuilder: (context, index) {
                      return OnBoardingContainer(
                        onBoardingImage: details.onBoardingImages[index],
                        onBoardingTitle: details.onBoardingTitles[index],
                        onBoardingContent: details.onBoardingContent[index],
                      );
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                      controller: _controller,
                      count: details.onBoardingContent.length,
                      effect: ExpandingDotsEffect(
                          expansionFactor: 4,
                          dotWidth: 8,
                          dotHeight: 8,
                          activeDotColor: Colors.grey[900]!,
                          dotColor: Colors.grey[500]!)),
                  onLastPage
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const LoginOrRegisterPage())));
                          },
                          child: Text('Get Started',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple[600])),
                        )
                      : InkWell(
                          onTap: () {
                            _controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Text('next',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple[600])),
                        ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ));
  }
}
