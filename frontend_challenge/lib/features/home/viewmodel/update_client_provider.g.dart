// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$updateClientHash() => r'de36bd738af6f8676b4cadee8a19a064b178110e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [updateClient].
@ProviderFor(updateClient)
const updateClientProvider = UpdateClientFamily();

/// See also [updateClient].
class UpdateClientFamily extends Family<AsyncValue<CustomerModel?>> {
  /// See also [updateClient].
  const UpdateClientFamily();

  /// See also [updateClient].
  UpdateClientProvider call(
    CustomerModel client,
  ) {
    return UpdateClientProvider(
      client,
    );
  }

  @override
  UpdateClientProvider getProviderOverride(
    covariant UpdateClientProvider provider,
  ) {
    return call(
      provider.client,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateClientProvider';
}

/// See also [updateClient].
class UpdateClientProvider extends AutoDisposeFutureProvider<CustomerModel?> {
  /// See also [updateClient].
  UpdateClientProvider(
    CustomerModel client,
  ) : this._internal(
          (ref) => updateClient(
            ref as UpdateClientRef,
            client,
          ),
          from: updateClientProvider,
          name: r'updateClientProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateClientHash,
          dependencies: UpdateClientFamily._dependencies,
          allTransitiveDependencies:
              UpdateClientFamily._allTransitiveDependencies,
          client: client,
        );

  UpdateClientProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.client,
  }) : super.internal();

  final CustomerModel client;

  @override
  Override overrideWith(
    FutureOr<CustomerModel?> Function(UpdateClientRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateClientProvider._internal(
        (ref) => create(ref as UpdateClientRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        client: client,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CustomerModel?> createElement() {
    return _UpdateClientProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateClientProvider && other.client == client;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, client.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateClientRef on AutoDisposeFutureProviderRef<CustomerModel?> {
  /// The parameter `client` of this provider.
  CustomerModel get client;
}

class _UpdateClientProviderElement
    extends AutoDisposeFutureProviderElement<CustomerModel?>
    with UpdateClientRef {
  _UpdateClientProviderElement(super.provider);

  @override
  CustomerModel get client => (origin as UpdateClientProvider).client;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
