import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fenal_mobile/main.dart';

void main() {
  testWidgets('Test de chargement de l\'application', (WidgetTester tester) async {
    // Construit l'application avec ProviderScope pour Riverpod
    await tester.pumpWidget(const ProviderScope(child: FenalApp()));

    // Attend la fin des animations initiales
    await tester.pumpAndSettle();

    // Vérifie que l'application a bien démarré sans crasher
    expect(find.byType(FenalApp), findsOneWidget);
  });
}
