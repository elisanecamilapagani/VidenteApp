class Tema {
  int codigo = 0;

  Tema(this.codigo);

  @override
  String toString() {
    return 'Tema{id: 1, codigo: $codigo}';
  }

  Map<String, dynamic> toMap() {
    return {'id': 1, 'codigo': codigo};
  }
}
