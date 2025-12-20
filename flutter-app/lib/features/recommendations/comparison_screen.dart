import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComparisonScreen extends StatelessWidget {
  final List<dynamic> recommendations;

  const ComparisonScreen({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    // Take top 3 or less (but at least 2 for comparison)
    final crops = recommendations.take(3).toList();
    if (crops.length < 2) {
      return Scaffold(
        appBar: AppBar(title: Text("Comparison")),
        body: Center(child: Text("Need at least 2 crops to compare")),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFF14281D);
    final cardColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFF1A3525);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Comparing Options", style: GoogleFonts.lexend(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0), // Reduced padding to fit 3
        child: Column(
          children: [
            Text(
              "Top ${crops.length} Recommendations",
              style: GoogleFonts.lexend(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              "Based on your soil data & weather forecast",
              style: GoogleFonts.lexend(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 20),

            // Main Comparison Table (Dynamic Rows)
            _buildComparisonRow(
              children: crops.asMap().entries.map((e) {
                return _buildCropImageCard(e.value, e.key == 0); 
              }).toList()
            ),
            const SizedBox(height: 16),

             _buildComparisonRow(
              children: crops.map((c) => 
                _buildMetricCard(
                  "Suitability", 
                  "${(c['confidence'] * 100).toInt()}%", 
                  (c['confidence'] > 0.8) ? "Excellent" : "Good", 
                  (c['confidence'] > 0.8) ? Colors.greenAccent : Colors.white, 
                  cardColor)
              ).toList()
            ),
            const SizedBox(height: 12),

             _buildComparisonRow(
              children: crops.map((c) => _buildWaterCard(c['waterRequirement'], cardColor)).toList()
            ),
             const SizedBox(height: 12),

             _buildComparisonRow(
              children: crops.map((c) => _buildRiskCard(c['riskLevel'], cardColor)).toList()
            ),
            const SizedBox(height: 24),
            
            // Buttons
             _buildComparisonRow(
              children: crops.map((c) => 
                 ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       backgroundColor: const Color(0xFF00E676),
                       foregroundColor: Colors.black,
                       padding: const EdgeInsets.symmetric(vertical: 12),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                       minimumSize: const Size(0, 48)
                     ),
                     onPressed: () {},
                     child: Text("Select\n${c['cropName']}", textAlign: TextAlign.center, style: GoogleFonts.lexend(fontWeight: FontWeight.bold, fontSize: 12)),
                   )
              ).toList()
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow({required List<Widget> children}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((w) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: w,
        )
      )).toList(),
    );
  }

  Widget _buildCropImageCard(dynamic crop, bool isTopChoice) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(crop['imageUrl'] ?? "https://via.placeholder.com/200"),
          fit: BoxFit.cover
        ),
      ),
      child: Stack(
        children: [
          Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(20),
               gradient: LinearGradient(
                 begin: Alignment.topCenter, end: Alignment.bottomCenter,
                 colors: [Colors.transparent, Colors.black.withOpacity(0.8)]
               )
             ),
          ),
          Positioned(
            bottom: 12, left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(crop['cropName'], style: GoogleFonts.lexend(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                if (isTopChoice)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                    child: Text("TOP CHOICE", style: GoogleFonts.lexend(color: const Color(0xFF00E676), fontSize: 10, fontWeight: FontWeight.bold)),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String subtitle, Color valueColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.lexend(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.lexend(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          Row(children: [
            if (valueColor == Colors.greenAccent) const Icon(Icons.verified, color: Colors.greenAccent, size: 16),
            const SizedBox(width: 4),
            Text(subtitle, style: GoogleFonts.lexend(color: valueColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ])
        ],
      ),
    );
  }

  Widget _buildWaterCard(String level, Color bgColor) {
     int drops = level == "High" ? 3 : (level == "Medium" ? 2 : 1);
     return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Water Needs", style: GoogleFonts.lexend(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 8),
          Row(children: List.generate(3, (i) => Icon(
            Icons.water_drop, 
            color: i < drops ? Colors.blueAccent : Colors.white10,
            size: 20
          ))),
          const SizedBox(height: 4),
          Text("$level Requirement", style: GoogleFonts.lexend(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

    Widget _buildRiskCard(String level, Color bgColor) {
     Color color = level == "Low" ? Colors.greenAccent : (level == "Medium" ? Colors.orangeAccent : Colors.redAccent);
     return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Risk Level", style: GoogleFonts.lexend(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 8),
          Row(children: [
            Icon(Icons.circle, color: color, size: 12),
            const SizedBox(width: 6),
            Text(level, style: GoogleFonts.lexend(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 4),
          Text(level == "Low" ? "Stable market price." : "Moderate volatility.", 
            style: GoogleFonts.lexend(color: Colors.white70, fontSize: 10)
          ),
        ],
      ),
    );
  }
}
