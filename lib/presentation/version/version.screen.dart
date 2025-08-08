// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:traxes/bloc/version/version.bloc.dart';
// import 'package:traxes/bloc/version/version.state.dart';
// import 'package:upgrader/upgrader.dart';

// class VersionScreen extends StatefulWidget {
//   const VersionScreen({super.key});

//   @override
//   State<VersionScreen> createState() => _VersionScreenState();
// }

// class _VersionScreenState extends State<VersionScreen> {

//   String? versionApp;

//    void getAppVersion() async {
//     final PackageInfo packageInfo = await PackageInfo.fromPlatform();

//     final version = packageInfo.version;

//     setState(() {
//       versionApp = version;
//     });
//   }
  

//   @override
//   void initState() {
//     super.initState();
//     context.read<VersionBloc>().checkUpdate();

//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
     
//       body: BlocBuilder<VersionBloc, VersionState>(
//         builder: (context, state) {
//           if (state is UpdateNotification) {
//              return UpgradeAlert(
//               dialogStyle: UpgradeDialogStyle.cupertino,
//              );
//           } else {
//             // Handle other states or return your default UI
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
