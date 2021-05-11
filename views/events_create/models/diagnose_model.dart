class DiagnoseModels {
  final List<DiagnoseModel> listDiagnoseModel;

  DiagnoseModels(this.listDiagnoseModel);
}

class DiagnoseModel {
  final String name;
  final String code;

  DiagnoseModel(this.name, this.code);

  @override
  bool operator ==(dynamic other) => other is DiagnoseModel && other.code == code;

  @override
  int get hashCode => code.hashCode;
}
