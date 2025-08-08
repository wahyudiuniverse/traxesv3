import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traxes/bloc/feature/mbd/filter_mbd/filter.mbd.bloc.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/model/filter_mbd/filter.mbd.request.dart';
import 'package:traxes/presentation/feature/display_mbd/admin/result.filter.mbd.dart';

class VerifyMbdScreen extends StatefulWidget {
  const VerifyMbdScreen({super.key});

  @override
  State<VerifyMbdScreen> createState() => _VerifyMbdScreenState();
}

class _VerifyMbdScreenState extends State<VerifyMbdScreen> {
  String? selectedValue;
  String? selectedStatus;

  final Map<int, String> statusDisplay = {1: 'MBD Rent', 2: 'MBD Free'};

  final List<int> displayValues = [1, 2];

  final List<int> verifyValues = [0, 1, 2];

  final Map<int, String> verifyItems = {0: 'Belum terverifikasi', 1: 'Diterima', 2: 'Ditolak'};

  final periodController = TextEditingController();
  final secondPeriodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Gradient Container
              Container(
                height: 120, 
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1C4966), Color(0xFF661C63)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row with Back Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('Verifikasi MBD', style: standarWhiteTextB),
                          ),
                        ),
                        Container(width: 48),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Card(
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Filter Display MBD", style: standarColoredText),
                              const SizedBox(height: 24),
                              // Tanggal Mulai
                              const Text("Tanggal Mulai", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: periodController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF1C4966)),
                                  labelText: "Pilih tanggal",
                                  labelStyle: smallColorFontGrey,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  suffixIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1C4966)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF1C4966)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime.now().add(const Duration(days: 1095)),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      periodController.text = DateFormat("yyyy-MM-dd").format(pickedDate);
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              // Tanggal Akhir
                              const Text("Tanggal Akhir", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: secondPeriodController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF1C4966)),
                                  labelText: "Pilih tanggal akhir",
                                  labelStyle: smallColorFontGrey,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  suffixIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1C4966)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF1C4966)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime.now().add(const Duration(days: 1095)),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      secondPeriodController.text = DateFormat("yyyy-MM-dd").format(pickedDate);
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              // Pilih Jenis MBD
                              DropdownButtonFormField2<int>(
                                style: smallBlueText,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.shop_two),
                                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                                  border: InputBorder.none,
                                ),
                                hint: Text('Pilih jenis MBD', style: standarBlueTextB),
                                items: displayValues.map((item) {
                                  return DropdownMenuItem<int>(
                                    value: item,
                                    child: Text(statusDisplay[item]!, style: const TextStyle(fontSize: 14)),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Pilih jenis MBD terdahulu!';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value.toString();
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              // Pilih Status
                              DropdownButtonFormField2<int>(
                                style: smallBlueText,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.check_box),
                                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                                  border: InputBorder.none,
                                ),
                                hint: Text('Pilih status', style: standarBlueTextB),
                                items: verifyValues.map((item) {
                                  return DropdownMenuItem<int>(
                                    value: item,
                                    child: Text(verifyItems[item]!, style: const TextStyle(fontSize: 14)),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Pilih Reason';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value.toString();
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              // ID Toko (Optional)
                              TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "ID toko (opsional)",
                                  labelStyle: smallColorFontGrey,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF1C4966)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Cari Button
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: periodController.text.isNotEmpty &&
                                        secondPeriodController.text.isNotEmpty &&
                                        selectedValue != null && selectedStatus != null
                                    ? CustomButton(
                                        onPressed: () {
                                          final data = FilterRequestMbdModel(
                                            startDate: periodController.text,
                                            endDate: secondPeriodController.text,
                                            statusDisplay: selectedValue,
                                            verifyStatus: selectedStatus,
                                          );
                                          context
                                              .read<FilterMbdBloc>()
                                              .getFilterMbd(context: context, formData: data);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ResultFilterMbd(
                                                startDate: data.startDate,
                                                endDate: data.endDate,
                                                statusDisplay: data.statusDisplay,
                                                verifyStatus: data.verifyStatus,
                                              ),
                                            ),
                                          );
                                        },
                                        width: double.infinity,
                                        child: Text("Cari", style: smallWhiteTextB),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
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
