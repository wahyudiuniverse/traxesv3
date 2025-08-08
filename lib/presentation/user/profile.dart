import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/bloc/user/employee/employee.state.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/sharedprefs.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/database_offline/db.customer.dart';
import 'package:traxes/database_offline/db.lite.dart';
import 'package:traxes/database_offline/db.material.dart';
import 'package:traxes/presentation/user/login.employee.screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("Profile", style: standarWhiteTextB),
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, stateEmployee) {
          if (stateEmployee is EmployeeLoaded) {
            return ListView.builder(
              itemCount: stateEmployee.data.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                var emp = stateEmployee.data[0];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(
                                    0xFF661C63), // Start color (vibrant purple)
                                Color(0xFF1C4966), // End color
                              ],
                            ),
                            shape: BoxShape.circle),
                        child: ClipOval(
                          child: Image.asset("assets/images/blue-person.png",
                              color: Colors.white, width: 90, height: 90),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(
                                        0xFF661C63), // Start color (vibrant purple)
                                    Color(0xFF1C4966), // End color
                                  ],
                                ),
                                shape: BoxShape.circle),
                            child: ClipOval(
                              child: Image.asset(
                                  "assets/images/blue-person.png",
                                  color: Colors.white,
                                  width: 45,
                                  height: 45),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "NAMA",
                                style: standarColorFontGrey,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                emp.fullname.toString(),
                                style: standarBlackText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(
                                        0xFF661C63), // Start color (vibrant purple)
                                    Color(0xFF1C4966), // End color
                                  ],
                                ),
                                shape: BoxShape.circle),
                            child: ClipOval(
                              child: Image.asset("assets/images/card.png",
                                  color: Colors.white, width: 45, height: 45),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "NIP",
                                style: standarColorFontGrey,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                emp.employeeId.toString(),
                                style: standarBlackText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(
                                        0xFF661C63), // Start color (vibrant purple)
                                    Color(0xFF1C4966), // End color
                                  ],
                                ),
                                shape: BoxShape.circle),
                            child: ClipOval(
                              child: Image.asset("assets/images/card.png",
                                  color: Colors.white, width: 45, height: 45),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "ID Project",
                                style: standarColorFontGrey,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                emp.projectId.toString(),
                                style: standarBlackText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(
                                        0xFF661C63), // Start color (vibrant purple)
                                    Color(0xFF1C4966), // End color
                                  ],
                                ),
                                shape: BoxShape.circle),
                            child: ClipOval(
                              child: Image.asset("assets/images/card.png",
                                  color: Colors.white, width: 45, height: 45),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Company",
                                style: standarColorFontGrey,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                emp.projectName.toString(),
                                style: standarBlackText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(
                                        0xFF661C63), // Start color (vibrant purple)
                                    Color(0xFF1C4966), // End color
                                  ],
                                ),
                                shape: BoxShape.circle),
                            child: ClipOval(
                              child: Image.asset("assets/images/suitcase.png",
                                  color: Colors.white, width: 45, height: 45),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "JABATAN",
                                style: standarColorFontGrey,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  emp.typeId.toString(),
                                  style: standarBlackText,
                                )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 15, bottom: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              DBHelper().deleteDB();
                              DBMaterialHelper().deleteMaterialDB();
                              DBCustomerHelper().deleteCustomerDB();
                              LocalStorage.clear();
                              EasyLoading.showSuccess("Berhasil Logout",
                                  duration: const Duration(seconds: 3));
                              Get.offAll(const LoginEmployeeScreen());
                            },
                            child: Text(
                              "Logout",
                              style: smallWhiteText,
                            )),
                      ),
                    )
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
