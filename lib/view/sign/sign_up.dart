import 'package:alsharq/controller/sign_up_controller.dart';
import 'package:alsharq/util/app_consts.dart';
import 'package:alsharq/view/sign/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../start.dart';
import '../../util/app_vars.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String type = 's';

  SingUpController singUpController = Get.put(SingUpController());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("إنشاء حساب"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "الاسم"),
                validator: (value) => value!.isEmpty ? "الاسم مطلوب" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "رقم الهاتف"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? "رقم الهاتف مطلوب" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: "البريد الإلكتروني (اختياري)"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "كلمة السر"),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? "كلمة السر يجب أن تكون 6 أحرف على الأقل"
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: "تأكيد كلمة السر"),
                obscureText: true,
                validator: (value) => value != _passwordController.text
                    ? "كلمة السر غير متطابقة"
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: const Text("طالب"),
                      value: "s",
                      groupValue: type,
                      onChanged: (value) {
                        setState(() {
                          type = value.toString();
                        });
                      },
                    ),
                  ),
                  // Expanded(
                  //   child: RadioListTile(
                  //     title: const Text("استاذ"),
                  //     value: "t",
                  //     groupValue: type,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         type = value.toString();
                  //       });
                  //     },
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 16),
              GetBuilder<SingUpController>(builder: (controller) {
                return ElevatedButton(
                  onPressed: (controller.loading)
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final Map<String, dynamic>? user =
                                await singUpController.postServerData(params: {
                              "name": _nameController.text,
                              "phone": _phoneController.text,
                              "email": _emailController.text,
                              "password": _passwordController.text,
                              'type': type,
                            });
                            if (user != null) {
                              // GetStorage().write("user", user);
                              Get.back();
                            }
                          }
                        },
                  child: Container(
                    width: w,
                    height: 60,
                    alignment: Alignment.center,
                    child: Text(
                      "انشاء  حساب",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Container(
                width: w,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("هل لديك حساب بالغعل؟ "),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "تسجيل الدخول",
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
