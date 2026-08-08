import 'package:flutter/material.dart';
import 'package:webui/frontend/api.dart';
import 'package:webui/frontend/app_theme.dart';
import 'package:webui/frontend/models.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  final List<TimeOfDay> _slots = [
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 0),
    const TimeOfDay(hour: 12, minute: 0),
    const TimeOfDay(hour: 14, minute: 0),
    const TimeOfDay(hour: 15, minute: 0),
    const TimeOfDay(hour: 16, minute: 0),
    const TimeOfDay(hour: 17, minute: 0),
  ];

  DateTime? _selectedDate;
  bool _fullDayBlocked = false;
  final Set<String> _selectedSlots = {};
  final _reasonController = TextEditingController();

  bool _isSaving = false;
  bool _isLoadingList = true;
  List<AvailabilityModel> _blockedEntries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _timeKey(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  String _dateKey(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  Future<void> _loadEntries() async {
    setState(() => _isLoadingList = true);
    try {
      _blockedEntries = await ApiService().getAllAvailability();
    } catch (e) {
      debugPrint(e.toString());
    }
    if (mounted) setState(() => _isLoadingList = false);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _fullDayBlocked = false;
        _selectedSlots.clear();
        _reasonController.clear();
      });
    }
  }

  Future<void> _save() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a date first")),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await ApiService().setAvailability(
      date: _dateKey(_selectedDate!),
      fullDayBlocked: _fullDayBlocked,
      blockedSlots: _selectedSlots.toList(),
      reason: _reasonController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Availability updated")),
      );
      setState(() {
        _selectedDate = null;
        _fullDayBlocked = false;
        _selectedSlots.clear();
        _reasonController.clear();
      });
      _loadEntries();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update. Try again.")),
      );
    }
  }

  Future<void> _deleteEntry(AvailabilityModel entry) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove block?"),
        content: Text(
            "This will make ${entry.date} available again for bookings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Remove"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await ApiService().deleteAvailability(entry.id);
    if (success) {
      _loadEntries();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to remove block.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryLight,
        title: Text(
          "Manage Availability",
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
          // ── New block form ─────────────────────────────────
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
                  "Block a date",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          _selectedDate == null
                              ? "Select a date"
                              : _dateKey(_selectedDate!),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_selectedDate != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Switch(
                        value: _fullDayBlocked,
                        activeColor: Colors.white,
                        onChanged: (v) => setState(() => _fullDayBlocked = v),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "Block the entire day",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  if (!_fullDayBlocked) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Or block specific time slots:",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _slots.map((slot) {
                        final key = _timeKey(slot);
                        final selected = _selectedSlots.contains(key);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selected
                                  ? _selectedSlots.remove(key)
                                  : _selectedSlots.add(key);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              slot.format(context),
                              style: TextStyle(
                                color: selected
                                    ? AppTheme.primaryDark
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 14),
                  TextField(
                    controller: _reasonController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Reason (optional) — e.g. Staff leave",
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
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
                              "Save",
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            "Currently blocked dates",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 12),

          if (_isLoadingList)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
            )
          else if (_blockedEntries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "No dates are currently blocked.",
                style: TextStyle(color: AppTheme.textLight),
              ),
            )
          else
            ..._blockedEntries.map((entry) {
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.date,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.fullDayBlocked
                                ? "Full day blocked"
                                : "Blocked: ${entry.blockedSlots.join(', ')}",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textLight,
                            ),
                          ),
                          if (entry.reason.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                entry.reason,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: AppTheme.textLight,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent),
                      onPressed: () => _deleteEntry(entry),
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