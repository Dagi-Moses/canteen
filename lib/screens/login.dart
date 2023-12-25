import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../util/firebase functions.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final TextEditingController _emailControl = TextEditingController();
  final TextEditingController _passwordControl = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: 25.0,
                ),
                child: Text(
                  app.loginToAccount,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
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
                    validator: (val) {
                      return val!.length < 3 ? app.invalidEmail : null;
                    },
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: app.email,
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      prefixIcon: Icon(
                        Icons.perm_identity,
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
                    validator: (val) {
                      return val!.length < 3 ? app.invalidPassword : null;
                    },
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: app.password,
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          child: obscure
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    obscureText: obscure,
                    maxLines: 1,
                    controller: _passwordControl,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text(
                    app.forgotPassword,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                height: 50.0,
                child: ElevatedButton(
                  child: !isLoading
                      ? Text(
                          app.login.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      : SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(),
                        ),
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      signInUser(
                        email: _emailControl.text,
                        password: _passwordControl.text,
                        context: context,
                        setIsLoading: (loading) {
                          setState(() {
                            isLoading = loading;
                          });
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
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
