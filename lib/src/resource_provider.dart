library resource_provider;

import 'package:meta/meta.dart';
import 'package:quiver/core.dart' as quiver;

/// An identifier for a resource.
///
/// This is used to identify a resource in a [ResourceProvider] using type [T] and optionally [name].
class Identifier<T> {
  final String? name;

  const Identifier(this.name);

  @override
  bool operator ==(Object other) {
    if (other is! Identifier) return false;
    final oName = other.name;
    if (name == null && oName == null) {
      return other is Identifier<T>;
    }
    return name == oName && other is Identifier<T>;
  }

  @override
  int get hashCode => quiver.hash2(T, name);
}

/// Represents state of a resource that can be loaded from a [ResourceProvider].
@immutable
class ResourceState<T> {
  final Identifier<T> identifier;
  final T? value;
  final T Function() onCreate;
  final void Function()? onDispose;

  bool get mounted => value != null;

  const ResourceState(
    this.identifier,
    this.value,
    this.onCreate,
    this.onDispose,
  );

  @protected
  ResourceState<T> withValue() {
    final value = onCreate();
    return ResourceState<T>(
      identifier,
      value,
      onCreate,
      onDispose,
    );
  }

  @protected
  ResourceState<T> from(T? value) {
    return ResourceState<T>(
      identifier,
      value,
      onCreate,
      onDispose,
    );
  }

  @protected
  ResourceState<T> withoutValue() {
    onDispose?.call();
    return ResourceState<T>(
      identifier,
      null,
      onCreate,
      onDispose,
    );
  }

  ResourceState.fromData(ResourceData<T> data)
      : identifier = data.identifier,
        value = data.value,
        onCreate = data.onCreate,
        onDispose = data.onDispose;
}

/// Information of a resource that can be loaded from a [ResourceProvider].
class ResourceData<T> {
  /// A name for the resource.
  ///
  /// Optional but when provided, this can be used to identify the resource in a [ResourceProvider] by name and Type.
  final String? name;

  /// If not null, this value will replace the value of the resource.
  final T? value;

  /// Called to create a value when it does not exist for a resource.
  final T Function() onCreate;

  /// Called when this resource is no longer needed or cleared.
  final void Function()? onDispose;

  final Identifier<T> identifier;

  ResourceData({
    this.name,
    this.value,
    required this.onCreate,
    this.onDispose,
  }) : identifier = Identifier<T>(name);

  ResourceData<T> copyWith({
    String? name,
    T? value,
    T Function()? onCreate,
    void Function()? onDispose,
  }) {
    return ResourceData<T>(
      name: name ?? this.name,
      value: value ?? this.value,
      onCreate: onCreate ?? this.onCreate,
      onDispose: onDispose ?? this.onDispose,
    );
  }
}

class ResourceProvider {
  final _resources = <Identifier, ResourceState>{};

  ResourceProvider();

  void setResourceState<T>(Identifier<T> identifier, ResourceState<T> state) {
    _resources[identifier] = state;
  }

  ResourceState<T>? getResourceState<T>(Identifier<T> identifier) {
    return _resources[identifier] as ResourceState<T>?;
  }

  T get<T>({
    String? name,
    T? value,
    required T Function() onCreate,
    void Function()? onDispose,
  }) {
    return call<T>(
      ResourceData<T>(
        name: name,
        value: value,
        onCreate: onCreate,
        onDispose: onDispose,
      ),
    );
  }

  T call<T>(ResourceData<T> data) {
    final oldState = getResourceState<T>(data.identifier);
    ResourceState<T>? state = oldState;

    if (state == null || data.value != null) {
      state = ResourceState<T>.fromData(data);
    }

    if (!state.mounted) {
      state = state.withValue();
    }

    if (!identical(oldState, state)) {
      setResourceState<T>(data.identifier, state);
    }

    return state.value!;
  }

  void dispose() => clear();

  void clear() {
    for (final state in _resources.values) {
      state.onDispose?.call();
    }

    _resources.clear();
  }
}
