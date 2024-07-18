class DBPhotoStudio {
  final int id;
  final String name;
  final String description;
  final String imagePath;

  DBPhotoStudio({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
  });

  factory DBPhotoStudio.fromMap(Map<String, dynamic> json) => DBPhotoStudio(
    id: json['id'] ?? 0, 
    name: json ['name'] ?? '', 
    description: json ['description'] ?? '', 
    imagePath: json ['imagePath'] ?? ''
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
    "imagePath": imagePath
  };
}