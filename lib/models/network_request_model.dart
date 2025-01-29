enum ConnectionStatus {
  requested,
  connected,
}

class NetworkRequestModel {
  final String? requestedFrom;
  final String? requestedTo;
  final String? connectAs;
  final String? connectionStatus;
  NetworkRequestModel({
    this.requestedFrom,
    this.requestedTo,
    this.connectAs,
    this.connectionStatus,
  });

  NetworkRequestModel copyWith({
    String? requestedFrom,
    String? requestedTo,
    String? connectAs,
    String? connectionStatus,
  }) {
    return NetworkRequestModel(
      requestedFrom: requestedFrom ?? this.requestedFrom,
      requestedTo: requestedTo ?? this.requestedTo,
      connectAs: connectAs ?? this.connectAs,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'requestedFrom': requestedFrom,
      'requestedTo': requestedTo,
      'connectAs': connectAs,
      'connectionStatus': connectionStatus,
    };
  }

  factory NetworkRequestModel.fromMap(Map<String, dynamic> map) {
    return NetworkRequestModel(
      requestedFrom:
          map['requestedFrom'] != null ? map['requestedFrom'] as String : null,
      requestedTo:
          map['requestedTo'] != null ? map['requestedTo'] as String : null,
      connectAs: map['connectAs'] != null ? map['connectAs'] as String : null,
      connectionStatus: map['connectionStatus'] != null
          ? map['connectionStatus'] as String
          : null,
    );
  }
}
