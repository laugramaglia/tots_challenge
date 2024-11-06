// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createClientHash() => r'a328c858df95ce0653e2e178b777b542ad99f26a';

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

/// See also [createClient].
@ProviderFor(createClient)
const createClientProvider = CreateClientFamily();

/// See also [createClient].
class CreateClientFamily extends Family<AsyncValue<CustomerModel?>> {
  /// See also [createClient].
  const CreateClientFamily();

  /// See also [createClient].
  CreateClientProvider call(
    CustomerModel client,
  ) {
    return CreateClientProvider(
      client,
    );
  }

  @override
  CreateClientProvider getProviderOverride(
    covariant CreateClientProvider provider,
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
  String? get name => r'createClientProvider';
}

/// See also [createClient].
class CreateClientProvider extends AutoDisposeFutureProvider<CustomerModel?> {
  /// See also [createClient].
  CreateClientProvider(
    CustomerModel client,
  ) : this._internal(
          (ref) => createClient(
            ref as CreateClientRef,
            client,
          ),
          from: createClientProvider,
          name: r'createClientProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createClientHash,
          dependencies: CreateClientFamily._dependencies,
          allTransitiveDependencies:
              CreateClientFamily._allTransitiveDependencies,
          client: client,
        );

  CreateClientProvider._internal(
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
    FutureOr<CustomerModel?> Function(CreateClientRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateClientProvider._internal(
        (ref) => create(ref as CreateClientRef),
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
    return _CreateClientProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateClientProvider && other.client == client;
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
mixin CreateClientRef on AutoDisposeFutureProviderRef<CustomerModel?> {
  /// The parameter `client` of this provider.
  CustomerModel get client;
}

class _CreateClientProviderElement
    extends AutoDisposeFutureProviderElement<CustomerModel?>
    with CreateClientRef {
  _CreateClientProviderElement(super.provider);

  @override
  CustomerModel get client => (origin as CreateClientProvider).client;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package