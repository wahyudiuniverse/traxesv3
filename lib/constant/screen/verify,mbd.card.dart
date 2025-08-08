import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:traxes/bloc/feature/mbd/filter_mbd/filter.mbd.bloc.dart';
import 'package:traxes/bloc/feature/mbd/filter_mbd/filter.mbd.state.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/feature/display_mbd/admin/detail.filter.mbd.dart';

class MbdCard extends StatefulWidget {
  final String outletName;
  final String outletId;
  final String employeeId;
  final String photoStatus;
  final String photoVerify;
  final String completeSku;
  final String uploadDate;

  const MbdCard({
    super.key,
    required this.outletName,
    required this.outletId,
    required this.employeeId,
    required this.photoStatus,
    required this.photoVerify,
    required this.completeSku,
    required this.uploadDate,
  });

  @override
  State<MbdCard> createState() => _MbdCardState();
}

class _MbdCardState extends State<MbdCard> {
  @override
  void initState() {
    super.initState();
    context.read<FilterMbdBloc>().getFilterMbd(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterMbdBloc, FilterMbdState>(
      builder: (context, state) {
        if (state is FilterMbdLoaded) {
          if (state.data.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: state.data.length,
              itemBuilder: (context, i) {
                final mbdData = state.data[i];

                final Map<String, String> statusMbd = {
                  '0': "Belum Terverifikasi",
                  '1': "Terverifikasi",
                  '2': "Ditolak"
                };

                final Map<String, String> displayMbd = {
                  '1': "MBD Rent",
                  "2": "MBD Free"
                };

                String statusText =
                    statusMbd[mbdData.verifyStatus] ?? "Unknown";
                String statusDisplay =
                    displayMbd[mbdData.statusDisplay] ?? "Unknown";
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(
                          secid: mbdData.secid,
                          photoUrl: mbdData.displayFoto,
                          statusMbd: statusDisplay,
                          displayDate: mbdData.createdOn,
                          statusDisplay: mbdData.verifyStatus,
                          customerName: mbdData.customerName,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mbdData.customerName.toString().isEmpty
                                          ? "-"
                                          : mbdData.customerName.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(mbdData.createdOn.toString()),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    mbdData.employeeId.toString(),
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(statusText,
                                  style: const TextStyle(fontSize: 18)),
                              Text(statusDisplay,
                                  style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(widget.uploadDate)]),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Lottie.network(
                    'https://lottie.host/7d5433bd-f719-4ab4-8e14-542eb8fc4301/HryEUdMZ0f.json',
                    frameRate: FrameRate.max,
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Tidak ada hasil yang ditemukan",
                    style: largeBlackText.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Periksa kembali filter nya.",
                    style: smallBlackText,
                  ),
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
