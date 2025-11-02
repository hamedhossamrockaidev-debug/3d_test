// lib/models/character.dart

// 🚀 Senior Expert Tip: Using a simple Dart class (Model) is the foundation
// of clean architecture. It separates the raw data from the UI/logic.
class Character {
  final String name;
  final String description;
  final String power;
  // This is the path to the GLB file in your assets folder.
  final String glbAssetPath;

  Character({
    required this.name,
    required this.description,
    required this.power,
    required this.glbAssetPath,
  });

  // Dummy Data List for the demo.
  static List<Character> dummyCharacters = [
    Character(
      name: 'Astro-Bot',
      description:
          'The interstellar scout. Agile and quick on its metallic feet.',
      power: 'Quantum Leap (Teleport)',
      glbAssetPath:
          'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
    ),
    Character(
      name: 'Cyber-Knight',
      description:
          'A heavily armored defender, slow but nearly impervious to damage.',
      power: 'Energy Shield (Defense)',
      glbAssetPath: 'https://modelviewer.dev/shared-assets/models/Horse.glb',
    ),
    Character(
      name: 'Hyper-Bot',
      description:
          'The high-tech warrior. Fast and agile, but vulnerable to damage.',
      power: 'Hyper Beam (Attack)',
      glbAssetPath:
          'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
    ),
  ];
}
