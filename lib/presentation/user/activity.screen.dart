// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, duplicate_ignore, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/constant/screen/visit.screen.dart';
import 'package:traxes/presentation/feature/display/display.screen.dart';
import 'package:traxes/presentation/feature/sku/order.main.screen.dart';
import 'package:traxes/presentation/feature/stock_product/stock.main.screen.dart';
// Import-import lain yang mungkin Anda butuhkan di file ini:
// ...

// --- DATA MODEL UNTUK MENU ITEMS ---
class MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  MenuItem({required this.icon, required this.title, required this.onTap});
}

// -------------------------------------------------------------------
// --- WIDGET MENU CARD KUSTOM (STATEFUL) --- (Tidak ada perubahan di sini)
// -------------------------------------------------------------------
class MenuCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  // State untuk melacak apakah kartu sedang ditekan
  bool _isPressed = false;
  
  // Definisi warna
  static const Color _defaultIconColor = Color(0xFF616161); // Abu-abu gelap (default)
  static const Color _tappedIconColor = Color(0xFF0D6EFD); // Biru (saat ditekan)
  static const Color _defaultTextColor = Color(0xFF333333); // Warna teks default
  static const Color _tappedTextColor = Color(0xFF0D6EFD); // Biru (saat ditekan)

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(8));

    // Tentukan warna dinamis
    final iconColor = _isPressed ? _tappedIconColor : _defaultIconColor;
    final textColor = _isPressed ? _tappedTextColor : _defaultTextColor;

    return Card(
      elevation: 0, 
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      // Gunakan GestureDetector untuk menangkap status penekanan
      child: GestureDetector(
        onTapDown: (_) {
          // Saat mulai ditekan
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          // Saat dilepas, beri penundaan agar efek terlihat
          Future.delayed(const Duration(milliseconds: 100), () {
            if(mounted) {
              setState(() {
                _isPressed = false;
              });
            }
          });
          widget.onTap(); // Panggil fungsi onTap utama
        },
        onTapCancel: () {
          // Jika sentuhan dibatalkan
          setState(() {
            _isPressed = false;
          });
        },
        
        child: InkWell(
          borderRadius: borderRadius,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius,
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  widget.icon,
                  size: 36.0,
                  color: iconColor, // <--- Icon menggunakan warna dinamis
                ),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor, // <--- Teks menggunakan warna dinamis
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGET UTAMA (MAIN SCREEN) ---
// -------------------------------------------------------------------
class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  // Tambahkan customerId ke state
  String _customerName = "Memuat Nama Toko...";
  String _customerAddress = "Memuat Alamat...";
  String _customerId = ""; // Nilai default string kosong/tidak valid
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadStoreData();
  }

  // --- FUNGSI UNTUK MEMUAT DATA DARI SHARED PREFERENCES ---
  Future<void> _loadStoreData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    const defaultName = "Nama Toko Tidak Ditemukan";
    const defaultAddress = "Alamat Tidak Ditemukan";
    const defaultCustomerId = ""; // Kunci default untuk ID

    // Ambil data
    final name = prefs.getString('customerName');
    final address = prefs.getString('address');
    final id = prefs.getString('customerId'); // <--- Ambil customerId

    if (mounted) {
      setState(() {
        _customerName = name ?? defaultName;
        _customerAddress = address ?? defaultAddress;
        _customerId = id ?? defaultCustomerId; // <--- Set customerId
        _isLoadingData = false;
      });
    }
  }

  // --- FUNGSI UNTUK MENANGANI CHECK-OUT ---
  void _onCheckoutPressed() {
     Get.to(const VisitScreen());
  }

  List<MenuItem> _buildMenuItems(BuildContext context) {
    void showSnackbar(String title) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(title), duration: const Duration(milliseconds: 500),),
      );
    }

    return [
      MenuItem(
        icon: Icons.shopping_cart_outlined,
        title: 'Order / Sell Out',
        onTap: () => Get.to(const OrderMainScreen()),
      ),
      MenuItem(
        icon: Icons.inventory_2_outlined,
        title: 'Stock',
        onTap: () => Get.to(const StockMainScreen()),
      ),
      MenuItem(
        icon: Icons.label_outline,
        title: 'Pricing',
        onTap: () => showSnackbar('Coming Soon'),
      ),
      MenuItem(
        icon: Icons.remove_red_eye_outlined,
        title: 'Display',
        // KIRIM DATA customerName, address, dan customerId ke DisplayScreen
        onTap: () {
          Get.to(() => DisplayScreen(
            customerName: _customerName, 
            address: _customerAddress, 
            customerId: _customerId, // <--- customerId dari SharedPreferences
          ));
        },
      ),
      MenuItem(
        icon: Icons.post_add, 
        title: 'Retur',
        onTap: () => showSnackbar('Coming Soon'),
      ),
      MenuItem(
        icon: Icons.store_outlined,
        title: 'Program Store',
        onTap: () => showSnackbar('Coming Soon'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = _buildMenuItems(context);

    // Konten Banner
    final storeContent = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
            Icons.store_mall_directory_outlined,
            color: Color(0xFF0D6EFD),
            size: 24,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    _customerName, // Nama dari State
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                    ),
                    overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                    _customerAddress, // Alamat dari State
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                ),
              ],
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0, 
        
        title: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _isLoadingData
                ? const Center(child: LinearProgressIndicator(color: Color(0xFF0D6EFD)))
                : storeContent,
        ),
        
        titleSpacing: 0, 
        
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      
      backgroundColor: Colors.grey.shade50,
      
      // Menggunakan Column untuk menempatkan GridView (dengan Expanded) dan tombol di bawahnya
      body: Column(
        children: [
          // 1. GridView Konten (Menu Items)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                crossAxisCount: 2, 
                crossAxisSpacing: 12.0, 
                mainAxisSpacing: 12.0, 
                childAspectRatio: 1.0, 
                shrinkWrap: true, // WAJIB: Jika GridView ada dalam Column atau ListView
                physics: const AlwaysScrollableScrollPhysics(), // Memungkinkan GridView digulir
                
                children: menuItems.map((item) {
                  return MenuCard(
                    icon: item.icon,
                    title: item.title,
                    onTap: item.onTap,
                  );
                }).toList(),
              ),
            ),
          ),

          // 2. Button Check-out di bagian bawah
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _onCheckoutPressed,
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Check-out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700, // Warna merah untuk Check-out
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
