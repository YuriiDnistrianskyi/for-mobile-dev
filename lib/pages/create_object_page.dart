import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/object/object_cubit.dart';
import 'package:my_project/cubit/object/object_state.dart';
import 'package:my_project/models/object_model.dart';
import 'package:my_project/widgets/form_layer.dart';
import 'package:my_project/widgets/object_fields.dart';

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

  void _action() async {
    final cubit = context.read<ObjectCubit>();
    final authProvider = context.read<AuthCubit>();

    if (_formKey.currentState!.validate()) {
      if (widget.isCreate) {
        final privateName = _privateNameController.text.trim();
        final bool objectExists = await cubit.objectExists(privateName);

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
        await cubit.createObject(
          _publicNameController.text,
          _privateNameController.text,
          _passwordController.text,
          authProvider.state.userId!,
          double.parse(_maxTemperatureComtroller.text.trim()),
          int.parse(_defaulSpeedController.text),
        );
      } else {
        final MyObject currentObject = cubit.state.object!;
        await cubit.updateObject(
          widget.id as int,
          _publicNameController.text.trim(),
          currentObject.privateName,
          currentObject.password ?? '123456789',
          authProvider.state.userId!,
          double.parse(_maxTemperatureComtroller.text.trim()),
          int.parse(_defaulSpeedController.text.trim()),
        );

        if (!mounted) return;

        cubit.getObject(widget.id!);
      }

      if (!mounted) return;

      Navigator.pop(context);
    }
  }

  void _deleteObject() async {
    final cubit = context.read<ObjectCubit>();
    await cubit.deleteObject(
      widget.id!, 
      context.read<AuthCubit>().state.userId!
    );
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Object deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ObjectCubit>(),
      child: BlocListener<ObjectCubit, ObjectState>(
        listener: (context, state) {
          if (!widget.isCreate) {
            final MyObject object = state.object!;

            _publicNameController.text = object.publicName;
            _privateNameController.text = object.privateName;
            _maxTemperatureComtroller.text = object.maxTemperature.toString();
            _defaulSpeedController.text = object.defaultSpeedForDevices
                .toString();
          }
        },
        child: FormLayer(
      title: widget.isCreate ? 'Create Object' : 'Edit Object',
      backAction: () => Navigator.pop(context),
      actions: widget.isCreate
          ? null
          : [
              IconButton(
                onPressed: _deleteObject,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
      fields: ObjectFields(
        formKey: _formKey,
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
    )
      ),
    );
  }
}
