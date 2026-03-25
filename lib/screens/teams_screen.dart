import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../providers/game_provider.dart';
import '../models/team.dart';
import '../widgets/add_team_dialog.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teams = context.watch<GameProvider>().teams;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset('assets/logo.jpeg', height: 32),
            ),
            const SizedBox(width: 10),
            const Text('Pub Golf'),
          ],
        ),
      ),
      body: teams.isEmpty
          ? _EmptyTeamsState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: teams.length,
              itemBuilder: (_, i) => _TeamCard(team: teams[i]),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const AddTeamDialog(),
        ),
        icon: const Icon(Icons.group_add),
        label: Text('Add Team', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _EmptyTeamsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/logo.jpeg', height: 90),
            ),
            const SizedBox(height: 28),
            Text(
              'No teams yet',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the button below to add your first team',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final Team team;
  const _TeamCard({required this.team});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: kOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    team.name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${team.players.length} player${team.players.length != 1 ? 's' : ''}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _confirmDelete(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                  ),
                ),
              ],
            ),
            if (team.players.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: team.players
                    .map((p) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: kOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: kOrange.withOpacity(0.2)),
                          ),
                          child: Text(
                            p.name,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: kOrange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove Team', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text('Remove "${team.name}" from the tournament?',
            style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GameProvider>().removeTeam(team.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Remove', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}
