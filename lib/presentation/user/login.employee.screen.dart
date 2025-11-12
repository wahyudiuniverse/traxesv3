import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/model/login/login.employee.model.dart';
import 'package:traxes/presentation/bottom_navigation/bottom_navigation.screen.dart'; 

// Asumsi halaman setelah login adalah DashboardScreen.
import 'package:traxes/presentation/dashboard/dashboard.screen.dart'; 
// Asumsi ini mengarah ke file style Anda yang berisi definisi 'extraSmallBlackText'
// Catatan: Jika Anda menjalankan kode ini secara independen, Anda mungkin perlu mendefinisikan
// 'extraSmallBlackText' secara inline atau membuat file style tersebut.
import 'package:traxes/constant/text.style.dart'; 

class LoginEmployeeScreen extends StatefulWidget {
const LoginEmployeeScreen({super.key});

@override
State<LoginEmployeeScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginEmployeeScreen> {
// 1. Tambahkan Form Key untuk validasi
final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
final TextEditingController _nipController = TextEditingController();
final FocusNode _nipFocusNode = FocusNode(); 
String? versionApp;

void getAppVersion() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final version = packageInfo.version;

  setState(() {
    versionApp = version;
  });
}

@override
void initState() {
 super.initState();
 getAppVersion();
}

@override
void dispose() {
 _nipController.dispose();
 _nipFocusNode.dispose();
 super.dispose();
}
 
void _onForgotNIPPressed() {
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text("Coming Soon"), duration: const Duration(milliseconds: 500),),
  );
}

@override
Widget build(BuildContext context) {
 // Define a minimal placeholder style if extraSmallBlackText is not defined externally
 // You should remove this block if your actual style constant is imported correctly.
 const TextStyle extraSmallBlackText = TextStyle(
  fontSize: 12, 
  color: Color(0xFF374151), 
  fontWeight: FontWeight.w400,
 );

final loginVM = context.read<EmployeeBloc>();

 return Scaffold(
  backgroundColor: Colors.white, 
  body: Stack(
   children: [
    // 1. Konten Utama (Dapat Digulir)
    SafeArea(
     child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      // 3. Tambahkan Form Widget di sini
      child: Form(
       key: _formKey, // Hubungkan dengan form key
       child: Column(
        mainAxisAlignment: MainAxisAlignment.start, 
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: <Widget>[
         const SizedBox(height: 100), 

         // Logo/Ikon
         Center(
          child: Transform.scale(
           scale: 0.8,
           child: Image.asset("assets/images/traxes-icon.png", fit: BoxFit.cover, height: 150),
          ),
         ),
         
         const SizedBox(height: 60),

         // Label NIP
         const Text(
          'NIP (Nomor Induk Pegawai)',
          style: TextStyle(
           fontSize: 14,
           fontWeight: FontWeight.w600,
           color: Color(0xFF374151),
          ),
         ),
         const SizedBox(height: 8),

         // Input Field NIP (TextFormField dengan validator)
         TextFormField( // <--- Diubah dari TextField
          controller: _nipController,
          focusNode: _nipFocusNode,
          keyboardType: TextInputType.number, 
          // 4. Tambahkan validator
          validator: (value) {
           if (value == null || value.isEmpty) {
            return 'NIP tidak boleh kosong';
           }
           return null; // Validasi berhasil
          },
          decoration: InputDecoration(
           hintText: 'Masukan NIP anda',
           hintStyle: TextStyle(color: Colors.grey.shade400),
           filled: true,
           fillColor: Colors.grey.shade50, 

           // Border saat tidak error dan tidak fokus
           border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFF0D6EFD), width: 1.0), 
           ),
           // Border saat fokus
           focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Color(0xFF0D6EFD), width: 1.5), 
           ),
           // Border saat ada error
           errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.red, width: 1.5), 
           ),
           focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.red, width: 1.5), 
           ),
           
           contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0, horizontal: 16.0),
          ),
          style: const TextStyle(
           color: Color(0xFF374151),
           fontSize: 16,
          ),
         ),
         const SizedBox(height: 10),
         // Login Button
         ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("login", true);
                var data = LoginModel(nik: _nipController.text);
                loginVM.loginEmployee(
                    formData: data,
                    onSuccess: () async {
                      Get.offAll(const BottomNavigation());
                    },
                    onFailed: (bodyMessage) {
                      String userInputText = _nipController.text;
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        title: "Login gagal",
                        titleTextStyle: largeBlackTextB,
                        text: "$bodyMessage \n NIP: $userInputText",
                        textTextStyle: standarBlackText,
                        confirmBtnText: "OK",
                        confirmBtnColor:const Color(0xFF1C4966),
                      );
                    });
              } else {
                // Opsional: tampilkan pesan kesalahan global jika diperlukan
                print("Validasi gagal.");
              }
          },
          style: ElevatedButton.styleFrom(
           backgroundColor: const Color(0xFF0D6EFD), 
           foregroundColor: Colors.white, 
           padding: const EdgeInsets.symmetric(vertical: 16),
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
           ),
           elevation: 0, 
          ),
          child: const Text(
           'Login',
           style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
           ),
          ),
         ),
         const SizedBox(height: 10),
         Align(
          alignment: Alignment.centerRight,
          child: TextButton(
           onPressed: _onForgotNIPPressed,
           child: const Text(
            'Kendala Login?',
            style: TextStyle(
             fontSize: 14,
             color: Color(0xFF0D6EFD), 
             fontWeight: FontWeight.w600,
            ),
           ),
          ),
         ),
         const SizedBox(height: 20),

         // Padding ekstra agar konten tidak tertutup oleh teks copyright
         const SizedBox(height: 50), 
        ],
       ),
      ),
     ),
    ),

    // 2. Teks Copyright
    Align(
     alignment: Alignment.bottomCenter,
     child: Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text("v$versionApp", style: extraSmallBlackText),
     ),
    ),
   ],
  ),
 );
}
}
