import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_polynomial/pages/module.dart';
import 'package:my_polynomial/models/module.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dashboard.dart';

class SignIn extends StatefulWidget{
  SignIn({Key key}):super(key:key);

  @override
  SignInState createState()=> SignInState();
}

class SignInState extends State<SignIn>{
  TextEditingController username_signin=new TextEditingController();
  TextEditingController password_signin=new TextEditingController();
  TextEditingController polynomial_controller=new TextEditingController();
  final _formKey=GlobalKey<FormState>();
  Validation validation=Validation();
  Parser p = Parser();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFirebase();
  }

  initFirebase() async{
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 140.0,horizontal: 20.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 4/6,

                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(1.0,1.0),
                          spreadRadius: 1.0,
                          blurRadius: 1.0,
                          color: Colors.black12
                      )
                    ]
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
                      child: Text("My App",style: TextStyle(
                          fontSize: 24,color: Colors.lightBlue,fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.creteRound().fontFamily
                      ),),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0),
                      child: Text("Sign In to your account",style: TextStyle(
                          fontSize: 12,color: Colors.black54,fontWeight: FontWeight.w500,
                          fontFamily: GoogleFonts.creteRound().fontFamily
                      ),),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 30.0),
                      child: Divider(color: Colors.grey.shade300,height: 10,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 20.0),
                      child: TextFormField(
                        controller: username_signin,
                        keyboardType: TextInputType.name,
                        validator: validation.nameValidator,
                        decoration: InputDecoration(
                            hintText: 'Enter Username',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            hintStyle: TextStyle(fontSize: 11),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide.none
                              //   borderSide: BorderSide(color: Colors.white)
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0,
                          horizontal: 20.0),
                      child: TextFormField(
                        controller: password_signin,
                        validator: validation.pwdValidator,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          hintText: 'Password',
                          hintStyle: TextStyle(fontSize: 11),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none
                            //   borderSide: BorderSide(color: Colors.white),
                          ),

                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0,left: 20.0,right: 20.0),
                      child: TextFormField(
                        controller: polynomial_controller,
                        validator: validation.checkPolynomial,
                        decoration: InputDecoration(
                            hintText: 'Enter polynomial',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            hintStyle: TextStyle(fontSize: 11),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide.none
                              //   borderSide: BorderSide(color: Colors.white)
                            )
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child:  ElevatedButton(
                            child: Text("Log In",style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              if(_formKey.currentState.validate()){
                                addData().then((value){
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Dashboard()));
                                });
                              }

                       //       Navigator.push(context,MaterialPageRoute(builder: (context)=> Dashboard()));
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue
                            ),
                          ),
                        )
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addData() async{
    User user=new User();
    user.username=username_signin.text;
    user.password=password_signin.text;
    user.polynomial=polynomial_controller.text;
    await FirebaseFirestore.instance.collection("users").doc("userData").set({
      "name":user.username,
      "password":user.password,
      "polynomial":user.polynomial,
      "derivative":getpoly(user.polynomial)
    }).whenComplete((){
      print("User successfully created");
    }).catchError((onError){
      print("Error creating user");
    });
  }

  String getpoly(String polynomial){
    //Expression exp = p.parse("x*1 - (-5)");
    Expression exp=p.parse(polynomial);

    print(exp);            // = ((x * 1.0) - -(5.0))
    print(exp.simplify()); // = (x + 5.0)

    Expression expDerived = exp.derive('x');

    print(expDerived);            // = (((x * 0.0) + (1.0 * 1.0)) - -(0.0))
    print(expDerived.simplify());// = 1.0
    return expDerived.simplify().toString();
  }


  }