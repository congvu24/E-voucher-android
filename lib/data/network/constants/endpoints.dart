class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://34.87.41.29:3000";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // booking endpoints
  static const String getPosts = baseUrl + "/posts";
  static const String postLogin = baseUrl + "/auth/login/citizen";
  static const String postSignup = baseUrl + "/citizen/register";
  static const String getMyVouchers = baseUrl + "/voucher/my?status=UNUSE&take=20";
  static String getVoucherQr(String id) => baseUrl + "/voucher/qr/$id";
  static String createRequest = baseUrl + "/voucher-request";
  static String getClaimHistory = baseUrl + "/voucher/claimed/my";
  static String getRequestHistory = baseUrl + "/voucher-request?order=DESC&status=PENDING";
}
