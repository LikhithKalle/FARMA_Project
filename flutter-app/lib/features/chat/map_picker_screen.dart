import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  // Constants from design
  static const Color primaryColor = Color(0xFF13EC6A);
  static const Color backgroundDark = Color(0xFF102217);
  static const Color surfaceHighlight = Color(0xFF23392D);
  static const Color textDark = Color(0xFF111814);

  // MapTiler Key (from backend)
  static const String mapTilerKey = "YImAWWEWi6rTSIyvNnMW";

  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  
  // Hyderabad as default center
  // Hyderabad as default center
  LatLng _center = const LatLng(17.3850, 78.4867);
  bool _isLoading = false;
  List<dynamic> _searchResults = [];
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Debounce search
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
       _searchPlaces(query);
    });
  }

  void _searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      if (mounted) setState(() => _searchResults = []);
      return;
    }
    
    // Don't set loading for every keystroke to avoid flickering, 
    // but maybe show a small indicator in the TextField
    
    try {
      final url = Uri.parse(
        'https://api.maptiler.com/geocoding/$query.json?key=$mapTilerKey&limit=5&autocomplete=true'
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _searchResults = data['features'] ?? [];
          });
        }
      }
    } catch (e) {
      debugPrint("Search error: $e");
    }
  }


  void _moveToLocation(double lat, double lon) {
    final newCenter = LatLng(lat, lon);
    _mapController.move(newCenter, 13.0);
    setState(() {
      _center = newCenter;
      _searchResults.clear();
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? backgroundDark : Colors.white;
    final Color textColor = isDark ? Colors.white : textDark;
    
    return Scaffold(
      body: Stack(
        children: [
          // 1. Map Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 13.0,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    _center = position.center;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.maptiler.com/maps/basic-v2/{z}/{x}/{y}.png?key=$mapTilerKey',
                userAgentPackageName: 'com.example.farma',
              ),
            ],
          ),

          // 2. Center Pin (Fixed)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30), // Offset for pin point
              child: Icon(
                Icons.location_on, 
                size: 40, 
                color: Colors.red[700]
              ),
            ),
          ),

          // 3. Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 8)
                    ]
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: textColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            hintText: "Search city, village...",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          onChanged: _onSearchChanged,
                          onSubmitted: (val) {
                            if (_debounce?.isActive ?? false) _debounce!.cancel();
                            _searchPlaces(val);
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: primaryColor),
                        onPressed: () => _searchPlaces(_searchController.text),
                      ),
                    ],
                  ),
                ),
                // Search Results List
                if (_searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final item = _searchResults[index];
                        return ListTile(
                          title: Text(item['place_name'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: textColor, fontSize: 13)
                          ),
                          onTap: () {
                             final center = item['center']; // [lon, lat]
                             final lon = center[0];
                             final lat = center[1];
                             _moveToLocation(lat, lon);
                             FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
                  )
              ],
            ),
          ),

          // 4. Confirm Button
          Positioned(
            bottom: 32,
            left: 32,
            right: 32,
            child: SizedBox(
               height: 50,
               child: ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   backgroundColor: primaryColor,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                 ),
                 onPressed: () {
                   // Return the center coordinates
                   Navigator.pop(context, _center);
                 },
                 child: Text(
                   "Confirm Location", 
                   style: GoogleFonts.lexend(
                     color: backgroundDark, 
                     fontWeight: FontWeight.bold,
                     fontSize: 16
                   )
                 ),
               ),
            ),
          )
        ],
      ),
    );
  }
}
