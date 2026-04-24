import 'package:flutter/material.dart';
import 'package:my_project/cubit/object/object_cubit.dart';
import 'package:my_project/models/object_model.dart';
import 'package:my_project/pages/object_page.dart';
import 'package:my_project/providers/temperature_graph_provider.dart';
import 'package:provider/provider.dart';

class ObjectItem extends StatefulWidget {
  const ObjectItem({required this.object, super.key});

  final MyObject object;

  @override
  State<ObjectItem> createState() => _ObjectItemState();
}

class _ObjectItemState extends State<ObjectItem> {
  @override
  void initState() {
    super.initState();
    context.read<TemperatureGraphProvider>().getLastTemperatureGraphPoint(
      widget.object.id!,
    );
  }

  void _navigateToObjectPage() {
    context.read<ObjectCubit>().getObject(widget.object.id!);
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ObjectPage(objectId: widget.object.id!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double temperature = context
        .watch<TemperatureGraphProvider>()
        .getLastPoint(widget.object.id!)!
        .value;

    return GestureDetector(
      onTap: _navigateToObjectPage,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text(
              widget.object.publicName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(9),
                child: Row(
                  children: [
                    const Icon(Icons.devices_rounded),
                    Expanded(
                      child: FractionallySizedBox(
                        widthFactor: 0.7,
                        heightFactor: 0.9,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(96, 82, 95, 87),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(child: Text('$temperature℃')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
