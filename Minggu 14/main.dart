// Nama: Wafiq Nur Azizah
// NIM: 2311102270

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'character_model.dart';
import 'db_helper.dart';
import 'counter_provider.dart';
import 'counter_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CounterProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gabungan SQLite & Provider',
      theme: ThemeData.dark(useMaterial3: true),
      home: const CharacterListScreen(),
    );
  }
}

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => CharacterListScreenState();
}

class CharacterListScreenState extends State<CharacterListScreen> {
  List<Character> _characters = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFromLocal();
  }

  Future<void> _loadFromLocal() async {
    setState(() => _isLoading = true);
    final localData = await DatabaseHelper.instance.getAllCharacters();
    setState(() {
      _characters = localData;
      _isLoading = false;
    });
  }

  Future<void> _deleteAllData() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Data?'),
        content: const Text('apakah anda yakin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await DatabaseHelper.instance.clearTable();
      setState(() {
        _characters.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua data berhasil dihapus.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchFromAPI() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataJson = json.decode(response.body);
        await DatabaseHelper.instance.clearTable();

        List<Character> freshCharacters = [];
        for (var item in dataJson) {
          final char = Character.fromMap(item);
          freshCharacters.add(char);
          await DatabaseHelper.instance.insertCharacter(char);
        }
        setState(() => _characters = freshCharacters);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil sync data dari server!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal konek internet, pastikan online.')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ensiklopedia NPC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
            tooltip: 'Hapus Semua Data',
            onPressed: _characters.isEmpty ? null : _deleteAllData,
          ),
          IconButton(
            icon: const Icon(Icons.cloud_download),
            tooltip: 'Sync dari Server',
            onPressed: _fetchFromAPI,
          ),
          IconButton(
            icon: const Icon(Icons.calculate, color: Colors.blueAccent),
            tooltip: 'Buka Counter Provider',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CounterScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _characters.isEmpty
              ? const Center(child: Text('Data kosong.'))
              : ListView.builder(
                  itemCount: _characters.length,
                  itemBuilder: (context, index) {
                    final char = _characters[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Text(char.id.toString()),
                      ),
                      title: Text(char.name),
                      subtitle: Text('Username: ${char.username}'),
                    );
                  },
                ),
    );
  }
}