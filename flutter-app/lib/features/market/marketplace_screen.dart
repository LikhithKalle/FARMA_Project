import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/translation_service.dart';
import '../home/home_screen.dart';
import '../guide/crop_guide_screen.dart';
import '../profile/profile_screen.dart';
import '../advisory/advisory_screen.dart';
import '../history/chat_history_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> with SingleTickerProviderStateMixin {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.white;
    // For containers that need contrast:
    final containerColor = isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100;
    final iconColor = isDark ? Colors.white : Colors.black87;

    return ValueListenableBuilder<Locale>(
      valueListenable: TranslationService.locale,
      builder: (context, locale, child) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header with Cart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                   GestureDetector(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: containerColor,
                      ),
                      child: Icon(Icons.arrow_back, color: iconColor),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    TranslationService.tr('market'),
                    style: GoogleFonts.lexend(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  // Cart Icon
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: containerColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.shopping_cart, color: iconColor),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '2',
                            style: GoogleFonts.lexend(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white60,
                labelStyle: GoogleFonts.lexend(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: TranslationService.tr('shop')),
                  Tab(text: TranslationService.tr('contracts')),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildShopTab(context, primaryColor, containerColor, textColor, iconColor),
                  _buildContractsTab(context, primaryColor, containerColor, textColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildShopTab(BuildContext context, Color primaryColor, Color containerColor, Color textColor, Color iconColor) {
    // For text field border/bg
    final inputFill = Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFF1c2e20) 
      : Colors.white;
    final borderColor = Theme.of(context).dividerColor; // or Colors.grey[300]

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 56,
            decoration: BoxDecoration(
              color: inputFill,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor.withOpacity(0.1)),
              boxShadow: Theme.of(context).brightness == Brightness.light ? [BoxShadow(color: Colors.black12, blurRadius: 4, offset:const Offset(0,2))] : [],
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[400]),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: GoogleFonts.lexend(color: textColor),
                    decoration: InputDecoration(
                      hintText: TranslationService.tr('search_market'),
                      hintStyle: GoogleFonts.lexend(color: Colors.grey[500]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.mic, color: Color(0xFF13EC6A), size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip(context, TranslationService.tr('all_items'), true, primaryColor),
                _buildCategoryChip(context, '🌱 ${TranslationService.tr('seeds')}', false, primaryColor),
                _buildCategoryChip(context, '🧪 ${TranslationService.tr('fertilizers_cat')}', false, primaryColor),
                _buildCategoryChip(context, '🛡️ ${TranslationService.tr('pesticides')}', false, primaryColor),
                _buildCategoryChip(context, '🔧 ${TranslationService.tr('tools')}', false, primaryColor),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Featured Banner
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: const DecorationImage(
                image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCXuqM5LwD9T0xBtoogcYikvVMumxGRxepNwBVzxOZVAytneKpBHxHUvW_cWtD83lbJMbw4zkfeuEBbwSWEURCVyZqDmGkDGmz8MJu1FQplh1t5BXwG1_82nkiBL2kBTyxudnXLlCy3Ra-SFAct2HDNUir6brG6_qPa_ErzTzsI28whzUwVwdEJiB0OIeEZkXkOo_n42hBY4sZoTSMKCcU9yj5qWM8Ogk6mnFKMsdclKSZUL0rzYR1v_9HTfwn4hq_zwNH1CotBI48'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'SEASON SPECIAL',
                      style: GoogleFonts.lexend(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Best Seeds for Planting',
                    style: GoogleFonts.lexend(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'High yield varieties available now',
                        style: GoogleFonts.lexend(fontSize: 12, color: Colors.grey[300]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'View',
                          style: GoogleFonts.lexend(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recommended Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TranslationService.tr('recommended'),
                style: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              ),
              Text(
                TranslationService.tr('see_all'),
                style: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Product Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildProductCard(context,
                title: 'Hybrid Corn Seeds - 5kg',
                price: '₹1,050',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC4WliPVy6cqiSsBaRILu4DyikyI3uZbFdkBtUTU6hNB7pF1p1u_iPPrPSk5xwwZ0D0Y0awfNPyrlzkptO_X3-khGkxWFKbZnaDD3CbcY0wSgSrhIZU0cZM0KDRmuaimxbwsjEL7DYtAfzGYRQIUuLsaarPrIkuiGBpJhjqfWrYDI-qPZq2VHSPG-VfvHWDe6UUD1x4iIjo5A1SjnNct5BZzRbfwfi_RpQyaSfcYIHoUiVkSx4d3a19u6u-myyE6NCn0C8HxtPxhmQ',
                tag: 'Drought Resistant',
                tagColor: primaryColor,
                textColor: textColor,
              ),
              _buildProductCard(context,
                title: 'NPK 15-15-15 Premium',
                price: '₹2,100',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDbw7AfKQsP3u_lJn2dbvZNsj5kKsTMWobTEr5F5KhjzOgS4PSh_9R7-E-UWv_PD8vKo-Es_-kuNw-s4S4aMEtxUZvY6msc8QNshaYJtEyyUKozLieYg78HqFUpTiVWLr8aLVCH66-MmeT_UWL7tQBdwXhk9aNUajKWlFAzI8In1F9YBSX-3OaBQimpqiw9aal9RE9eKXdOXQAEE4Re-Tap1pLsquMolneA0VAeEmvbb1W05UFMpV8QxDScPGlO0pFU0cAeI586S6Y',
                tag: 'Growth Boost',
                tagColor: Colors.blueAccent,
                textColor: textColor,
              ),
              _buildProductCard(context,
                title: 'EcoGuard Pest Spray',
                price: '₹1,575',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB8YAM1Sbb_BzSJgFHYdBmcgyX0lV48F2n3B175u9DcL1fKHibhKdMfEZUylcigCrNG_v_XI5FwJZ78497JygNNbysKGfiq5913YlSm4-KRyGUx6PAJrjT3EBnEYeBAnyYQfZ8iILOZUSV2qIFjcDI07xUEMB9j5OP9sy7XqONyMIj5eOH309hB4ea7ZRIGYo5KB9deO-cklExpf2JRdHjnoH0AFlDVK7J-0YqMWtamzXvUki5DMpXThUcZYwvQi6SmkpL0QglerGg',
                tag: 'Insect Control',
                tagColor: Colors.redAccent,
                textColor: textColor,
              ),
              _buildProductCard(context,
                title: 'Roma Tomato Seeds',
                price: '₹750',
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBPXzvOFJxQ7V3PfMMelmfGmJKD-OsxqiFdjxTjrnMSHvvWWPO0tC39G-mSKfBlakB2LTeMpc9kzj4icqTu_5MM2a7ZzziaYQj9YKCr1e0s2HFGSBnSY0MqWz8oSW_ZiNn_VhqKBWIOXqM_CkfJDB7gM7zfmwAA4vD09CqBEmC8RVcs76FE6pkrtpCufPcoTCI-9z9LJWM101-T4n0MBpktEpKNTpTwuL82RMxOfVlqHUIfaYVJnu3j351__ks7GPf6Gi6qtVrBIyM',
                tag: 'High Yield',
                tagColor: primaryColor,
                textColor: textColor,
              ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String label, bool isSelected, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? primaryColor : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1)),
        ),
        boxShadow: isSelected ? [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 8)] : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? const Color(0xFF102217) : (isDark ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, {
    required String title,
    required String price,
    required String imageUrl,
    required String tag,
    required Color tagColor,
    required Color textColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1c2e20) : Colors.white;
    final borderColor = Theme.of(context).dividerColor.withOpacity(0.1);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(4)), // Replaced dark tag bg
                      child: Text(tag.toUpperCase(), style: GoogleFonts.lexend(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tag, style: GoogleFonts.lexend(fontSize: 10, fontWeight: FontWeight.bold, color: tagColor)),
                      const SizedBox(height: 4),
                      Text(title, style: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.bold, color: textColor), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                   ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(price, style: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: Color(0xFF13EC6A),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Icon(Icons.add, color: Colors.black87, size: 20),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractsTab(BuildContext context, Color primaryColor, Color containerColor, Color textColor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildContractCard(
          context: context,
          company: "Lay's India",
          logo: "L",
          crop: "Potato (Chip Grade)",
          quantity: "500 Tons",
          rate: "₹25/kg",
          expiry: "Expires in 2 days",
          color: Colors.redAccent,
          textColor: textColor,
        ),
        _buildContractCard(
          context: context,
          company: "Kissan Ketchup",
          logo: "K",
          crop: "Organic Tomato",
          quantity: "200 Tons",
          rate: "₹40/kg",
          expiry: "Expires in 5 days",
          color: Colors.orange,
          textColor: textColor,
        ),
        _buildContractCard(
          context: context,
          company: "ITC Aashirvaad",
          logo: "I",
          crop: "Premium Wheat",
          quantity: "1000 Tons",
          rate: "₹32/kg",
          expiry: "Expires in 10 days",
          color: Colors.blue,
          textColor: textColor,
        ),
      ],
    );
  }

  Widget _buildContractCard({
    required BuildContext context,
    required String company,
    required String logo,
    required String crop,
    required String quantity,
    required String rate,
    required String expiry,
    required Color color,
    required Color textColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF183222) : Colors.white;
    final borderColor = Theme.of(context).dividerColor.withOpacity(0.1);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                child: Text(logo, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(company, style: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  Text(expiry, style: GoogleFonts.lexend(fontSize: 12, color: Colors.redAccent)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("VERIFIED", style: GoogleFonts.lexend(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
              ),
            ],
          ),
          Divider(color: borderColor, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric("Crop", crop, textColor),
              _buildMetric("Qty", quantity, textColor),
              _buildMetric("Rate", rate, textColor),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13EC6A),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Apply Details"),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.lexend(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
      ],
    );
  }
}

