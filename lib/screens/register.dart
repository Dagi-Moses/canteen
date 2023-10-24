import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:canteen/screens/main_screen.dart';

import '../util/firebase functions.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameControl = new TextEditingController();
  final TextEditingController _emailControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();
   bool isloading = false;
   bool  obscure = true;
   final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0,0,20,0),
      child: Form(
        key: _formkey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
      
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                top: 25.0,
              ),
              child: Text(
                "Create an account",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
      
            SizedBox(height: 30.0),
      
            Card(
              elevation: 3.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextFormField(
                  validator: (val){
                    return val!.length < 3? 'username must me more than two char': null;
                  },
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.white,),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Username",
                    prefixIcon: Icon(
                      Icons.perm_identity,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  maxLines: 1,
                  controller: _usernameControl,
                ),
              ),
            ),
      
            SizedBox(height: 10.0),
      
            Card(
              elevation: 3.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextFormField(
                   validator: (val){
                    return val!.length < 5? 'not a valid email': null;
                  },
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.white,),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Email",
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  maxLines: 1,
                  controller: _emailControl,
                ),
              ),
            ),
      
            SizedBox(height: 10.0),
      
            Card(
              elevation: 3.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextFormField(
                   validator: (val){
                    return val!.length < 4? 'password must be more than 4 char': null;
                  },
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.white,),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Password",
                    suffix: null,
                      // suffixIcon: GestureDetector(
                      // onTap:(){
                      //   setState(() {
                      //     obscure = !obscure;
                      //   });
                      // },
                      // child: obscure? Icon( Icons.visibility) : Icon( Icons.visibility_off)),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  obscureText:  true,
                  
                  maxLines: 1,
                  controller: _passwordControl,
                ),
              ),
            ),
      
      
            SizedBox(height: 40.0),
      
            Container(
              height: 50.0,
              child: ElevatedButton(
                child:!isloading? Text(
                  "Register".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ): SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator()),
                onPressed: ()async{
      
               if(_formkey.currentState!.validate()){
                     setState(() {
            isloading = true;
            
          });
        try{
       await signUpAndStoreUserData(
            _usernameControl.text,
           // _phoneController.text,
            _emailControl.text,
            _passwordControl.text,
            
            context,
            
          );
            setState(() {
            isloading = false;
            
          });

          
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return MainScreen();
                      },
                    ),
                  );
        }catch (e){
       
            setState(() {
            isloading = false;
            
          });
        }
               }
                },
               style: ElevatedButton.styleFrom(
                 backgroundColor: Theme.of(context).accentColor,
               ),
              ),
            ),
      
            SizedBox(height: 10.0),
            Divider(color: Theme.of(context).accentColor,),
            SizedBox(height: 10.0),
      
      
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                child: Row(
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: (){},
                      fillColor: Colors.blue[800],
                      shape: CircleBorder(),
                      elevation: 4.0,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          FontAwesomeIcons.facebookF,
                          color: Colors.white,
      //              size: 24.0,
                        ),
                      ),
                    ),
      
                    RawMaterialButton(
                      onPressed: (){},
                      fillColor: Colors.white,
                      shape: CircleBorder(),
                      elevation: 4.0,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          FontAwesomeIcons.google,
                          color: Colors.blue[800],
      //              size: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      
            SizedBox(height: 20.0),
      
      
          ],
        ),
      ),
    );
  }
}
