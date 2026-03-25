import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../providers/game_provider.dart';

class AddTeamDialog extends StatefulWidget {
  const AddTeamDialog({super.key});

  @override
  State<AddTeamDialog> createState() => _AddTeamDialogState();
}

class _AddTeamDialogState extends State<AddTeamDialog> {
  final _teamNameCtrl = TextEditingController();
  final List<TextEditingController> _playerCtrls = [TextEditingController()];

  @override
  void dispose() {
    _teamNameCtrl.dispose();
    for (final c in _playerCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  InputDecoration _inputDecor(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.black26, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kOrange, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        filled: true,
        fillColor: Colors.grey.shade50,
      );

  void _addPlayer() =>
      setState(() => _playerCtrls.add(TextEditingController()));

  void _removePlayer(int i) {
    if (_playerCtrls.length <= 1) return;
    setState(() {
      _playerCtrls[i].dispose();
      _playerCtrls.removeAt(i);
    });
  }

  void _submit() {
    final name = _teamNameCtrl.text.trim();
    if (name.isEmpty) return;
    context.read<GameProvider>().addTeam(
          name,
          _playerCtrls.map((c) => c.text.trim()).toList(),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            color: kOrange,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'New Team',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Team Name',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54)),
                const SizedBox(height: 6),
                TextField(
                  controller: _teamNameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecor('e.g. The Thirsty Foxes'),
                  style: GoogleFonts.poppins(fontSize: 14),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                Text('Players',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54)),
                const SizedBox(height: 6),
                ...List.generate(
                  _playerCtrls.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _playerCtrls[i],
                            textCapitalization: TextCapitalization.words,
                            decoration: _inputDecor('Player ${i + 1}'),
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ),
                        if (_playerCtrls.length > 1) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _removePlayer(i),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.remove,
                                  color: Colors.red, size: 16),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _addPlayer,
                  icon: const Icon(Icons.add_circle_outline, color: kOrange, size: 18),
                  label: Text('Add Player',
                      style: GoogleFonts.poppins(
                          color: kOrange, fontWeight: FontWeight.w500)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Create Team',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
