import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class EvaluateRobot {
  final WidgetTester tester;

  const EvaluateRobot(this.tester);
  final emailValueKey = const ValueKey("email_field");
  final passwordValueKey = const ValueKey("password_field");
  final loginValueKey = const ValueKey("login_button");

  Future<void> verifyLoginPage() async {
    // Wait for the login page to appear
    await tester.pumpAndSettle();
    
    // Check for the login page elements based value key
    expect(find.byKey(emailValueKey), findsOneWidget, reason: 'Expected to find email field');
    expect(find.byKey(passwordValueKey), findsOneWidget, reason: 'Expected to find password field');
    expect(find.byKey(loginValueKey), findsOneWidget, reason: 'Expected to find login button');
  }

  Future<void> enterEmail(String email) async {
    final emailField = find.byKey(emailValueKey);
    await tester.tap(emailField);
    await tester.enterText(emailField, email);
    await tester.testTextInput.receiveAction(TextInputAction.done);
  }

  Future<void> enterPassword(String password) async {
    final passwordField = find.byKey(passwordValueKey);
    await tester.tap(passwordField);
    await tester.enterText(passwordField, password);
    await tester.testTextInput.receiveAction(TextInputAction.done);
  }

  Future<void> tapLoginButton() async {
    final actionButtonFinder = find.byKey(loginValueKey);
    await tester.tap(actionButtonFinder);
    await tester.pump();
  }

  Future<void> verifyOnHomePage() async {
    // Check for structure elements that should be on the HomePage
    expect(find.byType(AppBar), findsOneWidget);
    // Check for text that would only be on the HomePage
    expect(find.text('Stories'), findsOneWidget, reason: 'Expected to find "Stories" text in HomePage AppBar');
    expect(find.byType(ListView), findsOneWidget, reason: 'Expected to find a ListView on HomePage');
  }
}