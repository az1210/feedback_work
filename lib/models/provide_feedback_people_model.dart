class PeopleInfoModel {
  String? name;
  String? avaterUrl;
  PeopleInfoModel({
    this.name = '',
    this.avaterUrl = '',
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
      name: map['name'] as String? ?? '',
      avaterUrl: map['avaterUrl'] as String? ?? '',
    );
  }
}
