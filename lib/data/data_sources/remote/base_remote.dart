import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../../core/connectivity.dart';
import '../../../core/exception/no_connection_exception.dart';
import '../../../core/exception/remote_exception.dart';
import '../../../core/logger.dart';

class RemoteDataSource {
  final Client client;
  final AppLogger logger;
  final Map<String, Future<Response>> pendingRequests = {};
  RemoteDataSource({required this.client, required this.logger});

  //All responses uses utf8 as coding, so it's necessary to decode appropriatly
  @protected
  Map<String, dynamic> decodeToJson(Response response) {
    return json.decode(utf8.decode(response.bodyBytes));
  }

  @protected
  Future<Response> getRespone(String endpoint) async {
    if (pendingRequests.containsKey(endpoint)) {
      _logEndpointRepeat(endpoint);
      return pendingRequests[endpoint]!;
    }

    final uri = 'https://ruz.spbstu.ru/api/v1/ruz/$endpoint';
    _logEndpointCall(uri);
    final futureResponse = client
        .get(Uri.parse(uri))
        .timeout(const Duration(seconds: 10)); // optional timeout;

    pendingRequests[endpoint] = futureResponse;
    try {
      final response = await futureResponse;
      _logEndpointResult(uri, response);

      return response;
    } on SocketException catch (e) {
      return throwException(RemoteException('Socket error: ${e.message}'));
    } on TimeoutException catch (_) {
      return throwException(RemoteException('Request timed out'));
    } on ClientException catch (e) {
      return throwException(RemoteException('Client error: ${e.message}'));
    } catch (e) {
      return throwException(RemoteException('Unknown error: $e'));
    } finally {
      pendingRequests.remove(endpoint);
    }
  }

  void _logEndpointCall(String endpoint) {
    logger.debug(
      'Called an endpoint: $endpoint',
      stackTrace: StackTrace.current,
    );
  }

  void _logEndpointRepeat(String endpoint) {
    logger.debug(
      'Repeated endpoint call: $endpoint',
      stackTrace: StackTrace.current,
    );
  }

  void _logEndpointResult(String endpoint, Response response) {
    if (response.statusCode == 200) {
      logger.debug('Endpoint: $endpoint\nResponse: ${response.statusCode}');
    } else {
      logger.error(
        'Endpoint: $endpoint\nResponse: ${response.statusCode}\nBody:${response.body}',
      );
    }
  }

  Future<Never> throwException(RemoteException e) async {
    if (await InternetConnectivity.hasInternet()) {
      throw e;
    }
    throw NoConnectionException('No Connection ${e.message}');
  }
}
