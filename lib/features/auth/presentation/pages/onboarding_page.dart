import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup BudgetBuddy')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          } else {
            context.go('/');
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        steps: const [
          Step(
            title: Text('Budgeting Style'),
            content: Text('Select Category Budgeting, 50/30/20, or Zero-Based.'),
          ),
          Step(
            title: Text('Income Setup'),
            content: TextField(decoration: InputDecoration(labelText: 'Monthly Income', prefixText: '₱')),
          ),
          Step(
            title: Text('Wallet Creation'),
            content: Text('Set up Cash, GCash, Maya, Bank Account.'),
          ),
          Step(
            title: Text('Savings Goal'),
            content: Text('Create your first savings goal.'),
          ),
        ],
      ),
    );
  }
}
