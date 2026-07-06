import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';
import '../../widgets/note_card.dart';
import '../notes/add_note_screen.dart';
import '../notes/edit_note_screen.dart';

import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/note.dart';

import '../../providers/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final FirestoreService firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NoteSearchDelegate(firestore: firestore),
              );
            },
          ),
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AppAuthProvider>().logout(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text("No notes yet. Tap + to add one!"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final note = NoteModel.fromDocument(docs[index]);

              return NoteCard(
                title: note.title,
                content: note.content,
                date: note.createdAt,
                color: note.color,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => EditNoteScreen(
                        docId: note.id,
                        currentTitle: note.title,
                        currentContent: note.content,
                        currentColor: note.color,
                      ),
                    ),
                  );
                },
                onDelete: () async {
                  bool confirmDelete =
                      await showDialog(
                        context: context,
                        builder:
                            (BuildContext context) => AlertDialog(
                          title: const Text("Delete Note"),
                          content: const Text(
                            "Are you sure you want to permanently delete this note?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                              ),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      ) ??
                          false;

                  if (confirmDelete) {
                    await firestore.deleteNote(note.id);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNoteScreen()),
          );
        },
      ),
    );
  }
}

class NoteSearchDelegate extends SearchDelegate {
  final FirestoreService firestore;

  NoteSearchDelegate({required this.firestore});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.getNotes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final notes = snapshot.data!.docs
            .map((doc) => NoteModel.fromDocument(doc))
            .where(
              (note) =>
          note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()),
        )
            .toList();

        if (notes.isEmpty) return const Center(child: Text("No matches found"));

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return NoteCard(
              title: note.title,
              content: note.content,
              date: note.createdAt,
              color: note.color,
              onTap: () {
                close(context, null);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => EditNoteScreen(
                      docId: note.id,
                      currentTitle: note.title,
                      currentContent: note.content,
                      currentColor: note.color,
                    ),
                  ),
                );
              },
              onDelete: () async {
                await firestore.deleteNote(note.id);
                close(context, null);
              },
            );
          },
        );
      },
    );
  }
}