import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/models/post/voucher.model.dart';
import 'package:dio/dio.dart';

class GeneralApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  GeneralApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<String> login(String email, String password) async {
    try {
      Map<String, dynamic> response = await _dioClient.post(Endpoints.postLogin,
          data: {"email": email, "password": password});
      print(response);

      return response["token"]["accessToken"];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<List<Voucher>> getMyVoucher() async {
    try {
      Map<String, dynamic> response = await _dioClient.get(
        Endpoints.getMyVouchers,
      );
      List<Voucher> result = [];
      response["data"].forEach((item) {
        result.add(Voucher.fromJson(item));
      });
      return result;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<VoucherQR> getVoucherQr(String id) async {
    try {
      Map<String, dynamic> response = await _dioClient.put(
        Endpoints.getVoucherQr(id),
      );
      print(response);

      return VoucherQR.fromJson(response);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> createRequest(String type, String note) async {
    try {
      Map<String, dynamic> response = await _dioClient
          .post(Endpoints.createRequest, data: {"type": type, "note": note});
      print(response);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> signup(Map<String, dynamic> data) async {
    try {
      print(data);
      Map<String, dynamic> response =
          await _dioClient.post(Endpoints.postSignup, data: data);
      print(response);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<List<dynamic>> getClaimedHistory() async {
    try {
      Map<String, dynamic> response = await _dioClient.get(
        Endpoints.getClaimHistory,
      );
      return response["data"];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<List<dynamic>> getRequestHistory() async {
    try {
      Map<String, dynamic> response = await _dioClient.get(
        Endpoints.getRequestHistory,
      );
      return response["data"];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
