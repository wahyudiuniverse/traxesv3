import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traxes/bloc/feature/mbd/edit_mbd/edit.mbd.bloc.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/model/edit_mbd/edit.mbd.model.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? secid;
  final String? photoUrl;
  final String? statusMbd;
  final String? displayDate;
  final String? statusDisplay;
  final String? customerName;

  const OrderDetailsScreen({
    super.key,
    this.secid,
    this.photoUrl,
    this.statusMbd,
    this.displayDate,
    this.statusDisplay,
    this.customerName,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String? currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.statusDisplay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProductImage(),
                    _buildDetailsCard(),
                    const SizedBox(height: 24),
                    _buildEditButton(context),
                    const SizedBox(height: 24), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C4966),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Detail MBD',
              style: largeWhiteText,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          'https://api.traxes.id/${widget.photoUrl}',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailItem(
            icon: Icons.shop,
            title: 'Toko/Lokasi',
            value: widget.customerName.toString(),
            isFirst: true,
          ),
          _buildDetailItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Tipe MBD',
            value: widget.statusMbd.toString(),
            isFirst: true,
          ),
          _buildDetailItem(
            icon: Icons.calendar_today_outlined,
            title: 'Tanggal MBD',
            value: widget.displayDate.toString(),
          ),
          const Divider(height: 1),
          _buildStatusSection(),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: !isLast ? BorderSide(color: Colors.grey[200]!) : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue[700], size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: standarBlackTextB,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    final Map<String, Map<String, dynamic>> statusStyles = {
      '0': {
        'style': TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.blue[800],
          backgroundColor: Colors.blue[100],
        ),
        'text': 'Belum terverifikasi',
      },
      '1': {
        'style': TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.green[800],
          backgroundColor: Colors.green[100],
        ),
        'text': 'Diterima',
      },
      '2': {
        'style': TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.red[800],
          backgroundColor: Colors.red[100],
        ),
        'text': 'Ditolak',
      },
    };

    final Map<String, dynamic> currentStatusStyle = statusStyles[currentStatus] ??
        {'style': const TextStyle(fontSize: 14, color: Colors.black), 'text': 'Unknown'};

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: currentStatusStyle['style'].backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              currentStatusStyle['text'],
              style: currentStatusStyle['style'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          _showStatusChangeDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1C4966),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit_outlined, size: 20),
            const SizedBox(width: 8),
            Text(
              'Ubah status',
              style: standarWhiteTextB,
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedStatus = currentStatus; // Use currentStatus here

        return AlertDialog(
          title: const Text('Ubah Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Belum terverifikasi'),
                value: '0',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                  Navigator.pop(context);
                  _updateStatus(context, selectedStatus);
                },
              ),
              RadioListTile<String>(
                title: const Text('Diterima'),
                value: '1',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                  Navigator.pop(context);
                  _updateStatus(context, selectedStatus);
                },
              ),
              RadioListTile<String>(
                title: const Text('Ditolak'),
                value: '2',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                  Navigator.pop(context);
                  _updateStatus(context, selectedStatus);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void _updateStatus(BuildContext context, String? status) {
    DateTime date = DateTime.now();
    if (status != null) {
      final formData = EditMbdModel(
        secId: widget.secid,
        verifyStatus: status,
        verifyOn: date.toString(),
      );

      if (kDebugMode) {
        print("isi --> ${formData.secId}");
        print("isi --> ${formData.verifyStatus}");
        print("isi --> ${formData.verifyOn}");
      }
     

      context.read<EditMbdBloc>().editMbd(formData, context);
    }
  }
}
