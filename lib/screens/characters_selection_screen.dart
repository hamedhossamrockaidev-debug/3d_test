// lib/screens/character_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import '../models/character.dart';

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  State<CharacterSelectionScreen> createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Controller list is still needed to reference the *current* model controller
  // so we can issue commands outside of the onModelCreated callback.
  // We initialize them, but disposal is not explicitly called on the controller object itself.
  // final List<Flutter3DController> _modelControllers =
  //     Character.dummyCharacters.map((_) => Flutter3DController()).toList();
  void _goToNextCharacter() {
    // 💡 Senior Expert Tip: Use modulo arithmetic to wrap around the list.
    final int total = Character.dummyCharacters.length;
    final int nextPage = (_currentPage + 1) % total;

    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    // Note: The _pageController listener will automatically update _currentPage state.
  }

  void _goToPreviousCharacter() {
    final int total = Character.dummyCharacters.length;
    // Dart's modulo (%) handles negative results correctly for wrapping backwards.
    final int prevPage = (_currentPage - 1 + total) % total;

    _pageController.animateToPage(
      prevPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
          // You could run a specific command here, e.g., stop the rotation on the old page
          // and start a quick animation on the new page.
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // ✅ FIX 1: Removed explicit `controller.dispose()` calls, as the
    // Flutter3DController API doesn't expose a public one and handles cleanup internally.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... (build method remains the same)
    final Character currentCharacter = Character.dummyCharacters[_currentPage];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Select (3D Module)'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
              controller: _pageController,
              itemCount: Character.dummyCharacters.length,
              itemBuilder: (context, index) {
                final character = Character.dummyCharacters[index];
                return _Character3DView(
                  character: character,
                  // Pass the specific pre-initialized controller
                  // controller: _modelControllers[index],
                  isCurrentPage: index == _currentPage,
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: _CharacterInfoPanel(
              character: currentCharacter,
              onSelect: (char) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '**${char.name}** Selected! Starting Game...',
                    ),
                  ),
                );
              },
              onNext: _goToNextCharacter,
              onPrevious: _goToPreviousCharacter,
            ),
          ),
        ],
      ),
    );
  }
}

// ... (Next, we define the _Character3DView and _CharacterInfoPanel widgets)

// Continuation of lib/screens/character_selection_screen.dart

// Continuation of lib/screens/character_selection_screen.dart

class _Character3DView extends StatefulWidget {
  final Character character;
  // final Flutter3DController controller;
  final bool isCurrentPage;

  const _Character3DView({
    required this.character,
    // required this.controller,
    required this.isCurrentPage,
  });

  @override
  State<_Character3DView> createState() => _Character3DViewState();
}

class _Character3DViewState extends State<_Character3DView> {
  late Flutter3DController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = Flutter3DController();
  }

  @override
  void dispose() {
    // ❗ ما فيش dispose() رسمي في Flutter3DController،
    // لكن لازم نحط هنا أي تنظيف مستقبلي لو أضافوه بالإصدارات الجديدة.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 💡 Senior Expert Note: Changing the background color based on the current
    // page is a clever way to provide visual feedback in a PageView.
    return Container(
      color:
          widget.isCurrentPage
              ? Colors.black.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Flutter3DViewer(
          // 1. Core Model Source
          src: widget.character.glbAssetPath,

          // 2. Controller Hook
          // This links the specific 3D model instance to the controller object
          // stored in the parent State.
          // controller: _controller,
          // controller: _controller,
          controller: _controller,

          // 3. Enable User Interaction (The API for camera control)
          // `enableTouch: true` ensures the user can zoom, rotate, and pan.
          enableTouch: true,

          // 4. Loading Callback (FIXED API)
          // `onLoad` fires when the model is parsed and ready to display.
          onLoad: (String modelName) {
            // Programmatic action: Start a subtle rotation after loading.
            // This replaces the non-existent 'onModelLoaded' or 'onViewerCreated'.
            _controller.startRotation(rotationSpeed: 5);
          },

          // You can also add a progress bar for large models
          progressBarColor: Colors.red,
        ),
      ),
    );
  }
}
// Continuation of lib/screens/character_selection_screen.dart

class _CharacterInfoPanel extends StatelessWidget {
  final Character character;
  final Function(Character) onSelect;
  final VoidCallback onNext; // New
  final VoidCallback onPrevious; // New
  const _CharacterInfoPanel({
    required this.character,
    required this.onSelect,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Character Name
          Text(
            character.name,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Character Power
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.flash_on, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'Power: ${character.power}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Character Description
          Expanded(
            child: Text(
              character.description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 20),
          // 🎯 NEW: Navigation and Selection Controls Row
          Row(
            children: [
              // ◀️ Previous Button
              Expanded(
                child: ElevatedButton(
                  onPressed: onPrevious,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blueGrey.shade700,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.arrow_back_ios),
                ),
              ),

              const SizedBox(width: 10),

              // 🎮 Select Button (Main Action)
              Expanded(
                flex: 3, // Make the SELECT button wider
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.gamepad),
                  label: const Text('SELECT', style: TextStyle(fontSize: 18)),
                  onPressed: () => onSelect(character),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // ▶️ Next Button
              Expanded(
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blueGrey.shade700,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ],
          ),

          // // Selection Button (Game Simulation)
          // ElevatedButton.icon(
          //   icon: const Icon(Icons.gamepad),
          //   label: const Text(
          //     'SELECT CHARACTER',
          //     style: TextStyle(fontSize: 18),
          //   ),
          //   onPressed: () => onSelect(character),
          //   style: ElevatedButton.styleFrom(
          //     padding: const EdgeInsets.symmetric(vertical: 15),
          //     backgroundColor: Colors.green,
          //     foregroundColor: Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }
}
