import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Поки нехай так, щоб просто якийсь графік був, потім це перенеситься
class GraphPoint {
  final DateTime time;
  final double value;

  GraphPoint({required this.time, required this.value});
}

final List<GraphPoint> data = [
  GraphPoint(time: DateTime.parse('2026-03-11T10:00:00'), value: 20.1),
  GraphPoint(time: DateTime.parse('2026-03-11T10:01:00'), value: 24.1),
  GraphPoint(time: DateTime.parse('2026-03-11T10:02:00'), value: 26.3),
  GraphPoint(time: DateTime.parse('2026-03-11T10:03:00'), value: 30.4),
  GraphPoint(time: DateTime.parse('2026-03-11T10:04:00'), value: 34.5),
  GraphPoint(time: DateTime.parse('2026-03-11T10:05:00'), value: 57.2),
  GraphPoint(time: DateTime.parse('2026-03-11T10:06:00'), value: 38.2),
];
//

class GraphBox extends StatefulWidget {
  const GraphBox({required this.text, super.key});

  final String text;

  @override
  State<GraphBox> createState() => _GraphBoxState();
}

class _GraphBoxState extends State<GraphBox> {
  List<FlSpot> _buildSpots(List<GraphPoint> data) {
    final List<FlSpot> spots = [];

    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].value));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: false),

                      lineBarsData: [
                        LineChartBarData(
                          color: Colors.black,
                          spots: _buildSpots(data),
                          isCurved: true,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
