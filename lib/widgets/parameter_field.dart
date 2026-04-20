import 'package:flutter/material.dart';

class ParameterField extends StatelessWidget {
  const ParameterField({
    required this.parameter,
    required this.value,
    super.key
  });

  final String parameter;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              'Current $parameter: ',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '$value ${parameter == 'temperature' ? '℃' : '%'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Icon(parameter == 'temperature' ? Icons.thermostat : Icons.speed),
          ],
        ),
      ),
    );
  }
}
