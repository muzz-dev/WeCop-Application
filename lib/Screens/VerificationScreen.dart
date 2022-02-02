import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class VerificationScreen extends StatefulWidget
{
  @override
  VerificationScreenState createState() => VerificationScreenState();

}

class VerificationScreenState extends State<VerificationScreen>
{

  String id="",otp="";
  TextEditingController _otp = new TextEditingController();

  @override
  Widget build(BuildContext context) {


    final Map arg = ModalRoute.of(context).settings.arguments as Map;

    if(arg!=null)
    {
      setState(() {
        id=arg["userid"];
        otp=arg["otp"];
      });
    }


    return Scaffold(
      appBar: AppBar(
        title:  Text("OTP Authentication"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0,0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextField(
                controller: _otp,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: "OTP",
                    hintText: "Enter Your OTP Here"
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                  onTap: () async
                  {
                    if(otp==_otp.text.toString())
                    {
                      var url = Uri.parse(Config.UPDATE_REGISTER_STATUS);
                      var response = await http.post(url,body: {"id":id});
                      if(response.statusCode==200)
                      {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed("Login");
                      }
                      else
                      {

                      }
                    }
                    else
                    {
                      Fluttertoast.showToast(
                          msg: "Invalid OTP !!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    color: Colors.blue.shade900,
                    alignment: Alignment.center,
                    child: Text("Verify",style: TextStyle(color: Colors.white),),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

}