import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/device/device_cubit.dart';
import 'package:my_project/cubit/device/device_state.dart';
// import 'package:my_project/cubit/device/device_state.dart';
import 'package:my_project/models/device_model.dart';
// import 'package:my_project/providers/device_provider.dart';
import 'package:my_project/widgets/device_fields.dart';
import 'package:my_project/widgets/form_layer.dart';

class CreateDevicePage extends StatefulWidget {
  final bool isCreate;
  final int objectId;
  final int? deviceId;

  const CreateDevicePage({
    required this.isCreate,
    required this.objectId,
    this.deviceId,
    super.key,
  });

  @override
  State<CreateDevicePage> createState() => _CreateDevicePageState();
}

class _CreateDevicePageState extends State<CreateDevicePage> {
  final TextEditingController _publicNameController = TextEditingController();
  final TextEditingController _privateNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _action() async {
    if (_formKey.currentState!.validate()) {
      final deviceProvider = context.read<DeviceCubit>();

      if (widget.isCreate) {
        final privateName = _privateNameController.text.trim();
        final bool objectExists = await deviceProvider.deviceExists(
          privateName,
        );

        if (!mounted) return;

        if (objectExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This private name is already used')),
          );
          return;
        }

        if (_passwordController.text.trim() !=
            _confirmPasswordController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')),
          );
          return;
        }

        await deviceProvider.createDevice(
          _publicNameController.text.trim(),
          _privateNameController.text.trim(),
          _passwordController.text.trim(),
          widget.objectId,
        );
      } else {
        final Device currentDevice = context.read<DeviceCubit>().state.device!;
        await deviceProvider.updateDevice(
          widget.deviceId as int,
          _publicNameController.text.trim(),
          currentDevice.privateName,
          currentDevice.password ?? '123456789',
          widget.objectId,
        );
      }

      if (!mounted) return;

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<DeviceCubit>(),
      child: BlocBuilder<DeviceCubit, DeviceState>(
        builder: (context, state) {
          if (!widget.isCreate &&
              state.device != null &&
              _publicNameController.text.isEmpty) {
            final device = state.device!;
            _publicNameController.text = device.publicName;
          }

          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          return FormLayer(
            title: widget.isCreate ? 'Create Device' : 'Edit Device',
            backAction: () => Navigator.pop(context),
            actions: widget.isCreate
                ? null
                : [
                    IconButton(
                      onPressed: () {
                        context.read<DeviceCubit>().deleteDevice(
                          widget.deviceId!,
                          widget.objectId,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Device deleted')),
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
            fields: DeviceFields(
              formKey: _formKey,
              publicNameController: _publicNameController,
              privateNameController: widget.isCreate
                  ? _privateNameController
                  : null,
              passwordController: widget.isCreate ? _passwordController : null,
              confirmPasswordController: widget.isCreate
                  ? _confirmPasswordController
                  : null,
            ),
            textButton: widget.isCreate ? 'Create' : 'Update',
            pressAction: _action,
          );
        },
      ),
    );
  }
}
