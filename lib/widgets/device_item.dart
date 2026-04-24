import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/device/device_cubit.dart';
import 'package:my_project/cubit/device/device_state.dart';
import 'package:my_project/models/device_model.dart';
import 'package:my_project/pages/create_device_page.dart';
import 'package:my_project/providers/speed_graph_provider.dart';
import 'package:my_project/widgets/graph_box.dart';
import 'package:my_project/widgets/parameter_field.dart';

class DeviceItem extends StatelessWidget {
  final Device device;

  const DeviceItem({required this.device, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<DeviceCubit>(), // PowerGraphCubit
      child: BlocBuilder<DeviceCubit, DeviceState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          final int? power = context
              .watch<SpeedGraphProvider>()
              .getLastPoint(device.id!)
              ?.value;

          return GestureDetector(
            onTap: () async {
              await context.read<DeviceCubit>().getDevice(device.id!);
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => CreateDevicePage(
                      isCreate: false,
                      objectId: device.objectId,
                      deviceId: device.id,
                    ),
                  ),
                );
              }
            },
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
                        device.publicName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ParameterField(parameter: 'power', value: '$power'),
                      const SizedBox(height: 10),
                      GraphBox(type: 'speed', id: device.id!),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
