import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/feature/absence/absence.screen.dart';
import 'package:traxes/presentation/feature/callplan/callplan.screen.dart';

class VisitScreen extends StatelessWidget {
  const VisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: Text("Call Plan / Visit", style: standarWhiteTextB)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 55, top: 110),
                child: GestureDetector(
                  onTap: () async {
                    Get.to(const CallPlanScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Card(
                      color: const Color(0xFF1C4966),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                size: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(
                                "Call Plan",
                                style: standarWhiteText,
                              )
                            ],
                          )),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                 Get.to(const AbsenceScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100, top: 10),
                  child: Card(
                    color: const Color(0xFF661C63),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_pin,
                              size: 60,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text("Visit", style: standarWhiteText)
                          ],
                        )),
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