import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomePageScreen.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WomenSafetyIntroductionPages extends StatefulWidget{
  @override
  WomenSafetyIntroductionPagesState createState()=>WomenSafetyIntroductionPagesState();
}

class WomenSafetyIntroductionPagesState extends State<WomenSafetyIntroductionPages>{
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HomePageScreen()),
    );
  }

  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }
  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('images/$assetName', width: width);
  }


  @override
  Widget build(BuildContext context) {

    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Let\s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          // onPressed: () => _onIntroEnd(context),
          onPressed: (){
              _onIntroEnd(context);
          },
        ),
      ),
      pages: [
        PageViewModel(
          title: "24/7 Police Assistance",
          body:
          "Get police assistance when you are in trouble in one tap.",
          image: _buildImage('womensafety.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "One-Tap Contact",
          body:
          "Get in contact with your nearest police station.",
          image: _buildImage('womensafety.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Flexible Accessibility",
          body:
          "We always protect with you whenever you go.",
          image: _buildImage('womensafety.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Our Motive",
          body:
          "Your security is what we are sworn to.",
          image: _buildImage('womensafety.jpg'),
          decoration: pageDecoration,
        ),



      ],
      onDone: () {
          _onIntroEnd(context);
      },
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}