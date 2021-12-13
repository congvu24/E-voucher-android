import 'package:equatable/equatable.dart';

class Voucher extends Equatable {
  final String id;
  final String token;
  final String type;

  Voucher({required this.id, required this.token, required this.type});

  @override
  List<Object?> get props => [id, token, type];

  static fromJson(Map<String, dynamic> json) {
    return new Voucher(
        id: json["id"], token: json["token"], type: json["type"]);
  }
}

class VoucherQR extends Equatable {
  final String voucherId;
  final int timeout;
  final String url;

  VoucherQR(
      {required this.voucherId, required this.timeout, required this.url});

  @override
  List<Object?> get props => [voucherId, timeout, url];

  static fromJson(Map<String, dynamic> json) {
    return new VoucherQR(
        voucherId: json["voucherId"],
        timeout: json["timeout"],
        url: json["url"]);
  }
}
