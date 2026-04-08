// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/skupro/skupro.bloc.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/database_offline/db.material.dart';

class DownloadSkuScreen extends StatefulWidget {
  const DownloadSkuScreen({super.key});

  @override
  State<DownloadSkuScreen> createState() => _DownloadSkuScreenState();
}

class _DownloadSkuScreenState extends State<DownloadSkuScreen> {
  int totalDownloaded = 0;
  String? projectId;
  String? version;
  
   void checkVersion () async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
version = packageInfo.version;
  }

  @override
  void initState() {
    super.initState();
    getProject();
    checkVersion();
  }

  getProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      projectId = prefs.getString("emp_project");
    });
    if (kDebugMode) {}
    downloadMaterial();
  }

  Future<void> downloadMaterial() async {
    if (projectId != null) {
      final total = await DBMaterialHelper().getTotalRows(projectId!);
      // Added print statement
      setState(() {
        totalDownloaded = total ?? 0; // Handle null case
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          "Download Sku Screen",
          style: standarWhiteTextB,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, top: 15, right: 8, bottom: 8),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Download Material",
                                  style: standarBlackText,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Total Downloaded: $totalDownloaded",
                                    // Display the total downloaded count
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomButton(
                                  borderRadius: BorderRadius.circular(8),
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();

                                    DBMaterialHelper().deleteMaterialDB();

                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.confirm,
                                        title: "Download material sekarang?",
                                        confirmBtnText: "Download",
                                        confirmBtnTextStyle: smallWhiteText,
                                        onConfirmBtnTap: () async {
                                          prefs.setInt("download", 1);

                                          await context.read<SkuProBloc>().getSkuPro();

                                          final newTotal = await DBMaterialHelper().getTotalRows(projectId!);
                                          
                                          if (!mounted) return;

                                          setState(() {
                                            totalDownloaded = newTotal ?? 0;
                                          });
                                        });
                                    },
                                  child: Text(
                                    "Sync SKU",
                                    style: smallWhiteText,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),                                
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
