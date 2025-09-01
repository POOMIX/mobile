import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/request/customer_register_post_req.dart';
import 'package:my_first_app/model/response/customer_login_post_res.dart';
import 'package:my_first_app/pages/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController phonectl = TextEditingController();
  TextEditingController fullnamectl = TextEditingController();
  TextEditingController emailctl = TextEditingController();
  TextEditingController passwordctl = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ลงทะเบียนสมาชิกใหม่')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "ชื่อ-นามสกุล",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: fullnamectl,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "หมายเลขโทรศัพท์",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: phonectl,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "อีเมล์",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: emailctl,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "หรัสผ่าน",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: passwordctl,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "ยืนยันหรัสผ่าน",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: passwordConfirm,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () => register(),
                      child: const Text('สมัครสมาชิก'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => (),
                      child: const Text(
                        'หากมีบัญชีอยู่แล้ว',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () => login(),
                      child: const Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void register() {
    String fullname = fullnamectl.text;
    String email = emailctl.text;
    String phone = phonectl.text;
    String password = passwordctl.text;
    String confirmpass = passwordConfirm.text;
    if (fullname == '' ||
        phone == '' ||
        password == '' ||
        confirmpass == '' ||
        email == '') {
      log("Emty Broo");
    } else {
      CustomerRegisterPostRequest customerLoginPostRequest =
          CustomerRegisterPostRequest(
            fullname: fullnamectl.text,
            phone: phonectl.text,
            email: emailctl.text,
            image: "",
            password: passwordctl.text,
          );

      http
          .post(
            Uri.parse("http://192.168.59.1:3000/customers"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerRegisterPostRequestToJson(customerLoginPostRequest),
          )
          .then((value) {
            log(value.body);
            CustomerLoginPostResponse customerLoginPostResponse =
                customerLoginPostResponseFromJson(value.body);
            log(customerLoginPostResponse.customer.fullname);
            log(customerLoginPostResponse.customer.email);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          })
          .catchError((error) {
            log('Error $error');
          });
    }
  }

  void login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
