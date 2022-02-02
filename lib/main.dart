import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/AllocatedFIR.dart';
import 'package:flutter_app/Screens/AllocatedHomeDetails.dart';
import 'package:flutter_app/Screens/AllocatedHomeScreen.dart';
import 'package:flutter_app/Screens/ChangePasswordScreen.dart';
import 'package:flutter_app/Screens/CovidRegistration.dart';
import 'package:flutter_app/Screens/DemoCurrentLocation.dart';
import 'package:flutter_app/Screens/DemoDrawer.dart';
import 'package:flutter_app/Screens/DemoImagePicker.dart';
import 'package:flutter_app/Screens/EmergencyNumber.dart';
import 'package:flutter_app/Screens/FIRDetailsScreen.dart';
import 'package:flutter_app/Screens/FIRLogsScreen.dart';
import 'package:flutter_app/Screens/FIRStatusScreen.dart';
import 'package:flutter_app/Screens/FeedbackScreen.dart';
import 'package:flutter_app/Screens/ForgotPasswordOTPScreen.dart';
import 'package:flutter_app/Screens/ForgotPasswordScreen.dart';
import 'package:flutter_app/Screens/HomePageScreen.dart';
import 'package:flutter_app/Screens/LoginScreen.dart';
import 'package:flutter_app/Screens/MissingPersonDetailsScreen.dart';
import 'package:flutter_app/Screens/MissingPersonListScreen.dart';
import 'package:flutter_app/Screens/NewsDetailsScreen.dart';
import 'package:flutter_app/Screens/NewsListScreen.dart';
import 'package:flutter_app/Screens/PoliceLoginScreen.dart';
import 'package:flutter_app/Screens/PoliceStatioDetailsScreen.dart';
import 'package:flutter_app/Screens/PoliceStationListScreen.dart';
import 'package:flutter_app/Screens/PreserveHome.dart';
import 'package:flutter_app/Screens/PreserveHomeIntroductionPages.dart';
import 'package:flutter_app/Screens/RegistrationOTPScreen.dart';
import 'package:flutter_app/Screens/RegistrationScreen.dart';
import 'package:flutter_app/Screens/ResetPasswordScreen.dart';
import 'package:flutter_app/Screens/SplashScreen.dart';
import 'package:flutter_app/Screens/VehicleDetailsScreen.dart';
import 'package:flutter_app/Screens/VehicleScreen.dart';
import 'package:flutter_app/Screens/VerificationScreen.dart';
import 'package:flutter_app/Screens/WantedPersonDetailsScreen.dart';
import 'package:flutter_app/Screens/WantedPersonScreen.dart';
import 'package:flutter_app/Screens/CovidTracker.dart';
import 'package:flutter_app/Screens/WomenSafetyIntroductionPages.dart';
import 'package:flutter_app/Screens/infowindow.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/constants.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => InfoWindowModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeCop',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.dark,
        // primarySwatch: Colors.deepPurple,
        primaryColor: kPrimaryColor,
      ),
      home: SplashScreen(),
      routes: {
        'PreserveHome': (BuildContext context) => PreserveHome(),
        'Home': (BuildContext context) => HomePageScreen(),
        'Register': (BuildContext context) => RegistrationScreen(),
        'ResetPassword': (BuildContext context) => ResetPasswordScreen(),
        'Login': (BuildContext context) => LoginScreen(),
        'PoliceLogin': (BuildContext context) => PoliceLoginScreen(),
        'ForgotPassword': (BuildContext context) => ForgotPasswordScreen(),
        'ForgotPasswordOTP': (BuildContext context) =>
            ForgotPasswordOTPScreen(),
        'Feedback': (BuildContext context) => FeedbackScreen(),
        'EmergencyNumber': (BuildContext context) => EmergencyNumber(),
        'ChangePassword': (BuildContext context) => ChangePasswordScreen(),
        'MissingPersonList': (BuildContext context) =>
            MissingPersonListScreen(),
        'MissingPersonDetails': (BuildContext context) =>
            MissingPersonDetailsScreen(),
        'Vehicle': (BuildContext context) => VehicleScreen(),
        'VehicleDetails': (BuildContext context) => VehicleDetailsScreen(),
        'WantedPerson': (BuildContext context) => WantedPersonScreen(),
        'WantedPersonDetails': (BuildContext context) =>
            WantedPersonDetailsScreen(),
        'PoliceStationList': (BuildContext context) =>
            PoliceStationListScreen(),
        'PoliceStationDetails': (BuildContext context) =>
            PoliceStatioDetailsScreen(),
        'RegistrationOTP': (BuildContext context) => RegistrationOTPScreen(),
        'NewsList': (BuildContext context) => NewsListScreen(),
        'NewsDetails': (BuildContext context) => NewsDetailsScreen(),
        'Verification': (BuildContext context) => VerificationScreen(),
        'FIRStatus': (BuildContext context) => FIRStatusScreen(),
        'FIRLogs': (BuildContext context) => FIRLogsScreen(),
        'SplashScreen': (BuildContext context) => SplashScreen(),
        'LocationDemo': (BuildContext context) => CurrentLocation(),
        'AddFeedback': (BuildContext context) => FeedbackScreen(),
        'ImagePickerDemo': (BuildContext context) => ImagePickerDemo(),
        'DrawerDemo': (BuildContext context) => MyHomePage(),
        'HomeIntroduction': (BuildContext context) =>
            PreserveHomeIntroductionPages(),
        'WomenSafetyIntroduction': (BuildContext context) =>
            WomenSafetyIntroductionPages(),
        'AllocatedFIR': (BuildContext context) => AllocatedFIR(),
        'FIRDetails': (BuildContext context) => FIRDetailsScreen(),
        'AllocatedHome': (BuildContext context) => AllocatedHome(),
        'AllocatedHomeDetails': (BuildContext context) =>
            AllocatedHomeDetails(),
        'CovidTracker': (BuildContext context) => CovidTracker(),
        'CovidRegistration': (BuildContext context) => CovidRegistration(),
      },
    );
  }
}
