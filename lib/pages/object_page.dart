import 'package:flutter/material.dart';
import 'package:my_project/pages/create_device_page.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/device_item.dart';
import 'package:my_project/widgets/graph_box.dart';
import 'package:my_project/widgets/title_page_text.dart';

class ObjectPage extends StatefulWidget {
  const ObjectPage({super.key});

  @override
  State<ObjectPage> createState() => _ObjectPageState();
}

class _ObjectPageState extends State<ObjectPage> {
  final String objectName = 'Object 1';
  final double currentTemperature = 45.65;
  final List<int> deviceList = [1, 2, 3];

  void _navigateToCreateDevice() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const CreateDevicePage()),
    );
  }

  void _navigateToGraph() {
    //
  }

  void _navigateToDdevice() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: TitlePageText(text: objectName),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: CustomButton(
                    text: 'Add device',
                    func: _navigateToCreateDevice,
                  ),
                ),
                const SizedBox(height: 20),
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
                GraphBox(text: 'Temparature graph', func: _navigateToGraph),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: deviceList.length,
                  itemBuilder: (context, index) {
                    return const Column(
                      children: [SizedBox(height: 20), DeviceItem()],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
