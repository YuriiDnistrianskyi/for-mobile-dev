import 'package:flutter/material.dart';
import 'package:my_project/widgets/custom_navigation_bar.dart';
import 'package:my_project/widgets/object_item.dart';

class ObjectData {
  int id = 0;
}

final List<Map<String, dynamic>> _objects = [
  {
    'id': 1
  },
  {
    'id': 2
  },
  {
    'id': 3
  }
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _addObject() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
            )
          )
        )
      ),
      body: Column(
        children: [
          Center(
            child:
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: const Center(
                        child: Text(
                        'Your objects',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          )
                        )
                      )
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: _addObject,
                      child: 
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: const BoxDecoration(
                          color: Color(0xFF033E27),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: const Center(
                          child: Icon(Icons.add_sharp, color: Colors.white)
                        )
                      )
                    )
                  ]
                )
              )
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Expanded(
              child: GridView.builder(
                itemCount: _objects.length,
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return ObjectItem(object: _objects[index]);
                }
              )
            )
          )
        ]
      ),
      bottomNavigationBar: const CustomNavigationBar(currentPage: 'home')
    );
  }
}
