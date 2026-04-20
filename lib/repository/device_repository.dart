// import 'package:my_project/core/api/api_service.dart';
import 'package:my_project/models/device_model.dart';
import 'package:my_project/repository/general_repository.dart';

class DeviceRepository extends GeneralRepository {
  DeviceRepository({required super.db, required super.api});

  Future<Device?> getDeviceByPrivateName(String privateName) async {
    try {
      final data = await api.get('device/by-private-name/$privateName');

      final device = Device.fromMap(data['obj'] as Map<String, dynamic>);

      await insertInDb(device);

      return device;
    } catch (e) {
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
  }

  Future<List<Device>> getDevicesByObjectId(int objectId) async {
    try {
      final data = await api.get('/device/object/$objectId');

      final devices = (data['list'] as List)
          .map((e) => Device.fromMap(e as Map<String, dynamic>))
          .toList();

      for (var d in devices) {
        await insertInDb(d);
      }

      return devices;
    } catch (e) {
      final List<Map<String, Object?>> devices = await db.query(
        'device',
        where: 'objectId = ?',
        whereArgs: [objectId],
      );
      final List<Device> result = devices.map(Device.fromMap).toList();
      return result;
    }
  }
}
