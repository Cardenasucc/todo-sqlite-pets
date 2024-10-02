import 'package:flutter/material.dart';
import 'package:todo_sqlite/database_helper.dart';
import 'package:todo_sqlite/pet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veterinaria',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: false,
      ),
      home: const PetListScreen(),
    );
  }
}

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  final _dbHelper = DatabaseHelper.instance;
  List<Pet> _pets = [];
  bool _isVaccinated = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    final pets = await _dbHelper.getPets();
    setState(() {
      _pets = pets.map((map) => Pet.fromMap(map)).toList();
    });
  }

  Future<void> _addPet() async {
    final String name = _nameController.text;
    final String species = _speciesController.text;

    if (name.isNotEmpty && species.isNotEmpty) {
      final pet = Pet(name: name, species: species, isVaccinated: _isVaccinated);
      await _dbHelper.insertPet(pet.toMap());
      _loadPets();
      
      // Limpiar los campos de entrada solo después de agregar una mascota
      _nameController.clear();
      _speciesController.clear();
      setState(() {
        _isVaccinated = false;
      });
    }
  }

  Future<void> _toggleVaccination(Pet pet) async {
    pet.isVaccinated = !pet.isVaccinated;
    await _dbHelper.updatePet(pet.toMap());
    _loadPets();
  }

  Future<void> _deletePet(int id) async {
    await _dbHelper.deletePet(id);
    _loadPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinaria - Mascotas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre de la mascota',
                  ),
                ),
                TextField(
                  controller: _speciesController,
                  decoration: const InputDecoration(
                    hintText: 'Especie de la mascota',
                  ),
                ),
                Row(
                  children: [
                    const Text('Vacunado:'),
                    Checkbox(
                      value: _isVaccinated,
                      onChanged: (value) {
                        setState(() {
                          _isVaccinated = value!;
                        });
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _addPet,
                  child: const Text('Agregar Mascota'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _pets.length,
              itemBuilder: (context, index) {
                final pet = _pets[index];
                return ListTile(
                  title: Text(
                    pet.name,
                    style: TextStyle(
                      decoration: pet.isVaccinated
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(pet.species),
                  leading: Checkbox(
                    value: pet.isVaccinated,
                    onChanged: (value) {
                      _toggleVaccination(pet);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deletePet(pet.id!);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}