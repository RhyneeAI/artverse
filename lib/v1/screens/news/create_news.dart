import 'dart:io';
import 'package:artverse/v1/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class CreateNewsScreen extends StatefulWidget {
  const CreateNewsScreen({super.key});

  @override
  _CreateNewsScreenState createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final _titleController = TextEditingController();
  final quill.QuillController _quillController = quill.QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  File? _coverImage;
  bool _isUploading = false;

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _coverImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadCoverImage(File image) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      // Pastikan path valid dan tidak mengandung karakter aneh
      final fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('news_cover')
            .child(fileName);

        await ref.putFile(
            image,
            SettableMetadata(contentType: 'image/jpeg') 
        );
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      // print('Firebase Storage Error [${e.code}]: ${e.message}');
      SnackbarHelper.showError(context, 'Gagal upload gambar : ${e.code}');
      return null;
    } catch (e) {
      // print('Unknown Error during upload: $e');
      SnackbarHelper.showError(context, 'Terjadi kesalahan tidak terduga.');
      return null;
    }
  }

  Future<void> _publishArticle() async {
    if (_titleController.text.isEmpty || _quillController.document.isEmpty()) {
      SnackbarHelper.showError(context, 'Title & content wajib diisi');

      return;
    }

    setState(() => _isUploading = true);

    String? coverUrl;
    if (_coverImage != null) {
      coverUrl = await _uploadCoverImage(_coverImage!);
    }

    final user = FirebaseAuth.instance.currentUser!;
    final delta = _quillController.document.toDelta().toJson();

    await FirebaseFirestore.instance.collection('news').add({
      'title': _titleController.text.trim(),
      'content': delta,
      'coverImageUrl': coverUrl ?? '',
      'authorId': user.uid,
      'authorName': user.displayName ?? 'Anonymous',
      'timestamp': FieldValue.serverTimestamp(),
      'category': 'Design',
    });

    setState(() => _isUploading = false);
    Navigator.pop(context);
    SnackbarHelper.showSuccess(context, 'Artikel berhasil dipublish');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create News'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Photo
            GestureDetector(
              onTap: _pickCoverImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: _coverImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_coverImage!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Add Cover Photo', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'News title',
                border: UnderlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text('Add News/Article', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // Quill Toolbar
            quill.QuillSimpleToolbar(
              controller: _quillController,
              config: quill.QuillSimpleToolbarConfig(
                multiRowsDisplay: false, // satu baris toolbar
              ),
            ),

            const SizedBox(height: 8),

            // Quill Editor (pakai Expanded untuk fix render error)
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: quill.QuillEditor(
                  controller: _quillController,
                  focusNode: _focusNode,
                  scrollController: _scrollController,
                  config: quill.QuillEditorConfig(
                    padding: const EdgeInsets.all(16),
                    autoFocus: false,
                    expands: false,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _isUploading ? null : _publishArticle,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isUploading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Publish', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}