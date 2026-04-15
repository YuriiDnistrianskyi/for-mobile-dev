import 'package:flutter/material.dart';
import 'package:my_project/models/device_model.dart';
import 'package:my_project/providers/device_provider.dart';
import 'package:my_project/widgets/custom_field.dart';
import 'package:my_project/widgets/important_button.dart';
import 'package:my_project/widgets/password_field.dart';
import 'package:my_project/widgets/title_page_text.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();

    if (!widget.isCreate) {
      context.read<DeviceProvider>().getDevice(widget.deviceId!);
      final Device device = context.read<DeviceProvider>().device!;

      _publicNameController.text = device.publicName;
      _privateNameController.text = device.privateName;
      // _passwordController.text = device.password!;
    }
  }

  void _action() async {
    if (_formKey.currentState!.validate()) {
      final deviceProvider = context.read<DeviceProvider>();

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
        final Device currentDevice = context.read<DeviceProvider>().device!;
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: TitlePageText(
          text: '${widget.isCreate ? 'Create' : 'Etid'} device',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          if (!widget.isCreate)
            IconButton(
              onPressed: () {
                context.read<DeviceProvider>().deleteDevice(
                  widget.deviceId!, 
                  widget.objectId
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Device deleted')));
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomField(
                      text: 'Public Name',
                      icon: const Icon(Icons.devices_rounded),
                      controller: _publicNameController,
                      keyboardType: TextInputType.text,
                    ),
                    if (widget.isCreate)
                      CustomField(
                        text: 'Private Name',
                        icon: const Icon(Icons.shield),
                        controller: _privateNameController,
                        keyboardType: TextInputType.text,
                      ),
                    if (widget.isCreate) ...[
                      PasswordField(
                        text: 'Password',
                        icon: const Icon(Icons.lock),
                        controller: _passwordController,
                      ),
                      PasswordField(
                        text: 'Confirm Password',
                        icon: const Icon(Icons.lock_reset),
                        controller: _confirmPasswordController,
                      ),
                    ],
                    const SizedBox(height: 20),
                    ImportantButton(
                      text: '${widget.isCreate ? 'Create' : 'Etid'} device',
                      func: _action,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
