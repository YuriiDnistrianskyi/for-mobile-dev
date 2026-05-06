import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/object/object_cubit.dart';
import 'package:my_project/cubit/tempeture_graph/temperature_graph_cubit.dart';
import 'package:my_project/cubit/tempeture_graph/temperature_graph_state.dart';
import 'package:my_project/models/object_model.dart';
import 'package:my_project/pages/object_page.dart';

class ObjectItem extends StatelessWidget {
  const ObjectItem({required this.object, super.key});

  final MyObject object;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<TemperatureGraphCubit>(),
      child: GestureDetector(
        onTap: () {
          context.read<ObjectCubit>().getObject(object.id!);
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => ObjectPage(objectId: object.id!),
            ),
          );
        },
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [
              Text(
                object.publicName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(9),
                  child: Row(
                    children: [
                      const Icon(Icons.devices_rounded),
                      Expanded(
                        child: FractionallySizedBox(
                          widthFactor: 0.7,
                          heightFactor: 0.9,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(96, 82, 95, 87),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child:
                                BlocBuilder<
                                  TemperatureGraphCubit,
                                  TemperatureGraphState
                                >(
                                  builder: (context, state) {
                                    if (state.lastPoints[object.id!] == null) {
                                      context
                                          .read<TemperatureGraphCubit>()
                                          .getLastTemperatureGraphPoint(
                                            object.id!,
                                          );
                                      context
                                          .read<TemperatureGraphCubit>()
                                          .getTemperatureGraph(object.id!);
                                    }
                                    final temperature =
                                        state.lastPoints[object.id!];
                                    return Center(
                                      child: Text('${temperature?.value}℃'),
                                    );
                                  },
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
