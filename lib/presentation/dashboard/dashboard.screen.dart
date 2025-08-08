import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/bloc/user/employee/employee.state.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/screen/download.sku.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/feature/absence/absence.screen.dart';
import 'package:traxes/presentation/feature/display_mbd/admin/verify.mbd.screen.dart';
import 'package:traxes/presentation/feature/outlet/add.outlet.screen.dart';
import 'package:traxes/presentation/history/history_absence/history.absence.dart';
import 'package:traxes/presentation/history/history_order/history.order.dart';
import 'package:traxes/presentation/user/activity.screen.dart';
import 'package:traxes/presentation/user/permission/main.permission.screen.dart';
import 'package:traxes/presentation/user/permission/overtime/overtime.screen.dart';
import 'package:traxes/presentation/user/profile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Position? position;
  Placemark? placemark;
  int? checkedIn;

  Future<void> getPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.denied) {
      return;
    }
  }

  getCurrentLocation() async {
    position = await GetGeolocator().getCurrentLocation();
    await GetGeolocator()
        .getAddressLatLang(position!)
        .then((value) => {placemark = value});
  }

  void checkCheckin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkedIn = prefs.getInt("getIn");
    });
  }

  @override
  void initState() {
    super.initState();
    checkCheckin();
    getPermission();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final isLandscape = screenWidth > screenHeight;
            final totalGrid = isLandscape && screenWidth > 700 ? 3 : 3;

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  const ProfileSection(),
                  SizedBox(height: screenHeight * 0.03),
                  const DownloadMaterialCard(),
                  SizedBox(height: screenHeight * 0.025),
                  const MetricsRow(),
                  SizedBox(height: screenHeight * 0.03),
                  checkedIn != 1
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: SlideAction(
                            text: "Geser untuk check-in",
                            sliderRotate: false,
                            textStyle: largeBlackText,

                            onSubmit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AbsenceScreen(),
                                ),
                              );
                              return null;
                            },
                            innerColor: Colors.white,
                            outerColor: const Color(0xFF7EB77F),
                            sliderButtonIcon: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            borderRadius: 16, // Optional: makes it more rounded
                            elevation: 2, // Optional: adds shadow to the slider
                          ),
                        )
                      :  InkWell(
                        onTap: () {
                          Get.to(const EmployeeScreen());
                        }, child: const StatusCard(),
                      ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(),
                  SizedBox(height: screenHeight * 0.03),
                  GridView.count(
                      crossAxisCount: totalGrid,
                      primary: false,
                      shrinkWrap: true,
                      childAspectRatio: screenWidth < 500 ? 1 : 1.5,
                      children: [
                        ReusableButtonWithText(
                            onPressed: () {
                              Get.to(const PermissionMainScreen());
                            },
                            icon: FontAwesomeIcons.personCircleCheck,
                            text: "Absensi",
                            backgroundColor: const Color(0xFF50C878)),
                        ReusableButtonWithText(
                            onPressed: () {
                              Get.to(const OvertimeScreen());
                            },
                            icon: FontAwesomeIcons.userClock,
                            text: "Lembur",
                            backgroundColor: const Color(0xFF912F56)),
                        ReusableButtonWithText(
                            onPressed: () {
                              Get.to(AddOutletScreen(
                                position: position,
                                placemark: placemark,
                              ));
                            },
                            icon: FontAwesomeIcons.shop,
                            text: "Tambah lokasi",
                            backgroundColor: const Color(0xFFF4C430)),
                        ReusableButtonWithText(
                            onPressed: () {
                              Get.to(const HistoryAbsenceScreen());
                            },
                            icon: FontAwesomeIcons.businessTime,
                            text: "Riwayat CI/O",
                            backgroundColor: const Color(0xFF27476E)),
                        ReusableButtonWithText(
                            onPressed: () {
                              Get.to(const HistoryOrderScreen());
                            },
                            icon: Icons.history,
                            text: "Riwayat Sell-out",
                            backgroundColor: const Color(0xFF49306B)),
                        ReusableButtonWithText(
                            onPressed: () {
                              Get.to(const VerifyMbdScreen());
                            },
                            icon: FontAwesomeIcons.userCheck,
                            text: "Verifikasi MBD",
                            backgroundColor: const Color(0xFFC98986)),
                        ReusableButtonWithText(
                            onPressed: () {
                              Get.to(const ProfileScreen());
                            },
                            icon: FontAwesomeIcons.person,
                            text: "Profile",
                            backgroundColor: const Color(0xFFFAC05E)),
                        ReusableButtonWithText(
                            onPressed: () {
                              Get.to(const DownloadSkuScreen());
                            },
                            icon: FontAwesomeIcons.download,
                            text: "Download Data",
                            backgroundColor: const Color(0xFF096B72)),
                        ReusableButtonWithText(
                            onPressed: () {},
                            icon: FontAwesomeIcons.gear,
                            text: "Pengaturan",
                            backgroundColor: const Color(0xFF33202A)),
                      ]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ReusableButtonWithText extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final double padding;

  const ReusableButtonWithText({
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    this.padding = 20.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: const CircleBorder(),
            padding: EdgeInsets.all(padding),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: smallBlackText,
        ),
      ],
    );
  }
}

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  void getEmployee() async {
    context.read<EmployeeBloc>().employeeLoad();
  }

  @override
  void initState() {
    super.initState();
    getEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, stateEmployee) {
      if (stateEmployee is EmployeeLoaded) {
        return ListView.builder(
          itemCount: stateEmployee.data.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var employee = stateEmployee.data[0];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(55),
                    child: Image.asset(
                      "assets/images/punk-image.jpg",
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 35),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileText(employee.fullname.toString()),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            employee.employeeId.toString(),
                            style: standarColorFontGrey,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            employee.typeId.toString(),
                            style: standarColorFontGrey,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }

  Widget _buildProfileText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: largeBlackText,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}

class DownloadMaterialCard extends StatelessWidget {
  const DownloadMaterialCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          Get.to(const DownloadSkuScreen());
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFdaf0fa),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              const Icon(Icons.download, color: Color(0xFF1181c1),),
              const SizedBox(width: 20),
              Text('Download Data', style: smallSkyText),
            ],
          ),
        ),
      ),
    );
  }
}

