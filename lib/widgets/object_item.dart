import 'package:flutter/material.dart';
import 'package:my_project/local/models/object_model.dart';
import 'package:my_project/pages/object_page.dart';

class ObjectItem extends StatefulWidget {
  const ObjectItem({required this.object, super.key});

  final MyObject object;

  @override
  State<ObjectItem> createState() => _ObjectItemState();
}

class _ObjectItemState extends State<ObjectItem> {
  final String name = 'Object 1';
  final double temperature = 12.32;

  void _navigateToObjectPage() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ObjectPage(object: widget.object)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              style: const TextStyle(fontWeight: FontWeight.bold)
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
