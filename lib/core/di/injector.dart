import 'package:trucky/core/network/api_client.dart';
import 'package:trucky/core/network/mock_api_client.dart';
import 'package:trucky/core/network/network_info.dart';

/// Global composition root: provides shared infrastructure to every feature.
///
/// Blocs receive these as constructor dependencies. Swap `MockApiClient` for
/// a real client here and the whole app switches over.
abstract final class Injector {
  static final ApiClient apiClient = const MockApiClient();

  static final NetworkInfo networkInfo = const NetworkInfoImpl();
}
