import 'package:firebase_primaapp/handlers/auth_handlers.dart';
import 'package:firebase_primaapp/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:firebase_primaapp/component/ti_component.dart';
import 'package:email_validator/email_validator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    final ReactiveModel<UserStore> _userStore = Injector.getAsReactive<UserStore>(context: context);

    return Container(
      child: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Tugas Membuat Firebase \nPrima Putra - 181011400585 - 06TPLE010"),
            SizedBox(height: 30.0,),
            TiComponent(
              label: "Email",
              hint: "User@gmail.com",
              keyboardType: TextInputType.emailAddress,
              validate: (String value) {
                if (value.isEmpty){
                  return "Email Diperlukan";
                }else if (!EmailValidator.validate(value)) {
                  return "Email Tidak Tesedia";
                }else {
                  return null;
                }
              },
              change: (String value) {
                email = value;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            TiComponent(
              label: "Password",
              hint: "Kata Sandi",
              isPassword: true,
              validate: (String value) {
                if (value.isEmpty){
                  return "Password Diperlukan";
                }else {
                  return null;
                }
              },
              change: (String value) {
                password = value;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                RaisedButton(
                  child: Text(
                    "Masuk",
                    style: TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.bold,
                      ),
                    ),
                  color: Colors.red,
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                     final AuthHandler _auth = AuthHandler(
                       email: email,
                       password: password
                     );

                     final Map<String, dynamic> status = await _auth.signIn();
                     final ReactiveModel<UserStore> _userStore = Injector.getAsReactive<UserStore>(context: context);

                     if (status ["isvalid"]) {
                       _userStore.setState((state) => state.setLogStatus(true));
                     } else {
                       Scaffold.of(context).showSnackBar(
                         SnackBar(
                           content: Text(status["data"]),
                         )
                       );
                     }
                    }
                  },
                ),
                FlatButton(
                  child: Text(
                    "Registerasi",
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  onPressed: () {
                    _userStore.setState((state) => state.setRegisterStatus(true));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}