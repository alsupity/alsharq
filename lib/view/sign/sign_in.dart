import 'package:alsharq/start.dart';
import 'package:alsharq/util/app_vars.dart';
import 'package:alsharq/view/sign/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../util/app_consts.dart';
import '../../controller/sign_in_controller.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  SignInController singInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailOrPhoneController,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف أو البريد الإلكتروني',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الهاتف أو البريد الإلكتروني';
                  }
                  // يمكنك إضافة المزيد من التحقق هنا، مثل التحقق من صيغة البريد الإلكتروني
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GetBuilder<SignInController>(
                builder: (controller) {
                  return ElevatedButton(
                    onPressed: (controller.loading)? null: () async {
                      if (_formKey.currentState!.validate()) {
                        final Map<String, dynamic>? user =
                            await singInController.postServerData(params: {
                          "email": _emailOrPhoneController.text,
                          "password": _passwordController.text,
                        });
                        if (user != null) {
                          GetStorage().write("user", user);
                          Get.back();
                        }
                      }
                    },
                    child: Container(
                      width: w,
                      height: 60,
                      alignment: Alignment.center,
                      child: Text(
                        "تسجيل الدخول",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                }
              ),
              Container(
                width: w,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("لا يوجد لدي حساب "),
                    InkWell(
                      onTap: () {
                        Get.to(() => SignUp());
                      },
                      child: Text(
                        "انشاء حساب",
                        style: TextStyle(
                          color: AppConsts.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
