class Pet {
  int? id;
  String name;
  String species;
  bool isVaccinated;

  Pet({this.id, required this.name, required this.species, this.isVaccinated = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'isVaccinated': isVaccinated ? 1 : 0,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'],
      species: map['species'],
      isVaccinated: map['isVaccinated'] == 1,
    );
  }
}
