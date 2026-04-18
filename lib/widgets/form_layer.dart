import 'package:flutter/material.dart';
import 'package:my_project/widgets/important_button.dart';
import 'package:my_project/widgets/title_page_text.dart';


class FormLayer extends StatelessWidget {
  final String title;
  final void Function() backAction;
  final Widget fields;
  final String textButton;
  final void Function() pressAction;

  const FormLayer({
    required this.title,
    required this.backAction,
    required this.fields,
    required this.textButton,
    required this.pressAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: backAction,
        ),
        title: TitlePageText(text: title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsetsGeometry.all(15),
              child: Column(
                  children: [
                    fields,
                    const SizedBox(height: 20),
                    ImportantButton(
                      text: textButton,
                      func: pressAction,
                    ),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }
}
