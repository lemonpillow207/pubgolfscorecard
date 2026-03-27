import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../models/team.dart';
import '../providers/game_provider.dart';

class PowerupsScreen extends StatelessWidget {
  const PowerupsScreen({super.key});

  void _confirmUse(BuildContext context, String teamId, PowerupEntry entry) {
    final label = entry.isPowerDown ? 'Power Down activeren' : 'Power Up activeren';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          entry.name,
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuleren',
                style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GameProvider>().usePowerup(teamId, entry.questionIndex);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: kOrange),
            child: Text('Activeren',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teams = context.watch<GameProvider>().teams;

    return Scaffold(
      appBar: AppBar(title: const Text('Powerups')),
      body: teams.isEmpty
          ? Center(
              child: Text(
                'Voeg eerst teams toe.',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: teams.length,
              itemBuilder: (context, i) {
                final team = teams[i];
                final powerups = team.powerups;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              team.name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${powerups.where((p) => !p.used).length} beschikbaar',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        if (powerups.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Nog geen powerups verdiend.',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 10),
                          ...powerups.map((entry) => _PowerupRow(
                                entry: entry,
                                onUse: () =>
                                    _confirmUse(context, team.id, entry),
                              )),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _PowerupRow extends StatelessWidget {
  final PowerupEntry entry;
  final VoidCallback onUse;

  const _PowerupRow({required this.entry, required this.onUse});

  @override
  Widget build(BuildContext context) {
    final activeColor = entry.isPowerDown ? Colors.red : kOrange;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            entry.isPowerDown ? Icons.arrow_downward : Icons.bolt,
            color: entry.used ? Colors.grey.shade300 : activeColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              entry.name,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: entry.used ? Colors.grey : Colors.black87,
                decoration: entry.used ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          if (entry.used)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Gebruikt',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            )
          else
            ElevatedButton(
              onPressed: onUse,
              style: ElevatedButton.styleFrom(
                backgroundColor: kOrange,
                minimumSize: const Size(80, 30),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                'Gebruik',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
