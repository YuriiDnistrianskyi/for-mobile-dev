import 'package:my_project/models/device_model.dart';
import 'package:my_project/repository/general_repository.dart';

class DeviceRepository extends GeneralRepository {
  DeviceRepository({required super.db});

  Future<Device?> getDeviceByPrivateName(String privateName) async {
    final List<Map<String, dynamic>> objects = await db.query(
      'device',
      where: 'privateName = ?',
      whereArgs: [privateName],
    );
    if (objects.isNotEmpty) {
      return Device.fromMap(objects.first);
    }
    return null;
  }

  Future<List<Device>> getDevicesByObjectId(int objectId) async {
    final List<Map<String, Object?>> devices = await db.query(
      'device',
      where: 'objectId = ?',
      whereArgs: [objectId]
    );
    final List<Device> result = devices.map(Device.fromMap).toList();
    return result;
  }
}
