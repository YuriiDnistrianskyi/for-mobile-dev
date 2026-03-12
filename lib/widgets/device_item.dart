import 'package:flutter/material.dart';
import 'package:my_project/widgets/graph_box.dart';

class DeviceItem extends StatefulWidget {
  const DeviceItem({super.key});

  @override
  State<DeviceItem> createState() => _DeviceItemState();
}

class _DeviceItemState extends State<DeviceItem> {
  final String deviceName = 'Device 1';
  final String power = '76';

  void _navigateToDevice() {

  }

  @override
  Widget build(BuildContext cotext) {
    return GestureDetector(
      onTap: _navigateToDevice,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromARGB(96, 82, 95, 87),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  deviceName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Text(
                          'Current power:',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '$power %',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold
                              )
                            )
                          )
                        ),
                        const Icon(Icons.speed)
                      ],
                    )
                  )
                ),
                const SizedBox(height: 10),
                GraphBox(text: 'Speed graph', func: () {}) 
              ]
            )
          )
        )
      )
    );
  }
}
