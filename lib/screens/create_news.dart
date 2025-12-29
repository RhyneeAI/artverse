import 'dart:io';
import 'package:artverse/controllers/auth_controller.dart';
import 'package:artverse/controllers/category_controller.dart';
import 'package:artverse/controllers/news_controller.dart';
import 'package:artverse/navigation/main_navigation.dart';
import 'package:artverse/utils/snackbar.dart';
import 'package:artverse/v1/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:artverse/widgets/auth_widget.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class CreateNewsScreen extends StatefulWidget {
  const CreateNewsScreen({super.key});

  @override
  _CreateNewsScreenState createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final quill.QuillController _descriptionController = quill.QuillController.basic();
  File? _newsImage;
  SelectOption? _categoryId;

  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  final AuthController _authController = AuthController();
  final NewsController _newsController = NewsController();
  final CategoryController _categoryController = CategoryController();
  List<SelectOption> supabaseOptions = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _createNews() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.document.toPlainText().isEmpty ||
        _newsImage == null ||
        _categoryId == null) {
      SnackbarUtils.showError(context, 'Harap lengkapi semua field');
      return;
    }

    final user = await _authController.getCurrentUser();
    if (user == null) {
      SnackbarUtils.showError(context, 'User tidak ditemukan');
      return;
    }

    setState(() => _newsController.isLoading = true);

    try {
      final imageData = await _newsController.uploadNewsImage(_newsImage!);
      if (imageData == null) throw Exception('Gagal upload gambar');

      await _newsController.createNews(
        title: _titleController.text.trim(),
        description: _descriptionController.document.toPlainText(),
        newsImageUrl: imageData['url']!,
        imageName: imageData['fileName']!,
        source: _sourceController.text.trim(),
        categoryId: _categoryId!.id,
        authorId: user.id!,
      );

      SnackbarUtils.showSuccess(context, 'News successfully published');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigation()),
      );
    } catch (e) {
      SnackbarUtils.showError(context, 'Gagal: $e');
    } finally {
      setState(() => _newsController.isLoading = false);
    }
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _newsImage = File(picked.path);
      });
    } 
  }

  void _loadCategories() async {
    final categories = await _categoryController.getCategories();

    if(categories.isEmpty) {
      SnackbarUtils.showError(context, 'Failed to fetch categories data');
    }
    
    setState(() {
      supabaseOptions = categories.map((category) {
        return SelectOption(
          id: category.id!,
          label: category.name!,
          value: category, 
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 27),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Create News',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  AuthLabel(
                    text: 'Cover Image'
                  ),

                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickCoverImage,
                    child: Container(
                      height: 175,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: _newsImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(_newsImage!, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add, size: 50, color: Colors.grey),
                                SizedBox(height: 8),
                                Text('Add Cover Image', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Title
                  AuthLabel(
                    text: 'Title'
                  ),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _titleController,
                    hint: 'News Title',
                  ),

                  const SizedBox(height: 24),

                  // Source
                  AuthLabel(
                    text: 'Source'
                  ),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _sourceController,
                    hint: 'Source',
                  ),

                  const SizedBox(height: 24),

                  AuthLabel(
                    text: 'Category'
                  ),
                  const SizedBox(height: 8),
                  AuthSelectOption(
                    options: supabaseOptions,
                    hint: 'Category',
                    onChanged: (selected) {
                      setState(() {
                        _categoryId = selected;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  AuthLabel(
                    text: 'Description'
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: quill.QuillEditor(
                      controller: _descriptionController,
                      focusNode: _focusNode,
                      scrollController: _scrollController,
                      config: quill.QuillEditorConfig(
                        padding: const EdgeInsets.all(16),
                        autoFocus: false,
                        expands: false,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _authController.isLoading ? null : _createNews,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _newsController.isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Publish',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),

                  const SizedBox(height: 45),
                ],
              ),
            ),
          ),
        ),
      );
  }
}