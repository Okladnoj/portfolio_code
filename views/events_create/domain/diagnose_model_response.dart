class DiagnoseModelsRepository {
  final String status;
  final List<String> data;

  DiagnoseModelsRepository(
    this.status,
    this.data,
  );

  DiagnoseModelsRepository.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String,
        data = json['data'].cast<String>() as List<String>;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['data'] = data;
    return data;
  }
}
