import 'package:flutter/material.dart';
import 'package:my_project/models/object_model.dart';
import 'package:my_project/providers/auth_provider.dart';
import 'package:my_project/providers/object_provider.dart';
import 'package:my_project/widgets/form_layer.dart';
import 'package:my_project/widgets/object_fields.dart';
// import 'package:my_project/widgets/custom_field.dart';
// import 'package:my_project/widgets/important_button.dart';
// import 'package:my_project/widgets/password_field.dart';
// import 'package:my_project/widgets/title_page_text.dart';
import 'package:provider/provider.dart';

class CreateObjectPage extends StatefulWidget {
  final bool isCreate;
  final int? id;

  const CreateObjectPage({required this.isCreate, this.id, super.key});

  @override
  State<CreateObjectPage> createState() => _CreateObjectPageState();
}

class _CreateObjectPageState extends State<CreateObjectPage> {
  final TextEditingController _publicNameController = TextEditingController();
  final TextEditingController _privateNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _maxTemperatureComtroller =
      TextEditingController();
  final TextEditingController _defaulSpeedController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (!widget.isCreate) {
      context.read<ObjectProvider>().getObject(widget.id!);
      final MyObject object = context.read<ObjectProvider>().object!;

      _publicNameController.text = object.publicName;
      _privateNameController.text = object.privateName;
      _maxTemperatureComtroller.text = object.maxTemperature.toString();
      _defaulSpeedController.text = object.defaultSpeedForDevices.toString();
    }
  }

  void _action() async {
    final objectProvider = context.read<ObjectProvider>();
    final authProvider = context.read<AuthProvider>();

    if (_formKey.currentState!.validate()) {
      if (widget.isCreate) {
        final privateName = _privateNameController.text.trim();
        final bool objectExists = await objectProvider.objectExists(
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
        await objectProvider.createObject(
          _publicNameController.text,
          _privateNameController.text,
          _passwordController.text,
          authProvider.userId!,
          double.parse(_maxTemperatureComtroller.text.trim()),
          int.parse(_defaulSpeedController.text),
        );
      } else {
        final MyObject currentObject = context.read<ObjectProvider>().object!;
        await objectProvider.updateObject(
          widget.id as int,
          _publicNameController.text.trim(),
          currentObject.privateName,
          currentObject.password ?? '123456789',
          authProvider.userId!,
          double.parse(_maxTemperatureComtroller.text.trim()),
          int.parse(_defaulSpeedController.text.trim()),
        );
      }

      if (!mounted) return;

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormLayer(
      title: widget.isCreate ? 'Create Object' : 'Edit Object',
      backAction: () => Navigator.pop(context),
      fields: ObjectFields(
        publicNameController: _publicNameController,
        privateNameController: widget.isCreate ? _privateNameController : null,
        passwordController: widget.isCreate ? _passwordController : null,
        confirmPasswordController: widget.isCreate 
            ? _confirmPasswordController
            : null,
        maxTemperatureController: _maxTemperatureComtroller,
        defaultSpeedController: _defaulSpeedController,
      ),
      textButton: widget.isCreate ? 'Create' : 'Edit',
      pressAction: _action,
    );
  }
}
