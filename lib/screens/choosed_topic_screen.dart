import 'package:flutter/material.dart';

class ChooseTopicsScreen extends StatefulWidget {
  const ChooseTopicsScreen({super.key});

  @override
  State<ChooseTopicsScreen> createState() => _ChooseTopicsScreenState();
}

class _ChooseTopicsScreenState extends State<ChooseTopicsScreen> {
  final List<String> topics = [
    'National',
    'International',
    'digital',
    'ar',
    'canvas',
    'abstark',
    'Fashion',
    'Technology',
    'Science',
    'Art',
    'painting',
  ];

  final Set<String> selectedTopics = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Choose your Topics'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔍 Search kecil
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🏷️ Chips
            Expanded(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: topics.map((topic) {
                  final isSelected = selectedTopics.contains(topic);

                  return ChoiceChip(
                    label: Text(topic),
                    selected: isSelected,
                    onSelected: (value) {
                      setState(() {
                        value
                            ? selectedTopics.add(topic)
                            : selectedTopics.remove(topic);
                      });
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // 🔵 Button Next
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).primaryColor,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, selectedTopics);
                  },
                  child: const Text(
                    'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
