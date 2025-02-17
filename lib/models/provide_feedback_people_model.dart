class ProvideInfoModel {
  String? name;
  String? avaterUrl;
  ProvideInfoModel({
    this.name = '',
    this.avaterUrl = '',
  });

  ProvideInfoModel copyWith({
    String? name,
    String? avaterUrl,
  }) {
    return ProvideInfoModel(
      name: name ?? this.name,
      avaterUrl: avaterUrl ?? this.avaterUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'avaterUrl': avaterUrl,
    };
  }

  factory ProvideInfoModel.fromMap(Map<String, dynamic> map) {
    return ProvideInfoModel(
      name: map['name'] as String? ?? '',
      avaterUrl: map['avaterUrl'] as String? ?? '',
    );
  }
}
