import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class PubStop {
  final String name;
  final String address;
  final String mapsUrl;
  const PubStop({required this.name, required this.address, required this.mapsUrl});
}

// TODO: Replace with your actual 18 pubs, addresses and Google Maps URLs
const List<PubStop> _stops = [
  PubStop(name: 'Hole 1 - Bruincafé t Centrum', address: '',mapsUrl: 'https://maps.app.goo.gl/Lceq5AVe3deajTFM8'),
  PubStop(name: 'Hole 2 - De Kroon', address: '',mapsUrl: 'https://maps.app.goo.gl/vtcoeJkL1Nj9awjv8'),
  PubStop(name: 'Hole 3 - Three Sisters', address: '',mapsUrl: 'https://maps.app.goo.gl/Fxx3h1JX2qFh7jgr8'),
  PubStop(name: 'Hole 4 - Ice Bar', address: '',mapsUrl: 'https://maps.app.goo.gl/w2T9jbCfNNQK6xmN8'),
  PubStop(name: 'Hole 5 - Cafe Emmelot', address: '',mapsUrl: 'https://maps.app.goo.gl/Adr1E2j2aEXQNeVE8'),
  PubStop(name: 'Hole 6 - Cafe de Doelen', address: '',mapsUrl: 'https://maps.app.goo.gl/YQf2fFRFNHiDcb8j9'),
  PubStop(name: 'Hole 7 - Cafe Cuba', address: '',mapsUrl: 'https://maps.app.goo.gl/W92oVX9DLAMvMsdW9'),
  PubStop(name: 'Hole 8 - Cafe in de Waag', address: '',mapsUrl: 'https://maps.app.goo.gl/Q4FMPEdgZCEG9L6QA'),
  PubStop(name: 'Hole 9 - Bananen Bar', address: '',mapsUrl: 'https://maps.app.goo.gl/uKvL1yM1Kzy71eT29'),
  PubStop(name: 'Hole 10 - Yip Fellows', address: '',mapsUrl: 'https://maps.app.goo.gl/nvhDbvmrabQ5gMbk7'),
  PubStop(name: 'Hole 11 - Gastropub Rokin 85', address: '',mapsUrl: 'https://maps.app.goo.gl/z5QEykqxuXhQo1pX8'),
  PubStop(name: 'Hole 12 - Bier Fabriek', address: '',mapsUrl: 'https://maps.app.goo.gl/uE42dwgSkmWs7rA89'),
  PubStop(name: 'Hole 13 - Lange Leo', address: '',mapsUrl: 'https://maps.app.goo.gl/xdCd79Hfo4vM4n4N8'),
  PubStop(name: 'Hole 14 - Café Luxembourg', address: '',mapsUrl: 'https://maps.app.goo.gl/cP8g68qw7EtgBysh9'),
  PubStop(name: 'Hole 15 - Brabantse aap', address: '',mapsUrl: 'https://maps.app.goo.gl/vuRag445Jk2FFoCx7'),
  PubStop(name: 'Hole 16 - Satellite SportsCafé', address: '',mapsUrl: 'https://maps.app.goo.gl/UovGKVHAmHhqGQtB7'),
  PubStop(name: 'Hole 17 - Bar Americain', address: '',mapsUrl: 'https://maps.app.goo.gl/zLLppm8jgs3newgr9'),
  PubStop(name: 'Hole 18 - Bar Twenty Two', address: '',mapsUrl: 'https://maps.app.goo.gl/soYLGduoZ5UrKNvt7'),
];

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        itemCount: _stops.length,
        itemBuilder: (_, i) => _PubCard(stop: _stops[i], number: i + 1),
      ),
    );
  }
}

class _PubCard extends StatelessWidget {
  final PubStop stop;
  final int number;
  const _PubCard({required this.stop, required this.number});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: kOrange,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$number',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  if (stop.address.isNotEmpty)
                    Text(
                      stop.address,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _launch(stop.mapsUrl),
              icon: const Icon(Icons.directions, size: 14),
              label: Text('Maps', style: GoogleFonts.poppins(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri);
    }
  }
}
