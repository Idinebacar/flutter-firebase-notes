import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

import '../../core/theme/app_colors.dart';

import '../../core/utils/snackbar_utils.dart';
import '../../core/utils/validators.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final FirestoreService firestore = FirestoreService();

  int selectedColor = 0xFFFFFFFF;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(selectedColor),
      appBar: AppBar(
        backgroundColor: Color(selectedColor),
        elevation: 0,
        title: const Text("New Note"),
        actions: [
          IconButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final content = contentController.text.trim();

              final titleError = Validators.validateTitle(title);
              if (titleError != null && content.isEmpty) {
                SnackbarUtils.showSnackBar(
                  context,
                  "Note must have a title or content",
                  isError: true,
                );
                return;
              }

              try {
                await firestore.addNote(
                  title: title,
                  content: content,
                  color: selectedColor,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  SnackbarUtils.showSnackBar(context, e.toString(), isError: true);
                }
              }
            },
            icon: const Icon(Icons.check),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Title",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: TextField(
                      controller: contentController,
                      maxLines: null,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: "Write your note here...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black38),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AppColors.noteColors.length,
              itemBuilder: (context, index) {
                final colorVal = AppColors.noteColors[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = colorVal;
                    });
                  },
                  child: Container(
                    width: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Color(colorVal),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColor == colorVal
                            ? Colors.blue
                            : Colors.black12,
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
