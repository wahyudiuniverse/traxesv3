import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traxes/bloc/feature/display_mbd/display.mbd.bloc.dart';
import 'package:traxes/bloc/feature/display_mbd/display.mbd.state.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/check.intenet.dart';

class ModernCard extends StatefulWidget {
  final String imageUrl;
  final DateTime date;
  final String status;

  const ModernCard({
    super.key,
    required this.imageUrl,
    required this.date,
    required this.status,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();  
}

class _ModernCardState extends State<ModernCard> {

  void checkConnectivityAndNavigate() {
    ConnectivityHelper.checkConnectivity(context, () {
      setState(() {
        ConnectivityHelper.hideNoInternetDialog();
        Navigator.pop(context);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<DisplayMbdBloc>().getMbdDisplay(context: context);
    setState(() {
          context.read<DisplayMbdBloc>().getMbdDisplay(context: context);

    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayMbdBloc, DisplayMbdState>(
      builder: (context, state) {
        if (state is DisplayMbdLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              var displayData = state.data[index];
             
              final Map<String, String> statusMap = {
                '0': 'Belum Terverifikasi',
                '1': 'Terverifikasi',
                '2': 'Ditolak',
              };

              final Map<String, TextStyle> statusStyles = {
                '0': const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF87CEEB),
                  backgroundColor: Color(0xFF4682B4),
                ),
                '1': TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800],
                  backgroundColor: Colors.green[100],
                ),
                '2': TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[800],
                  backgroundColor: Colors.red[100],
                ),
              };

              String statusText = statusMap[displayData.verifyStatus] ?? 'Unknown';
              TextStyle statusStyle = statusStyles[displayData.verifyStatus] ?? smallBlackTextB;

              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          width: 150,
                          height: 120,
                          child: Image.network(
                            "https://api.traxes.id/${displayData.displayFoto}",
                            fit: BoxFit.cover,
                           
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date text
                            // Text(
                            //   'Date: ${displayData.displayInfo}',
                            //   style: TextStyle(
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.grey[800],
                            //     letterSpacing: 0.5,
                            //   ),
                            // ),
                            const SizedBox(height: 10),
                            // Status label text
                            Text(
                              "Status: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  displayData.verifyStatus == '1'
                                      ? Icons.check_circle
                                      : (displayData.verifyStatus == '2'
                                          ? Icons.cancel
                                          : Icons.help),
                                  color: displayData.verifyStatus == '1'
                                      ? Colors.green
                                      : (displayData.verifyStatus == '2'
                                          ? Colors.red
                                          : const Color(0xFF87B6A7)),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                // Status text with dynamic styling
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: statusStyle.backgroundColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: statusStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
