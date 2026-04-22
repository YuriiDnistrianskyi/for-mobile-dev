import 'package:my_project/models/object_model.dart';

class ObjectState {
  final List<MyObject> objects;
  final MyObject? object;
  final bool isLoading;
  final String? error;

  ObjectState({
    required this.objects,
    required this.isLoading,
    this.object,
    this.error,
  });

  factory ObjectState.initial() {
    return ObjectState(
      objects: [],
      isLoading: false,
    );
  }

  ObjectState copyWith({
     List<MyObject>? objects,
     MyObject? object,
     bool? isLoading,
     String? error,
  }) {
    return ObjectState(
      objects: objects ?? this.objects,
      isLoading: isLoading ?? this.isLoading,
      object: object ?? this.object,
      error: error ?? this.error
    );
  }
}
