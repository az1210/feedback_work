class PeopleInfoModel {
  final String? name;
  final String? avaterUrl;
  PeopleInfoModel({
    this.name,
    this.avaterUrl,
  });

  PeopleInfoModel copyWith({
    String? name,
    String? avaterUrl,
  }) {
    return PeopleInfoModel(
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

  factory PeopleInfoModel.fromMap(Map<String, dynamic> map) {
    return PeopleInfoModel(
      name: map['name'] != null ? map['name'] as String : null,
      avaterUrl: map['avaterUrl'] != null ? map['avaterUrl'] as String : null,
    );
  }
}
