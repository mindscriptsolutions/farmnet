import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:farmnet/services/knowledge_base.dart';

void main() {
  test('knowledge base fallback returns readable crop/disease', () {
    // Without loading assets, lookup should still degrade gracefully.
    final info = KnowledgeBase.lookup('Tomato___Late_blight');
    expect(info['crop'], isNotNull);
    expect(info['disease'], isNotNull);
    expect(info['management'], isNotNull);
  });

  testWidgets('smoke: a basic widget builds', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('FarmNet'))),
    );
    expect(find.text('FarmNet'), findsOneWidget);
  });
}
