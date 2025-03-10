class SavedGameId {
  int id;

  SavedGameId({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory SavedGameId.fromMap(Map<String, dynamic> map) {
    return SavedGameId(
      id: map['id'],
    );
  }

  @override
  String toString() {
    return '$id';
  }
}