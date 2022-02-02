import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget
{
  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();

}

class ResetPasswordScreenState extends State<ResetPasswordScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("We Cop"),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0)
                ),
                labelText: "New Password",
                hintText: "Enter New Password"
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  labelText: "Confirm Password",
                  hintText: "Enter Confirm Password"
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text("Change Password",style: TextStyle(color: Colors.white),)
            )
          ],
        ),
      ),
    );
  }

}