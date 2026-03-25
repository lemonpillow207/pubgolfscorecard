import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../providers/game_provider.dart';
import '../models/team.dart';

class ScorecardScreen extends StatelessWidget {
  const ScorecardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teams = context.watch<GameProvider>().teams;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scorecard'),
        actions: [
          if (teams.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: () => _showResults(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.emoji_events, color: Colors.white, size: 18),
                label: Text(
                  'Winner',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: teams.isEmpty ? const _NoTeamsPlaceholder() : _ScorecardBody(teams: teams),
    );
  }

  void _showResults(BuildContext context) {
    final ranking = context.read<GameProvider>().getRanking();
    showDialog(
      context: context,
      builder: (_) => _ResultsDialog(ranking: ranking),
    );
  }
}

class _NoTeamsPlaceholder extends StatelessWidget {
  const _NoTeamsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.scoreboard_outlined, size: 72, color: Colors.black12),
          const SizedBox(height: 16),
          Text(
            'No teams yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add teams on the Teams tab first',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black38),
          ),
        ],
      ),
    );
  }
}

class _ScorecardBody extends StatelessWidget {
  final List<Team> teams;
  const _ScorecardBody({required this.teams});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: teams.length,
      child: Column(
        children: [
          Container(
            color: kOrange,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 14),
              tabs: teams.map((t) => Tab(text: t.name)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: teams.map((t) => _TeamScorecard(teamId: t.id)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamScorecard extends StatelessWidget {
  final String teamId;
  const _TeamScorecard({required this.teamId});

  @override
  Widget build(BuildContext context) {
    final team = context.watch<GameProvider>().teams.firstWhere((t) => t.id == teamId);

    return Column(
      children: [
        _ScorecardSummaryBar(team: team),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: 18,
            itemBuilder: (_, i) => _HoleRow(
              key: ValueKey('${teamId}_hole_$i'),
              teamId: teamId,
              hole: i,
              initialScore: team.scores[i],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScorecardSummaryBar extends StatelessWidget {
  final Team team;
  const _ScorecardSummaryBar({required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border(bottom: BorderSide(color: kOrange.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                team.name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              if (team.players.isNotEmpty)
                Text(
                  team.players.map((p) => p.name).join(' · '),
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black45),
                ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${team.holesPlayed}/18 holes',
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.black45),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${team.totalScore}',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: kOrange,
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 4),
                    child: Text(
                      'pts',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HoleRow extends StatefulWidget {
  final String teamId;
  final int hole;
  final int? initialScore;

  const _HoleRow({
    super.key,
    required this.teamId,
    required this.hole,
    required this.initialScore,
  });

  @override
  State<_HoleRow> createState() => _HoleRowState();
}

class _HoleRowState extends State<_HoleRow> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialScore?.toString() ?? '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final teams = provider.teams;
    final teamIdx = teams.indexWhere((t) => t.id == widget.teamId);
    if (teamIdx == -1) return const SizedBox.shrink();
    final team = teams[teamIdx];
    final isDouble = team.doubleStrokes[widget.hole];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDouble ? Colors.orange.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDouble ? kOrange.withOpacity(0.35) : Colors.grey.shade200,
          width: isDouble ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
        child: Row(
          children: [
            // Hole circle
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDouble ? kOrange : kOrange.withOpacity(0.85),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${widget.hole + 1}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Score field
            Expanded(
              child: TextField(
                controller: _ctrl,
                keyboardType: const TextInputType.numberWithOptions(signed: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: '—',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black26,
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: kOrange, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (val) {
                  context.read<GameProvider>().updateScore(
                        widget.teamId,
                        widget.hole,
                        int.tryParse(val),
                      );
                },
              ),
            ),
            const SizedBox(width: 8),
            // Double stroke toggle
            GestureDetector(
              onTap: () => context
                  .read<GameProvider>()
                  .toggleDoubleStroke(widget.teamId, widget.hole),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isDouble ? kOrange : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.close_fullscreen,
                      size: 14,
                      color: isDouble ? Colors.white : Colors.black38,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '×2',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDouble ? Colors.white : Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsDialog extends StatelessWidget {
  final List<Team> ranking;
  const _ResultsDialog({required this.ranking});

  String _medal(int place) {
    switch (place) {
      case 1: return '🥇';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '$place.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            color: kOrange,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 6),
                Text(
                  'Final Results',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Lowest score wins',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ...ranking.asMap().entries.map((e) {
                  final place = e.key + 1;
                  final team = e.value;
                  final isFirst = place == 1;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isFirst
                          ? kOrange.withOpacity(0.12)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFirst
                            ? kOrange.withOpacity(0.4)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _medal(place),
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                team.name,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: isFirst ? kOrange : Colors.black87,
                                ),
                              ),
                              Text(
                                '${team.holesPlayed} holes played',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${team.totalScore}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            color: isFirst ? kOrange : Colors.black54,
                          ),
                        ),
                        Text(
                          ' pts',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close', style: GoogleFonts.poppins()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
