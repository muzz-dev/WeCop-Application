import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomePageScreen.dart';
import 'package:flutter_app/Screens/PreserveHome.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreserveHomeIntroductionPages extends StatefulWidget{
  @override
  PreserveHomeIntroductionPagesState createState()=>PreserveHomeIntroductionPagesState();
}

class PreserveHomeIntroductionPagesState extends State<PreserveHomeIntroductionPages>{
  var id="";
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void initState() {
    // TODO: implement initState
    _checkUser();
    super.initState();
  }

  void _checkUser()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("userid");
    print(id);
  }
  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PreserveHome()),
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
            if(id==""){
              CoolAlert.show(
                  context: context,
                  type: CoolAlertType.error,
                  text:
                  "You need to login to view this content. Please Login",
                  confirmBtnText: 'Login',
                  cancelBtnText: 'Cancel',
                  onConfirmBtnTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("Login");
                  });
            }else{
              _onIntroEnd(context);
            }
          },
        ),
      ),
      pages: [
        PageViewModel(
          title: "Secure your home",
          body:
          "Give your home credentials and we'll send it to nearby police station.",
          image: _buildImage('preservehome.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Security on single touch",
          body:
          "On one tap, you'll get your home secure by daily petrolling police officer.",
          image: _buildImage('preservehome.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Constant observation & your home survelliance",
          body:
          "Your location is highlighted to petrolling police until your specified date.",
          image: _buildImage('preservehome.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Your home, our responsibility",
          body:
          "Tension free travelling to our registered users.",
          image: _buildImage('preservehome.jpg'),
          decoration: pageDecoration,
        ),



      ],
      onDone: () {
          if(id==""){
            CoolAlert.show(
                context: context,
                type: CoolAlertType.error,
                text:
                "You need to login to view this content. Please Login",
                confirmBtnText: 'Login',
                cancelBtnText: 'Cancel',
                onConfirmBtnTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed("Login");
                });
          }else{
            _onIntroEnd(context);
          }
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