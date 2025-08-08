import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:traxes/bloc/absence/check_radius/check.radius.bloc.dart';
import 'package:traxes/bloc/absence/project_radius/project.radius.bloc.dart';
import 'package:traxes/bloc/feature/bill/bill.bloc.dart';
import 'package:traxes/bloc/feature/display_mbd/display.mbd.bloc.dart';
import 'package:traxes/bloc/feature/mbd/edit_mbd/edit.mbd.bloc.dart';
import 'package:traxes/bloc/feature/mbd/filter_mbd/filter.mbd.bloc.dart';
import 'package:traxes/bloc/history/local_history_outlet/local.history.outlet.bloc.dart';
import 'package:traxes/bloc/user/callplan/callplan.bloc.dart';
import 'package:traxes/bloc/absence/check_in/checkin.bloc.dart';
import 'package:traxes/bloc/absence/check_out/checkout.bloc..dart';
import 'package:traxes/bloc/feature/competitor/competitor.bloc.dart';
import 'package:traxes/bloc/feature/delete_sku/delete.sku.bloc.dart';
import 'package:traxes/bloc/feature/display/display.bloc.dart';
import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/bloc/history/history_absence_bloc/history.absence.bloc.dart';
import 'package:traxes/bloc/history/history_absence_detail/history.absence.detail.bloc.dart';
import 'package:traxes/bloc/history/history_order/history.order.bloc.dart';
import 'package:traxes/bloc/history/history_outlet/history.outlet.bloc.dart';
import 'package:traxes/bloc/user/look_order/look.order.bloc.dart';
import 'package:traxes/bloc/feature/outlet/outlet.bloc.dart';
import 'package:traxes/bloc/user/permission/permission.bloc.dart';
import 'package:traxes/bloc/feature/planogram/planogram.bloc.dart';
import 'package:traxes/bloc/feature/price_tag/price.tag.bloc.dart';
import 'package:traxes/bloc/feature/search/search.bloc.dart';
import 'package:traxes/bloc/feature/sku/sku.bloc.dart';
import 'package:traxes/bloc/feature/skupro/skupro.bloc.dart';
import 'package:traxes/bloc/feature/stock/stock.bloc.dart';
import 'package:traxes/bloc/user/version/version.bloc.dart';
import 'package:traxes/boarding/boarding.screen.dart';
import 'package:traxes/constant/env/config.url.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.grey
  ));
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    envSetup();

    runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => EmployeeBloc()),
        BlocProvider(create: (_) => HistoryOutletBloc()),
        BlocProvider(create: (_) => SearchBloc()),
        BlocProvider(create: (_) => HistoryAbsenceBloc()),
        BlocProvider(create: (_) => PermissionBloc()),
        BlocProvider(create: (_) => OutletBloc()),
        BlocProvider(create: (_) => SkuBloc()),
        BlocProvider(create: (_) => LookOrderBloc()),
        BlocProvider(create: (_) => PlanogramBloc()),
        BlocProvider(create: (_) => DisplayBloc()),
        BlocProvider(create: (_) => SubmitCheckInBloc()),
        BlocProvider(create: (_) => SubmitCheckOutBloc()),
        BlocProvider(create: (_) => StockBloc()),
        BlocProvider(create: (_) => PriceTagBloc()),
        BlocProvider(create: (_) => CompetitorBloc()),
        BlocProvider(create: (_) => CallplanBloc()),
        BlocProvider(create: (_) => DeleteSkuBloc()),
        BlocProvider(create: (_) => SkuProBloc()),
        BlocProvider(create: (_) => HistoryOrderBloc()),
        BlocProvider(create: (_) => DetailAbsenceBloc()),
        BlocProvider(create: (_) => VersionBloc()),
        BlocProvider(create: (_) => CheckRadiusBloc()),
        BlocProvider(create: (_) => BillBloc()),
        BlocProvider(create: (_) => DisplayMbdBloc()),
        BlocProvider(create: (_) => ProjectRadiusBloc()),
        BlocProvider(create: (_) => LocalHistoryOutletBloc()),
        BlocProvider(create: (_) => FilterMbdBloc()),
        BlocProvider(create: (_) => EditMbdBloc())
      ],
      child: GetMaterialApp(

        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        home: const BoardingScreen(),
      ),
    ));
  }, (error, stack) {
    if (kDebugMode) {
      print('Caught error: $error');
    }
    if (kDebugMode) {
      print('Stack trace: $stack');
    }
  });
}
