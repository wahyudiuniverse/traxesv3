import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/bloc/user/employee/employee.state.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/screen/download.sku.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/model/search/search.model.dart';
import 'package:traxes/presentation/dashboard/dashboard.controller.dart';
import 'package:traxes/presentation/feature/outlet/add.outlet.screen.dart';
import 'package:traxes/presentation/history/history_absence/history.absence.dart';
import 'package:traxes/presentation/history/history_order/history.order.dart';
import 'package:traxes/presentation/user/activity.screen.dart';
import 'package:traxes/presentation/feature/absence/check-in/history.outlet.screen.dart';
import 'package:traxes/presentation/feature/absence/absence.screen.dart';
import 'package:traxes/presentation/feature/callplan/plan.screen.dart';

// Placeholder untuk import yang hilang (gunakan yang asli dari project Anda)

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Position? _position;
  Placemark? _placemark;
  int? checkedIn;
  String? customerName;
  String? customerAddress;

  // Variabel ini didefinisikan agar dapat diakses oleh child widget (LocationListContent)
  Position? get currentPosition => _position;
  Placemark? get currentPlacemark => _placemark;

  Future<void> initializeLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return; 
      }
    }

    Position? currentPositionTemp;
    Placemark? currentPlacemarkTemp;

    try {
      // Asumsi GetGeolocator adalah class yang benar untuk mendapatkan lokasi
      currentPositionTemp = await GetGeolocator().getCurrentLocation(); 
      
      if (currentPositionTemp != null) {
        currentPlacemarkTemp = await GetGeolocator().getAddressLatLang(currentPositionTemp);
      }
    } catch (e) {
      print("Error getting location: $e");
    }

    if (mounted) {
      setState(() {
        _position = currentPositionTemp;
        _placemark = currentPlacemarkTemp;
      });
    }
  }

  void checkCheckin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        checkedIn = prefs.getInt("getIn");
      });
    }
  }
  

  @override
  void initState() {
    super.initState();

    checkCheckin();
    initializeLocation();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.03),                 
                const ProfileSection(),
                Visibility(
                  visible: checkedIn == 1,
                  child: Column(
                    children: [
                      const StatusCard(), 
                      SizedBox(height: screenHeight * 0.020),
                    ],
                  ),
                ),
                const InfoCardRow(),
                SizedBox(height: screenHeight * 0.020),
                LocationListContent(
                  parentPosition: _position,
                  parentPlacemark: _placemark,
                ),
              ],
            ),
          ),
        ),
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
  String customerName = "Memuat...";
  String address = "Memuat lokasi...";

  void checkCheckedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
        setState(() {
          checkedIn = prefs.getInt("getIn");
          customerName = prefs.getString("customerName") ?? "Lokasi Tidak Diketahui";
          address = prefs.getString("address") ?? "Alamat tidak tersedia";
        });
    }
  }

  @override
  void initState() {
    super.initState();
    checkCheckedIn();
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF003366); 
    const Color lightText = Colors.white;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: darkBlue,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(15.0),
        child: InkWell  (
          onTap: () {
            //Get.to(const PlanScreen());
            // Get.to(const HistoryOutletScreen());
            // Get.to(const AbsenceScreen());
            Get.to(const EmployeeScreen());
            // Get.to(const HistoryAbsenceScreen());
            // Get.to(const HistoryOrderScreen());
            
            
            // Get.to(AddOutletScreen(
            //                     position: position,
            //                     placemark: placemark,
            //                   ));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Teks 1: Active Check-in at
              const Text(
                'Active Check-in at',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Divider(
                  color: Colors.white30,
                  height: 1,
                  thickness: 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(
                            fontSize: 15,
                            color: lightText,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          address,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_outlined,
                    size: 30,
                    color: lightText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationListContent extends StatefulWidget {
  // Tambahkan properti untuk menerima data lokasi dari parent
  final Position? parentPosition;
  final Placemark? parentPlacemark;

  const LocationListContent({
    super.key,
    this.parentPosition,
    this.parentPlacemark,
  });

  @override
  State<LocationListContent> createState() => _LocationListContentState();
}

class _LocationListContentState extends State<LocationListContent> {
  void getEmployee() async {
    context.read<EmployeeBloc>().employeeLoad();
  }

  String _selectedTab = 'Call Plan';
  bool _isLoadingCallPlan = false;
  bool _isLoadingSuggest = false;

  String? _currentProjectId;

  final StoreListGetx _locationService = StoreListGetx();

  List<DataSearch> callPlanStores = [];
  List<DataSearch> suggestStores = [];
  
  // HAPUS GETTER currentStoreList

  void _onTabChanged(String newTab) {
    setState(() {
      _selectedTab = newTab;
    });

    // DEBUG: Cetak state list setelah pindah tab
    debugPrint('Tab Changed to: $newTab');
    debugPrint('Call Plan Data Count: ${callPlanStores.length}');
    debugPrint('Suggest Data Count: ${suggestStores.length}');

    if (newTab == 'Call Plan' && callPlanStores.isEmpty && !_isLoadingCallPlan) {
      _fetchCallPlanStores();
    }

    if (newTab == 'Suggest' && suggestStores.isEmpty && !_isLoadingSuggest && _currentProjectId != null) {
      _fetchSuggestStores(_currentProjectId!);
    }
  }
  
  void _fetchCallPlanStores() async { 
    if (_isLoadingCallPlan) return;

    setState(() {
      _isLoadingCallPlan = true;
      callPlanStores.clear();
    });

    await _locationService.getCallPlan(
      (fetchedList) { 
        if (mounted) {
          setState(() {
            callPlanStores = fetchedList; 
            _isLoadingCallPlan = false;
            debugPrint('Fetch CALL PLAN Success. Count: ${callPlanStores.length}');
          });
        }
      },
    );
    
    if (mounted && _isLoadingCallPlan) {
      setState(() {
        _isLoadingCallPlan = false; 
      });
    }
  }

  void _fetchSuggestStores(String projectId) async { 
    if (_isLoadingSuggest) return;

    setState(() {
      _isLoadingSuggest = true;
      suggestStores.clear();
    });

    await _locationService.getSuggest(
      projectId,
      (fetchedList) { 
        if (mounted) {
          setState(() {
            suggestStores = fetchedList; 
            _isLoadingSuggest = false;
            debugPrint('Fetch SUGGEST Success. Count: ${suggestStores.length}');
          });
        }
      },
    );
    
    if (mounted && _isLoadingSuggest) {
      setState(() {
        _isLoadingSuggest = false; 
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getEmployee();
  }

 @override
 Widget build(BuildContext context) {
  // Tentukan List dan Loading State yang Aktif secara eksplisit
    final bool isActiveCallPlan = _selectedTab == 'Call Plan';
    final List<DataSearch> activeStoreList = isActiveCallPlan ? callPlanStores : suggestStores;
    final bool isLoadingActiveTab = isActiveCallPlan ? _isLoadingCallPlan : _isLoadingSuggest;

    return BlocListener<EmployeeBloc, EmployeeState>( 
      listener: (context, stateEmployee) {
        if (stateEmployee is EmployeeLoaded) {
          var employee = stateEmployee.data[0];
          final projectId = employee.projectId.toString();
          _currentProjectId = projectId;

          if (callPlanStores.isEmpty && !_isLoadingCallPlan) {
            _fetchCallPlanStores();
          }
        }
      },
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
              SegmentedControlTab(
                  selectedTab: _selectedTab,
                  onTabChanged: _onTabChanged,
              ),
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Button "Tambah Lokasi" (Menggunakan Expanded untuk mengisi ruang)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.to(AddOutletScreen(
                        position: widget.parentPosition,
                        placemark: widget.parentPlacemark,
                      ));
                    },
                    icon: const Icon(Icons.add_location_alt_outlined, size: 18),
                    label: const Text('Tambah Lokasi', style: TextStyle(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D6EFD), // Warna Biru
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 1,
                    ),
                  ),
                ),
                
                const SizedBox(width: 12), // Jarak antara tombol dan icon
                
                // Icon Search
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Color(0xFF1F2937)),
                    onPressed: () {
                      Get.to(const HistoryOutletScreen());
                    },
                    padding: const EdgeInsets.all(12),
                    // Kita set minimal ukuran untuk memastikan tombol dan icon seimbang
                    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
                  ),
                ),
              ],
            ),
          ),
              
              if (isLoadingActiveTab)
                  const Center(child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: Color(0xFF0D6EFD),),
                  )),
              
              if (!isLoadingActiveTab)
                  // Menggunakan KeyedSubtree untuk memaksa rebuild
                  KeyedSubtree(
                      key: ValueKey(_selectedTab), 
                      child: activeStoreList.isEmpty
                          ? const Center(child: Padding(
                              padding: EdgeInsets.all(32.0), 
                              child: Text("Tidak ada data.") // Tampilkan jika list kosong
                            ))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 8), 
                              itemCount: activeStoreList.length, 
                              itemBuilder: (context, index) {
                                  final store = activeStoreList[index];
                                  return StoreListItem(
                                      storeImage: store.photo.toString(),
                                      storeName: store.customerName.toString(),
                                      storeAddress: store.address.toString(),
                                  );
                              },
                          ),
                  ),
          ],
      )
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
        var employee = stateEmployee.data[0];
        return ProfileSectionContent(
          fullname: employee.fullname.toString(),
          employeeId: employee.employeeId.toString(),
          typeId: employee.typeId.toString()
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
class ProfileSectionContent extends StatelessWidget {
  final String fullname;
  final String employeeId;
  final String typeId;

  const ProfileSectionContent({
    super.key,
    required this.fullname,
    required this.employeeId,
    required this.typeId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child: Image.asset(
              "assets/images/punk-image.jpg",
              width: 65,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileText(fullname),
                Text(
                    employeeId,
                    style: smallTextGrey,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                ),
                Text(
                    typeId,
                    style: smallTextGreyBold,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileText(String text) {
    return Text(
        text,
        style: largeBlackTextB,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      );
  }
}
class InfoCardRow extends StatelessWidget {
  const InfoCardRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: InfoCard(
              title: 'Kunjungan',
              value: '0',
              isFraction: true,
            ),
          ),
          SizedBox(width: 10),
          
          Expanded(
            child: InfoCard(
              title: 'Item terjual',
              value: '0',
            ),
          ),
          SizedBox(width: 10),

          Expanded(
            child: InfoCard(
              title: 'Total penjualan',
              value: '0',
            ),
          ),
        ],
      ),
    );
  }
}
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isFraction;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    this.isFraction = false,
  });

  List<Text> _buildFractionText(String value) {
    final parts = value.split('/');
    if (parts.length == 2) {
      return [
        Text(
          parts[0],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        Text(
          '/${parts[1]}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
          ),
        ),
      ];
    }
    return [
      Text(
        value,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1F2937),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1), 
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),

            if (isFraction)
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.center, 
                textBaseline: TextBaseline.alphabetic,
                children: _buildFractionText(value),
              )
            else
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
          ],
        ),
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
class StoreData {
  final String image;
  final String name;
  final String address;
  const StoreData({required this.image, required this.name, required this.address});
}

