import 'package:my_project/models/device_model.dart';

class DeviceState{
  final List<Device> devices;
  final Device? device;
  final bool isLoading;
  final String? error;

  DeviceState({
    required this.devices,
    required this.isLoading,
    this.device,
    this.error,
  });

  factory DeviceState.initial() {
    return DeviceState(
      devices: [], 
      isLoading: false
    );
  }

  DeviceState copyWith({
    List<Device>? devices,
    Device? device,
    bool? isLoading,
    String? error,
  }) {
    return DeviceState(
      devices: devices ?? this.devices,
      isLoading: isLoading ?? this.isLoading,
      device: device ?? this.device,
      error: error ?? this.error,
    );
  }
}
