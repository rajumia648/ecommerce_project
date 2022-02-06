import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_project/const/mycolor.dart';
import 'package:ecommerce_project/ui/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Userwidget extends StatefulWidget {
  const Userwidget({Key? key}) : super(key: key);
  @override
  _UserwidgetState createState() => _UserwidgetState();
}

class _UserwidgetState extends State<Userwidget> {
  @override
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];
  Future<void> _selectDateFromPicker(BuildContext contex) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _ageController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
  }

  Future sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users_form_data");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "age": _ageController.text,
          "gender": _genderController.text,
        })
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (_) => Homewidget())))
        .catchError((error) => print("Something went wrong. $error"));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                "User Form",
                style: TextStyle(
                  fontSize: 45.sp,
                  fontWeight: FontWeight.bold,
                  color: appcolor.mycolor,
                ),
              ),
              Text(
                "We will not share your information",
                style: TextStyle(fontSize: 15.sp, color: Color(0xFFBBBBBB)),
              ),
              SizedBox(
                height: 20.h,
              ),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your name",
                  label: Text("Name"),
                  prefixIcon: Icon(Icons.text_fields),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your phone number",
                  labelText: "Phone No",
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your date of birth",
                  labelText: "Date of Birth",
                  suffixIcon: IconButton(
                      onPressed: () => _selectDateFromPicker(context),
                      icon: Icon(Icons.calendar_today_outlined)),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              TextField(
                controller: _genderController,
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Choose your gender",
                    labelText: "Gender",
                    prefixIcon: DropdownButton<String>(
                      items: gender.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                          onTap: () {
                            setState(() {
                              _genderController.text = value;
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (_) {},
                    )),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                width: 1.sw,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    sendUserDataToDB();
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: appcolor.mycolor,
                    elevation: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
