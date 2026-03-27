import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../providers/game_provider.dart';
import '../data/questions.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({super.key});

  void _showAnswer(BuildContext context, Question q, int index) {
    final color = q.isPowerDown ? Colors.red : Colors.green;
    final label = q.isPowerDown ? 'Power Down' : 'Power Up';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Vraag ${index + 1} — Antwoord',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q.answer, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(q.isPowerDown ? Icons.arrow_downward : Icons.bolt, color: color, size: 14),
                    const SizedBox(width: 4),
                    Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
                  ]),
                  const SizedBox(height: 4),
                  Text(q.powerup, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Sluiten', style: GoogleFonts.poppins(color: kOrange)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teams = context.watch<GameProvider>().teams;

    return Scaffold(
      appBar: AppBar(title: const Text('Vragen')),
      body: teams.isEmpty
          ? Center(
              child: Text(
                'Voeg eerst teams toe.',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: kQuestions.length,
              itemBuilder: (context, i) {
                final q = kQuestions[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: kOrange,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${i + 1}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                q.question,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: q.isPowerDown ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(q.isPowerDown ? Icons.arrow_downward : Icons.bolt,
                                    size: 11, color: q.isPowerDown ? Colors.red : Colors.green),
                                const SizedBox(width: 3),
                                Text(
                                  q.isPowerDown ? 'Down' : 'Up',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: q.isPowerDown ? Colors.red : Colors.green,
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(width: 6),
                            TextButton(
                              onPressed: () => _showAnswer(context, q, i),
                              style: TextButton.styleFrom(
                                backgroundColor: kOrange.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                              ),
                              child: Text(
                                'Antwoord',
                                style: GoogleFonts.poppins(
                                  color: kOrange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        ...teams.map((team) {
                          final result = team.questionResults[i];
                          return _TeamResultRow(
                            team: team,
                            result: result,
                            onChanged: (val) {
                              context
                                  .read<GameProvider>()
                                  .setQuestionResult(team.id, i, val);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _TeamResultRow extends StatelessWidget {
  final dynamic team;
  final bool? result;
  final ValueChanged<bool?> onChanged;

  const _TeamResultRow({
    required this.team,
    required this.result,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              team.name,
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ),
          _AnswerButton(
            label: '✓',
            active: result == true,
            activeColor: Colors.green,
            onTap: () => onChanged(result == true ? null : true),
          ),
          const SizedBox(width: 8),
          _AnswerButton(
            label: '✗',
            active: result == false,
            activeColor: Colors.red,
            onTap: () => onChanged(result == false ? null : false),
          ),
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final String label;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  const _AnswerButton({
    required this.label,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 30,
        decoration: BoxDecoration(
          color: active ? activeColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey.shade500,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
