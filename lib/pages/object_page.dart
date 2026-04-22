import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/object/object_cubit.dart';
import 'package:my_project/cubit/object/object_state.dart';
import 'package:my_project/models/device_model.dart';
import 'package:my_project/models/object_model.dart';
import 'package:my_project/pages/create_device_page.dart';
import 'package:my_project/pages/create_object_page.dart';
import 'package:my_project/providers/device_provider.dart';
import 'package:my_project/providers/temperature_graph_provider.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/device_item.dart';
import 'package:my_project/widgets/graph_box.dart';
import 'package:my_project/widgets/parameter_field.dart';
import 'package:my_project/widgets/title_page_text.dart';
import 'package:my_project/widgets/wifi_status.dart';

class ObjectPage extends StatefulWidget {
  final int objectId;

  const ObjectPage({required this.objectId, super.key});

  @override
  State<ObjectPage> createState() => _ObjectPageState();
}

class _ObjectPageState extends State<ObjectPage> {
  late Future<void> awaitProviders;

  @override
  void initState() {
    super.initState();
    awaitProviders = _awaitProviders();
  }

  Future<void> _awaitProviders() async {
    await context.read<ObjectCubit>().getObject(widget.objectId);
    if (!mounted) return;
    await context.read<DeviceProvider>().getDevices(widget.objectId);
  }

  void _navigateToCreateDevice() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            CreateDevicePage(isCreate: true, objectId: widget.objectId),
      ),
    );

    context.read<DeviceProvider>().getDevices(widget.objectId);
  }

  void _navigateToUpdateObject() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            CreateObjectPage(isCreate: false, id: widget.objectId),
      ),
    );
    context.read<ObjectCubit>().getObject(widget.objectId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ObjectCubit>(),
      child: BlocBuilder<ObjectCubit, ObjectState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green)
            );
          }

          if (state.error != null) {
            return Center(
              child: Text('Error: ${state.error}')
            );
          }

          final MyObject object = context.watch<ObjectCubit>().state.object!;
          final List<Device> devices = context.watch<DeviceProvider>().devices;
          final double currentTemperature = context
              .watch<TemperatureGraphProvider>()
              .getLastPoint(widget.objectId)!
              .value;

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: TitlePageText(text: object.publicName),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              actions: [
                IconButton(
                  onPressed: _navigateToUpdateObject,
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Column(
                    children: [
                      ParameterField(
                        parameter: 'temperature',
                        value: '$currentTemperature',
                      ),
                      const WiFiStatus(),
                      GraphBox(type: 'temperature', id: widget.objectId),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              const SizedBox(height: 20),
                              DeviceItem(device: devices[index]),
                            ],
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
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      )
    );
  }
}
