class ProvideFeedbackPeopleModel {
  final String? name;
  final String? avaterUrl;
  ProvideFeedbackPeopleModel({
    this.name,
    this.avaterUrl,
  });

  ProvideFeedbackPeopleModel copyWith({
    String? name,
    String? avaterUrl,
  }) {
    return ProvideFeedbackPeopleModel(
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

  factory ProvideFeedbackPeopleModel.fromMap(Map<String, dynamic> map) {
    return ProvideFeedbackPeopleModel(
      name: map['name'] != null ? map['name'] as String : null,
      avaterUrl: map['avaterUrl'] != null ? map['avaterUrl'] as String : null,
    );
  }
}
