import 'package:flutter/material.dart';
import 'package:my_project/local/models/object_model.dart';
import 'package:my_project/pages/create_object_page.dart';
import 'package:my_project/providers/auth_provider.dart';
import 'package:my_project/providers/object_provider.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/custom_navigation_bar.dart';
import 'package:my_project/widgets/object_item.dart';
import 'package:my_project/widgets/title_page_text.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<MyObject> _objects = [MyObject(id: 1, publicName: 'publicName', privateName: 'privateName', password: 'password', userId: 1, maxTemperature: 12.0, defaultSpeedForDevices: 12)];
  
  Future<void> init() async {
    final userId = context.read<AuthProvider>().userId;
    final objectProvider = context.read<ObjectProvider>();

    // _objects = await objectProvider.getObjects(userId);
  }

  void _navigateToCreateObject() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const CreateObjectPage(
        type: 'Create'
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const TitlePageText(text: 'Home'),
      ),
      body: Column(
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
                      func: _navigateToCreateObject,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Expanded(
              child: GridView.builder(
                itemCount: _objects.length,
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.7,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return ObjectItem(object: _objects[index]);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavigationBar(currentPage: 'home'),
    );
  }
}