class StoreListItem extends StatefulWidget {
  final String storeImage;
  final String storeName;
  final String storeAddress;

  const StoreListItem({
    super.key,
    required this.storeImage,
    required this.storeName,
    required this.storeAddress,
  });

  @override
  State<StoreListItem> createState() => _StoreListItemState();
}

// 2. BUAT State Class
class _StoreListItemState extends State<StoreListItem> {
  // 3. Pindahkan/Definisikan STATE LOKAL
  int? _checkedIn; // Menggunakan int? (nullable int) untuk menampung nilai dari prefs
  
  // Hapus variabel 'checkedIn' global yang tidak terdefinisi
  // Hapus SharedPreferences yang tidak digunakan
  
  // 4. Pindahkan checkCheckin ke dalam State Class
  void _checkCheckin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Tidak perlu (mounted) check di initState karena sudah dipanggil di initState,
    // tapi lebih aman jika diletakkan di dalam method async.
    if (mounted) { 
      setState(() {
        // Ambil nilai 'getIn', default 0 jika null
        _checkedIn = prefs.getInt("getIn") ?? 0; 
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Panggil method untuk memuat state saat widget dibuat
    _checkCheckin(); 
  }
  
  // Hapus method dispose jika tidak digunakan, tapi disarankan untuk ada

  @override
  Widget build(BuildContext context) {
    const Color checkInBlue = Color(0xFF0D6EFD);

    // Pastikan _checkedIn sudah memiliki nilai sebelum digunakan
    final isCheckedIn = _checkedIn == 1; 

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          // --- IMAGE CONTAINER (Menggunakan widget.storeImage) ---
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200, 
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                // Mengakses properti widget melalui 'widget.'
                image: NetworkImage("https://api.traxes.id/${widget.storeImage}"), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // --- DETAIL TOKO ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.storeName, // Mengakses properti widget
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.storeAddress, // Mengakses properti widget
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // --- BUTTON CHECK-IN ---
          // Menggunakan state isCheckedIn
          Visibility(
            visible: isCheckedIn ? false : true, 
            child: ElevatedButton(
              onPressed: () {
                 // Tambahkan logic check-in di sini
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: checkInBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: Size.zero, 
              ),
              child: const Text(
                'Check-in',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SegmentedControlTab extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabChanged;

  const SegmentedControlTab({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    const Color activeBlue = Color(0xFFE5F0FF); 
    const Color activeTextColor = Color(0xFF0D6EFD);
    const Color inactiveTextColor = Color(0xFF6B7280);

    return Container(
      margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tab 1: Call Plan
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged('Call Plan'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selectedTab == 'Call Plan' ? activeBlue : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'Call Plan',
                    style: TextStyle(
                      color: selectedTab == 'Call Plan' ? activeTextColor : inactiveTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Tab 2: Suggest
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged('Suggest'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selectedTab == 'Suggest' ? activeBlue : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'Suggest',
                    style: TextStyle(
                      color: selectedTab == 'Suggest' ? activeTextColor : inactiveTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
