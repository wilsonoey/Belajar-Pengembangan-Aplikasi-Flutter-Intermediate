// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyapp/main.dart';
import '../integration_testing/EvaluateRobot.dart';

void main() {
  const email = "tester050625@gmail.com";
  const password = "tester050625";
  setUp(() async {
    // Clear shared preferences before test to ensure no existing login tokens
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets('Login', (WidgetTester tester) async {
    // Increase the timeout to allow API calls to complete
    await tester.runAsync(() async {
      // Load the app
      await tester.pumpWidget(const MyApp());
      await tester.pump();
      
      final loginRobot = EvaluateRobot(tester);
      
      // Verify initial login page
      await loginRobot.verifyLoginPage();
      
      // Perform login actions
      await loginRobot.enterEmail(email);
      await loginRobot.enterPassword(password);
      await loginRobot.tapLoginButton();
      
      // Verify navigation to home page
      await loginRobot.verifyOnHomePage();
    });
  });
}
