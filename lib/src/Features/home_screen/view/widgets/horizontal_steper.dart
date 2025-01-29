import 'package:flutter/material.dart';
import 'package:signature_system/src/core/style/colors.dart';

class custom_horizontal_stepper extends StatelessWidget {
  const custom_horizontal_stepper({
    super.key,
    required List<String> stepNames,
    required int currentStep,
  }) : _stepNames = stepNames, _currentStep = currentStep;

  final List<String> _stepNames;
  final int _currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  List.generate(_stepNames.length,(index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentStep >= index ? AppColors.mainColor : Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _currentStep > index
                      ? const Icon(Icons.check, color: Colors.white)
                      : Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Step label
              Text(_stepNames[index]),
              const SizedBox(width: 8),
              // Horizontal line between steps if not the last step
              if (index < 2)
                Container(
                  height: 2,
                  width: 50,
                  color: _currentStep > index ? AppColors.mainColor : Colors.grey,
                ),

            ],
          ),
        );
      }),
    );
  }
}