import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/object/object_cubit.dart';
import 'package:my_project/cubit/object/object_state.dart';
import 'package:my_project/pages/create_object_page.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/custom_navigation_bar.dart';
import 'package:my_project/widgets/object_item.dart';
import 'package:my_project/widgets/title_page_text.dart';
import 'package:my_project/widgets/wifi_status.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthCubit>().state.userId!;
      context.read<ObjectCubit>().getObjects(userId);
    });

    return BlocProvider.value(
      value: context.read<ObjectCubit>(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const TitlePageText(text: 'Home'),
        ),
        body: BlocBuilder<ObjectCubit, ObjectState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }

            if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }

            final objects = state.objects;
            return Column(
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Center(
                            child: Text(
                              'Your Objects',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          child: CustomButton(
                            text: 'Add Object',
                            func: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) =>
                                      const CreateObjectPage(isCreate: true),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const WiFiStatus(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Expanded(
                    child: GridView.builder(
                      itemCount: objects.length,
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.7,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                      itemBuilder: (context, index) {
                        return ObjectItem(object: objects[index]);
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: const CustomNavigationBar(currentPage: 'home'),
      ),
    );
  }
}
