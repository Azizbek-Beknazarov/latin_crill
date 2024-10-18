import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latin_crillic/functions/functions.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum Language { Latin, Cyrillic }

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  late TextEditingController _controllerLatin;
  late TextEditingController _controllerCrillic;
  Language _currentLanguage = Language.Latin;
  Database? _database;
  List<Map<String, dynamic>> _savedTranslations = [];

  @override
  void initState() {
    super.initState();
    _controllerLatin = TextEditingController();
    _controllerCrillic = TextEditingController();
    _initDatabase();
    _controllerLatin.addListener(_convertText);
  }

  @override
  void dispose() {
    _controllerLatin.dispose();
    _controllerCrillic.dispose();
    _database?.close();
    super.dispose();
  }

  Future<void> _initDatabase() async {
    try {
      String dbPath = join(await getDatabasesPath(), 'translations.db');
      _database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE translations(id INTEGER PRIMARY KEY AUTOINCREMENT, original TEXT, translated TEXT)",
          );
        },
      );
      await _loadSavedTranslations();
    } catch (e) {
    } finally {}
  }

  Future<void> _deleteTranslation(int id) async {
    if (_database == null) {
      return;
    }

    try {
      await _database!.delete(
        'translations',
        where: 'id = ?',
        whereArgs: [id],
      );
      _loadSavedTranslations();
    } catch (e) {}
  }

  Future<void> _deleteAllTranslations(BuildContext context) async {
    if (_database == null) {
      return;
    }

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Barcha Tarjimalarni O\'chirish'),
          content: const Text('Haqiqatan ham barcha tarjimalarni o\'chirmoqchimisiz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Yo\'q'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ha'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await _database!.delete('translations');
      _loadSavedTranslations();
    } catch (e) {}
  }

  Future<void> _loadSavedTranslations() async {
    if (_database != null) {
      final List<Map<String, dynamic>> maps = await _database!.query(
        'translations',
        orderBy: 'id DESC',
      );
      setState(() {
        _savedTranslations = maps;
      });
    }
  }

  void _convertText() {
    String input = _controllerLatin.text;
    String output;
    if (_currentLanguage == Language.Latin) {
      output = latinToCyrillic(input);
    } else {
      output = cyrillicToLatin(input);
    }
    setState(() {
      _controllerCrillic.text = output;
    });
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == Language.Latin ? Language.Cyrillic : Language.Latin;
      _convertText();
    });
  }

  Future<void> _saveTranslation() async {
    if (_database == null) {
      return;
    }

    String original = _controllerLatin.text.trim();
    String translated = _controllerCrillic.text.trim();

    if (original.isEmpty || translated.isEmpty) {
      return;
    }

    try {
      await _database!.insert(
        'translations',
        {'original': original, 'translated': translated},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      _loadSavedTranslations();
    } catch (e) {}
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void _loadTranslation(Map<String, dynamic> translation) {
    setState(() {
      _controllerLatin.text = translation['original'];
      _controllerCrillic.text = translation['translated'];
      _currentLanguage = _isLatin(translation['original']) ? Language.Latin : Language.Cyrillic;
    });
  }

  bool _isLatin(String text) {
    return RegExp(r'[A-Za-z]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uzbek Lotin - Krill Tarjimon'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: _toggleLanguage,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTranslation,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              _deleteAllTranslations(context);
            },
            tooltip: 'Barcha tarjimalarni o\'chirish',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              maxLines: 5,
              minLines: 5,
              controller: _controllerLatin,
              decoration: InputDecoration(
                labelText: _currentLanguage == Language.Latin ? 'Lotincha matn' : 'Krillcha matn',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              maxLines: 5,
              minLines: 5,
              readOnly: true,
              controller: _controllerCrillic,
              decoration: InputDecoration(
                labelText: _currentLanguage == Language.Latin ? 'Krillcha matn' : 'Lotincha matn',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _copyToClipboard(_controllerCrillic.text),
              child: const Text('Nusxalash'),
            ),
            const SizedBox(height: 20),
            _savedTranslations.isEmpty
                ? const Center(child: Text('Hozircha bo\'sh'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _savedTranslations.length,
                    itemBuilder: (context, index) {
                      final item = _savedTranslations[index];
                      return ListTile(
                        title: Text(item['original']),
                        subtitle: Text(item['translated']),
                        onTap: () => _loadTranslation(item),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () => _copyToClipboard(item['translated']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteTranslation(item['id']),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
