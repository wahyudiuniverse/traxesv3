import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Absen'),
                Tab(text: 'Order'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AbsenceTabContent(), // Konten untuk tab Absence
          Center(child: Text('Order Content Goes Here')),
        ],
      ),
    );
  }
}

// --- 2. Content for the Absence Tab ---
// --- Content for the Absence Tab (AbsenceTabContent) ---
class AbsenceTabContent extends StatelessWidget {
  const AbsenceTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column( // 🚀 Container dihapus, langsung ke Column
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Filter Buttons
          Row(
            children: <Widget>[
              FilterButton(
                icon: Icons.store,
                label: 'Toko',
                onPressed: () {},
              ),
              const SizedBox(width: 10),
              FilterButton(
                icon: Icons.calendar_today,
                label: 'Tanggal',
                onPressed: () {},
              ),
            ],
          ),
          
          const SizedBox(height: 25),
          
          // Section Title
          const Text(
            'Riwayat Absen',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 15),
          
          // History List Items (Check In/Out)
          const CheckInOutHistoryItem(
            date: 'Oct 25, 2023',
            company: 'GRAHA KRISTA AULIA',
            checkInTime: '09:03 AM',
            checkOutTime: '06:00 PM',
          ),
          const SizedBox(height: 10),
          const CheckInOutHistoryItem(
            date: 'Oct 24, 2023',
            company: 'RS. HARAPAN BUNDA',
            checkInTime: '08:55 AM',
            checkOutTime: '05:55 PM',
          ),
          const SizedBox(height: 10),
          const CheckInOutHistoryItem(
            date: 'Oct 23, 2023',
            company: 'APOTEK KIMIA FARMA',
            checkInTime: '08:45 AM',
            checkOutTime: '05:30 PM',
          ),
        ],
      ),
    );
  }
}

// --- 3. Reusable Check In/Out History Item Widget ---
class CheckInOutHistoryItem extends StatelessWidget {
  final String date;
  final String company;
  final String checkInTime;
  final String checkOutTime;

  const CheckInOutHistoryItem({
    required this.date,
    required this.company,
    required this.checkInTime,
    required this.checkOutTime,
    super.key,
  });

  Widget _buildTimeRow(IconData icon, Color color, String label, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Icon and Label (e.g., Check In)
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontSize: 15, color: Colors.grey[800]),
              ),
            ],
          ),
          // Time
          Text(
            time,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Header: Date and Company Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  company,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue[600],
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 0.5, color: Color(0xFFE0E0E0)),

            // Check In Detail
            _buildTimeRow(
              Icons.arrow_forward_outlined, 
              Colors.green, 
              'Check In', 
              checkInTime,
            ),

            // Check Out Detail
            _buildTimeRow(
              Icons.arrow_back_outlined, 
              Colors.deepOrange, 
              'Check Out', 
              checkOutTime,
            ),
          ],
        ),
      ),
    );
  }
}

// --- 4. Reusable Filter Button Widget ---
class FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const FilterButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black87),
        label: Text(
          label,
          style: const TextStyle(color: Colors.black87),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[300]!),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}

// --- Helper Widget dari Layar Profile Sebelumnya (Disertakan untuk Kelengkapan) ---
class ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetailRow({
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}