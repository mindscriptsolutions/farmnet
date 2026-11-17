import 'package:flutter/material.dart';

import '../data/crops.dart';
import 'crops_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 170,
            backgroundColor: const Color(0xFF1B5E20),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('About FarmNet'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
                  ),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Text('🌿', style: TextStyle(fontSize: 60)),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _card(
                  icon: Icons.info,
                  color: const Color(0xFF2E7D32),
                  title: 'What is FarmNet?',
                  child: const Text(
                    'FarmNet is an offline-first mobile app that helps farmers '
                    'identify crop diseases instantly. Snap a photo of a crop '
                    'leaf and an on-device AI model names the likely disease '
                    'with a confidence score, plus symptoms, prevention and '
                    'management advice — all working with no internet.',
                    style: TextStyle(fontSize: 15, height: 1.45),
                  ),
                ),
                _howItWorks(),
                _card(
                  icon: Icons.dataset,
                  color: const Color(0xFF1565C0),
                  title: 'Dataset used',
                  child: const Text(
                    'The model was trained on the PlantVillage dataset — a large '
                    'public collection of ~54,000 labelled leaf images across '
                    'healthy and diseased classes for 14 crops. Images are '
                    'single leaves on a plain background, which is why the app '
                    'works best on clear, close-up single-leaf photos.',
                    style: TextStyle(fontSize: 15, height: 1.45),
                  ),
                ),
                _card(
                  icon: Icons.memory,
                  color: const Color(0xFF6A1B9A),
                  title: 'How the model was built',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _Bullet(
                          'Architecture: MobileNetV2 — a lightweight CNN designed to run fast on phones.'),
                      _Bullet(
                          'Training: transfer learning on the PlantVillage images, learning to separate 38 crop/disease classes.'),
                      _Bullet(
                          'Conversion: the trained model is converted to TensorFlow Lite (~3 MB) so it runs fully on-device.'),
                      _Bullet(
                          'Input: a 224×224 leaf image; Output: a probability for each of the 38 classes.'),
                      _Bullet(
                          'The advisory text (symptoms, prevention, management) is stored in a local knowledge base bundled in the app.'),
                    ],
                  ),
                ),
                _specChips(),
                _supportedCropsCard(context),
                _accuracyCard(),
                _teamCard(),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Mind Script Solutions\nwww.mindscriptsolutions.in',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 13, height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required Color color,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _howItWorks() {
    final steps = [
      ['📷', 'Capture', 'Take or pick a photo of the affected leaf.'],
      ['🧠', 'Analyse', 'The on-device AI model classifies the disease offline.'],
      ['📋', 'Advice', 'Get symptoms, prevention and management steps.'],
    ];
    return _card(
      icon: Icons.auto_awesome,
      color: const Color(0xFFEF6C00),
      title: 'How it works',
      child: Column(
        children: [
          for (final s in steps)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s[0], style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s[1],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(s[2],
                            style: const TextStyle(
                                fontSize: 13.5, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _specChips() {
    final specs = [
      ['🧠', 'MobileNetV2'],
      ['🗂️', '38 classes'],
      ['📦', '~3 MB model'],
      ['⚡', 'TensorFlow Lite'],
      ['📡', '100% offline'],
      ['🌐', '3 languages'],
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final s in specs)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text('${s[0]}  ${s[1]}',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }

  Widget _supportedCropsCard(BuildContext context) {
    return _card(
      icon: Icons.grass,
      color: const Color(0xFF2E7D32),
      title: 'Supported crops & diseases',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detects $kTotalDiseases diseases plus healthy leaves across '
            '${kCrops.length} crops.',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in kCrops)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: c.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${c.emoji} ${c.name}',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonalIcon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CropsScreen()),
              ),
              icon: const Icon(Icons.list_alt),
              label: const Text('View full list'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accuracyCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFCC80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.tips_and_updates, color: Color(0xFFE65100)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Accuracy is highest on clear, single-leaf photos (like the '
              'training images). Messy field photos with busy backgrounds may '
              'be less accurate — a good area for future improvement.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamCard() {
    const members = [
      'S. Veerendra',
      'T. Yogasai',
      'S. Venkata Krishna',
      'M. Manoj Kumar',
    ];
    return _card(
      icon: Icons.groups,
      color: const Color(0xFFAD1457),
      title: 'Project team — Batch 13',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Department of Computer Science & Engineering,\n'
            'Santhiram Engineering College (SREC), Nandyal.',
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in members)
                Chip(
                  avatar: const CircleAvatar(
                    backgroundColor: Color(0xFFAD1457),
                    child: Icon(Icons.person, color: Colors.white, size: 16),
                  ),
                  label: Text(m),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, height: 1.4)),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 14.5, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