class MetricsRow extends StatelessWidget {
  const MetricsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MetricCard(
          title: 'Kunjungan',
          textStyle: smallGrenTextB,
          value: '1/10',
          valueStyle: smallGrenText,
          backgroundColor: const Color(0xFFDCF9E0),
        ),
        MetricCard(
          textStyle: smallOrangeTextB,
          valueStyle: smallOrangeText,
          title: 'Item terjual',
          value: '40',
          backgroundColor:  const Color(0xFFf8f0de),
        ),
        MetricCard(
          title: 'Total penjualan',
          textStyle: smallPurpleTextB,
          valueStyle: smallPurpleText,
          value: '40',
          backgroundColor: const Color(0xFfF8edfe),
        ),
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle textStyle;
  final TextStyle valueStyle;
  final Color backgroundColor;

  const MetricCard({
    required this.title,
    required this.value,
    required this.textStyle,
    required this.valueStyle,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: textStyle,
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;

  const FeatureCard({
    required this.title,
    required this.value,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        title,
        style: smallWhiteText,
      ),
    );
  }
}

class StatusCard extends StatefulWidget {
  const StatusCard({super.key});

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  int? checkedIn;
  String? customerName;
  String? address;

  void checkCheckedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkedIn = prefs.getInt("getIn");
    });
  }

  void checkCustomerName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerName = prefs.getString("customerName");
    });
  }

  void getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString("address");
    });
  }

  @override
  void initState() {
    super.initState();
    checkCheckedIn();
    checkCustomerName();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min, // Sesuaikan ukuran row dengan konten
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerName ?? 'Unknown',
                    style: smallBlackTextB,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    address ?? 'No Address',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: extraSmallBlackText,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(const AbsenceScreen());
              },
              child: Card(
                color: const Color(0xFFB23A48),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Text(
                    "Check-out",
                    style: smallWhiteText,
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
