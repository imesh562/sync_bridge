import 'package:injectable/injectable.dart';
import 'package:sync_bridge/core/network/api_helper.dart';
import 'package:sync_bridge/core/network/webhook_helper.dart';

@lazySingleton
class AuthRemoteDatasource {
  AuthRemoteDatasource(this._api, this._ws);

  final ApiHelper _api;
  final WebhookHelper _ws;
}
