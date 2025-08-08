
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traxes/bloc/feature/display_mbd/display.mbd.bloc.dart';

class SuccessMbdScreen extends StatefulWidget {
  const SuccessMbdScreen({super.key});

  @override
  State<SuccessMbdScreen> createState() => _SuccessMbdScreenState();
}

class _SuccessMbdScreenState extends State<SuccessMbdScreen> {
  @override

 
  Widget build(BuildContext context) {
     Future<void> closeAndRefresh() async {
  Navigator.pop(context);
  setState(() {
        context.read<DisplayMbdBloc>().getMbdDisplay(context: context);

  });
}
    return Scaffold(
   
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Data Submitted Successfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
             closeAndRefresh();
              },
              child: const Text('Kembali ke halaman display'),
            ),
          ],
        ),
      ),
    );
  }
}
