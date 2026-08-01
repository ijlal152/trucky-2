import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trucky/core/network/api_client.dart';
import 'package:trucky/core/network/mock_api_client.dart';
import 'package:trucky/core/network/network_info.dart';

/// Global composition root: provides shared infrastructure to every feature.
///
/// Feature-level providers (e.g. repositories) `watch` these to wire their
/// concrete dependencies. Swap `MockApiClient` for a real client here and
/// the whole app switches over.
final apiClientProvider = Provider<ApiClient>((ref) => const MockApiClient());

final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => const NetworkInfoImpl(),
);
