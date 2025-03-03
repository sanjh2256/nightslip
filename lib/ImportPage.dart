import 'package:flutter/material.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({Key? key}) : super(key: key);

  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _importCSV() async {
    // TODO: Implement CSV import functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and title
              Row(
                children: [
                  Image.asset(
                    'assets/logosmall.png',
                    height: 30,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 40),

              // Import Data Title with gradient - still centered
              Center(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFE68A00), Color(0xFFFFAA00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    'IMPORT DATA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'DMSerifText',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tabs
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF282828),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFFE68A00),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  tabs: const [
                    Tab(text: 'Nightslips'),
                    Tab(text: 'Events'),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Nightslips tab
                    _buildImportSection(
                      isNightslip: true,
                      title: 'Nightslip Records',
                      description: 'Import all nightslip records for review and reporting',
                    ),

                    // Events tab
                    _buildImportSection(
                      isNightslip: false,
                      title: 'Event Records',
                      description: 'Import all event records for review and reporting',
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

  Widget _buildImportSection({
    required bool isNightslip,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row for icon and text, aligned to the left
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Custom icon for nightslip or events
            if (isNightslip)
              _buildMoonIcon()
            else
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFE68A00),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            const SizedBox(width: 16),

            // Column for title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DMSerifText',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'DMSerifText',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Import button
        Center(
          child: ElevatedButton(
            onPressed: _importCSV,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE68A00),
              minimumSize: const Size(220, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'IMPORT CSV',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Spacer(),

        // View Export History
        Center(
          child: TextButton(
            onPressed: () {
              // TODO: Implement view export history functionality
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.access_time, color: Colors.white70, size: 16),
                SizedBox(width: 8),
                Text(
                  'View Export History',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Custom moon icon widget to match your design
  Widget _buildMoonIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFFE68A00),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // White circle for the main part of the moon
          Positioned(
            right: 12,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Orange circle
          Positioned(
            left: 28,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFE68A00),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}