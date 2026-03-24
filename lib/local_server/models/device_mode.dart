class Device {
  final int id;
  final String publicName;
  final String privatName;
  final String password;
  final int objectId;

  Device({
    required this.id,
    required this.publicName,
    required this.privatName,
    required this.password,
    required this.objectId,
  });

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] as int,
      publicName: map['publicName'] as String,
      privatName: map['privatName'] as String,
      password: map['password'] as String,
      objectId: map['objectId'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': id,
      'publicName': privatName,
      'privateName': privatName,
      'password': password,
      'object_id': objectId,
    };
    return data;
  }
}
