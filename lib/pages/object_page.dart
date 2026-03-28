import 'package:flutter/material.dart';
import 'package:my_project/local/models/object_model.dart';
import 'package:my_project/pages/create_device_page.dart';
import 'package:my_project/pages/create_object_page.dart';
import 'package:my_project/providers/device_provider.dart';
import 'package:my_project/providers/object_provider.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/device_item.dart';
import 'package:my_project/widgets/graph_box.dart';
import 'package:my_project/widgets/title_page_text.dart';
import 'package:provider/provider.dart';


class ObjectPage extends StatefulWidget {
  final MyObject object;

  const ObjectPage({required this.object, super.key});

  @override
  State<ObjectPage> createState() => _ObjectPageState();
}

class _ObjectPageState extends State<ObjectPage> {
  final double currentTemperature = 45.65;

  @override
  void initState() {
    super.initState();
    context.read<DeviceProvider>().getDevices(widget.object.id!);
  }

  void _navigateToCreateDevice() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => CreateDevicePage(
        objectId: widget.object.id!)
      ),
    );
  }

  void _navigateToUpdateObject() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CreateObjectPage(
          isCreate: false, 
          id: widget.object.id
        )
      )
    );
  }

  void _deleteObject() async {
    final objectProvider = context.read<ObjectProvider>();
    await objectProvider.deleteObject(widget.object.id!);
  }

  void _navigateToDdevice() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: TitlePageText(text: widget.object.publicName),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _deleteObject,
            icon: const Icon(Icons.edit, color: Colors.white)
          ),
          IconButton(
            onPressed: _navigateToUpdateObject,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ]
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Text(
                          'Current Temperature: ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '$currentTemperature ℃',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.thermostat),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const GraphBox(text: 'Temparature graph'),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: CustomButton(
                    text: 'Edit object',
                    func: _navigateToUpdateObject,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: context.read<DeviceProvider>().devices.length,
                  itemBuilder: (context, index) {
                    return const Column(
                      children: [SizedBox(height: 20), DeviceItem()],
                    );
                  },
                ),
                SizedBox(
                  height: 50,
                  child: CustomButton(
                    text: 'Add device',
                    func: _navigateToCreateDevice,
                  ),
                ),
                const SizedBox(height: 70)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
