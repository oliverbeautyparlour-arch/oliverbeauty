import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'api.dart';
import 'smart_image.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OfferProvider>().fetchOffers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final offerProvider = context.watch<OfferProvider>();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Offers & Deals",
          style: TextStyle(color: AppTheme.primaryDark),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryDark,
                AppTheme.primary,
                AppTheme.accent,
              ],
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.primary),
        titleTextStyle: const TextStyle(
          fontFamily: 'Georgia',
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () => context.read<OfferProvider>().fetchOffers(),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              "Exclusive Beauty Offers",
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Pamper yourself with our latest beauty packages.",
              style: TextStyle(color: AppTheme.textLight),
            ),
            const SizedBox(height: 20),

            // ── Permanent Bridal Makeup Offer — always shown, not admin-editable ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryDark, AppTheme.primary],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryDark.withValues(alpha: .25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/Bridal-makeup (1).webp"),
                  const SizedBox(height: 20),
                  const Text(
                    "Bridal Makeup Offer",
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Flat 20% OFF",
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      color: AppTheme.accentLight,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Includes:\n"
                    "• HD Bridal Makeup\n"
                    "• Hair Styling\n"
                    "• Saree Draping\n"
                    "• Basic Accessories",
                    style: TextStyle(color: Colors.white, height: 1.6),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .18),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "Always available",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryDark,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Book Now",
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ── Dynamic offers, added by admin ──────────────────────────
            if (offerProvider.isLoading && offerProvider.offers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: CircularProgressIndicator(color: AppTheme.primary),
                ),
              )
            else if (offerProvider.offers.isNotEmpty) ...[
              for (final offer in offerProvider.offers) ...[
                _offerCard(
                  title: offer.title,
                  subtitle: offer.subtitle,
                  discount: offer.discountText,
                  image: offer.image,
                ),
                const SizedBox(height: 18),
              ],
            ],

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppTheme.divider),
              ),
              child: const Text(
                "* Offers are subject to availability.\n"
                "* Discounts cannot be combined.\n"
                "* Terms & Conditions Apply.",
                style: TextStyle(color: AppTheme.textMid, height: 1.6),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _offerCard({
    required String title,
    required String subtitle,
    required String discount,
    String image = "",
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          if (image.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SmartImage(
                imagePath: image,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            )
          else
            CircleAvatar(
              radius: 28,
              backgroundColor: AppTheme.surface,
              child: const Icon(
                Icons.local_offer,
                color: AppTheme.primary,
                size: 26,
              ),
            ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textDark,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              discount,
              style: const TextStyle(
                fontFamily: 'Georgia',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}