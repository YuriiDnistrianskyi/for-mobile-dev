import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_project/providers/speed_graph_provider.dart';
import 'package:my_project/providers/temperature_graph_provider.dart';
import 'package:provider/provider.dart';

class GraphBox extends StatefulWidget {
  const GraphBox({required this.type, required this.id, super.key});

  final String type;
  final int id;

  @override
  State<GraphBox> createState() => _GraphBoxState();
}

class _GraphBoxState extends State<GraphBox> {
  List<FlSpot> _buildSpots(List<dynamic> data) {
    final List<FlSpot> spots = [];

    for (int i = 0; i < data.length; i++) {
      final value = data[i].value as num;
      spots.add(FlSpot(i.toDouble(), value.toDouble()));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = [];

    if (widget.type == 'speed') {
      data = context.watch<SpeedGraphProvider>().getGraph(widget.id);
    } else {
      data = context.watch<TemperatureGraphProvider>().getGraph(widget.id);
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              widget.type == 'speed' ? 'Speed graph' : 'Temperature graph',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
    );
  }
}
