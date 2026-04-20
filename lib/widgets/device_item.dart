import 'package:flutter/material.dart';
import 'package:my_project/models/device_model.dart';
import 'package:my_project/pages/create_device_page.dart';
import 'package:my_project/providers/speed_graph_provider.dart';
import 'package:my_project/widgets/graph_box.dart';
import 'package:my_project/widgets/parameter_field.dart';
import 'package:provider/provider.dart';

class DeviceItem extends StatefulWidget {
  final Device device;

  const DeviceItem({required this.device, super.key});

  @override
  State<DeviceItem> createState() => _DeviceItemState();
}

class _DeviceItemState extends State<DeviceItem> {
  void _navigateToDevice() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CreateDevicePage(
          isCreate: false,
          objectId: widget.device.objectId,
          deviceId: widget.device.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext cotext) {
    final int? power = context
        .watch<SpeedGraphProvider>()
        .getLastPoint(widget.device.id!)
        ?.value;

    return GestureDetector(
      onTap: _navigateToDevice,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromARGB(150, 0, 0, 0),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  widget.device.publicName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ParameterField(
                  parameter: 'power',
                  value: '$power'
                ),
                const SizedBox(height: 10),
                GraphBox(type: 'speed', id: widget.device.id!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
