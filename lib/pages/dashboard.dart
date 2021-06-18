import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_polynomial/models/module.dart';

class Dashboard extends StatefulWidget{
  Dashboard({Key key}):super(key:key);

  @override
  DashboardState createState()=> DashboardState();
}

class DashboardState extends State<Dashboard>{

  initFirebase() async{
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade100,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
    builder: (BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError){
                return Text("Error");
              }
              else if(snapshot.connectionState==ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else{
                return ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot data){
                    User user=User.fromJson(data.data());

                  //  User user=<User>data;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 1/8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(1.0,1.0),
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                              color: Colors.black12
                            )
                          ]
                        ),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.0,horizontal: 2.0),
                           //   child: Text(data['userData']['name']),
                              child: Text(user.username,style: TextStyle(color: Colors.black,
                              fontSize: 18,fontWeight: FontWeight.w600),),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.0,horizontal: 2.0),
                              child: Text(user.polynomial,style: TextStyle(
                                color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500
                              ),),

                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.0,horizontal: 2.0),
                              child: Text(user.derivative,style: TextStyle(
                                color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w500
                              ),),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
          })

        )
    );
  }
}