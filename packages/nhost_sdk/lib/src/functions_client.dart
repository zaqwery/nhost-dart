import 'package:http/http.dart' as http;

import 'api/api_client.dart';
import 'foundation/uri.dart';
import 'logging.dart';
import 'session.dart';

/// Client for calling Nhost serverless functions.
///
/// See https://docs.nhost.io/platform/serverless-functions for more info.
class FunctionsClient {
  /// {@macro nhost.api.NhostClient.subdomain}
  ///
  /// {@macro nhost.api.NhostClient.region}
  ///
  /// {@macro nhost.api.NhostClient.httpClientOverride}
  FunctionsClient({
    required String subdomain,
    required String region,
    required UserSession session,
    required http.Client httpClient,
  })  : _apiClient = ApiClient(
          Uri.parse(
            createNhostServiceEndpoint(
              region: region,
              subdomain: subdomain,
              service: 'functions',
            ),
          ),
          httpClient: httpClient,
        ),
        _session = session;

  final ApiClient _apiClient;
  final UserSession _session;

  /// Invokes the serverless function at [url].
  ///
  /// By default, the serverless function is invoked using an HTTP POST, so both
  /// a request body and query variables can be provided.
  ///
  /// The HTTP method used for the call can be overridden via [httpMethod].
  ///
  /// Throws an [ApiException] if a failure occurs.
  Future<http.Response> callFunction(
    String url, {
    Map<String, String?>? query,
    Map<String, dynamic>? jsonBody,
    String httpMethod = 'post',
  }) async {
    log.finer('Calling function, url=$url');

    return _apiClient.request<http.Response>(
      httpMethod,
      url,
      query: query,
      jsonBody: jsonBody,
      headers: _session.authenticationHeaders,
    );
  }
}
