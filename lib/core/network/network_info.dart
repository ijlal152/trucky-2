/// Abstraction over connectivity checks.
///
/// Kept as an interface so repositories can decide between remote and
/// local data sources based on connectivity, and so it can be faked
/// in tests.
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl();

  @override
  Future<bool> get isConnected async => true; // TODO: wire `connectivity_plus`
}
