import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

import '../../core/theme/app_colors.dart';

import '../../core/utils/snackbar_utils.dart';

class EditNoteScreen extends StatefulWidget {
  final String docId;
  final String currentTitle;
  final String currentContent;
  final int currentColor;

  const EditNoteScreen({
    super.key,
    required this.docId,
    required this.currentTitle,
    required this.currentContent,
    this.currentColor = 0xFFFFFFFF,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  final FirestoreService firestore = FirestoreService();

  late int selectedColor;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.currentTitle);
    contentController = TextEditingController(text: widget.currentContent);
    selectedColor = widget.currentColor;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(selectedColor),
      appBar: AppBar(
        backgroundColor: Color(selectedColor),
        elevation: 0,
        title: const Text("Edit Note"),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await firestore.updateNote(
                  docId: widget.docId,
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
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
                        hintText: "Content",
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
