import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webui/frontend/api.dart';
import 'package:webui/frontend/app_theme.dart';
import 'package:webui/frontend/smart_image.dart';

class OffersAdminScreen extends StatefulWidget {
  const OffersAdminScreen({super.key});

  @override
  State<OffersAdminScreen> createState() => _OffersAdminScreenState();
}

class _OffersAdminScreenState extends State<OffersAdminScreen> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _discountController = TextEditingController();
  final _imageController = TextEditingController();
  DateTime? _validTill;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OfferProvider>().fetchOffers();
    });
    _imageController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _discountController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _pickValidTill() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _validTill = picked);
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty ||
        _discountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Title and discount text are required")),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await ApiService().addOffer(
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      discountText: _discountController.text.trim(),
      image: _imageController.text.trim(),
      validTill: _validTill,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      _titleController.clear();
      _subtitleController.clear();
      _discountController.clear();
      _imageController.clear();
      setState(() => _validTill = null);

      await context.read<OfferProvider>().fetchOffers();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Offer added")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add offer. Try again.")),
      );
    }
  }

  Future<void> _deleteOffer(String id) async {
    final success = await ApiService().deleteOffer(id);
    if (success) {
      if (!mounted) return;
      context.read<OfferProvider>().fetchOffers();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to remove offer.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final offerProvider = context.watch<OfferProvider>();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryLight,
        title: Text(
          "Manage Offers",
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add a new offer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 14),

                if (_imageController.text.trim().isNotEmpty) ...[
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SmartImage(
                        imagePath: _imageController.text.trim(),
                        width: 160,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                _AdminOfferField(
                  controller: _imageController,
                  hint: "Image — asset filename or URL (optional)",
                  icon: Icons.image_outlined,
                ),
                const SizedBox(height: 10),
                _AdminOfferField(
                  controller: _titleController,
                  hint: "Offer title — e.g. Hair Spa Special",
                  icon: Icons.local_offer_outlined,
                ),
                const SizedBox(height: 10),
                _AdminOfferField(
                  controller: _subtitleController,
                  hint: "Subtitle / details",
                  icon: Icons.notes_outlined,
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                _AdminOfferField(
                  controller: _discountController,
                  hint: "Discount text — e.g. 15% OFF or ₹999",
                  icon: Icons.percent_outlined,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickValidTill,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event_outlined,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          _validTill == null
                              ? "Valid till (optional)"
                              : "Valid till ${_validTill!.day}/${_validTill!.month}/${_validTill!.year}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "Add Offer",
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            "Active offers",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 12),

          if (offerProvider.isLoading && offerProvider.offers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
            )
          else if (offerProvider.offers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "No offers added yet. The Bridal Makeup offer stays shown permanently regardless.",
                style: TextStyle(color: AppTheme.textLight),
              ),
            )
          else
            ...offerProvider.offers.map((offer) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SmartImage(
                        imagePath: offer.image,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            offer.discountText,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent),
                      onPressed: () => _deleteOffer(offer.id),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _AdminOfferField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;

  const _AdminOfferField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        prefixIcon: Icon(icon, color: Colors.white70, size: 20),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}