import 'dart:convert';
import 'dart:typed_data';

import 'package:boilerplate/constants/voucher_type.dart';
import 'package:boilerplate/data/network/apis/posts/general_api.dart';
import 'package:boilerplate/di/components/service_locator.dart';
import 'package:boilerplate/models/post/voucher.model.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/widgets/rounded_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyVoucherScreen extends StatefulWidget {
  const MyVoucherScreen({Key? key}) : super(key: key);

  @override
  State<MyVoucherScreen> createState() => _MyVoucherScreenState();
}

class _MyVoucherScreenState extends State<MyVoucherScreen> {
  late GeneralApi _generalApi;
  bool isLoading = true;
  bool isError = false;
  List<Voucher> list = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generalApi = getIt<GeneralApi>();
    _handleRefresh();
  }

  Future<void> _handleRefresh() async {
    try {
      isLoading = true;
      List<Voucher> result = await _generalApi.getMyVoucher();
      setState(() {
        list = result;
      });
    } catch (err) {
      setState(() {
        isError = true;
      });
    } finally {
      isLoading = false;
    }
  }

  showQR(BuildContext context, String id) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return VoucherQRWidget(id: id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                              color: Theme.of(context).primaryColorLight)),
                      child: Icon(
                        Icons.chevron_left,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: RefreshIndicator(
                      child: ListView(
                        children: [
                          ...list.map(
                            (item) => _buildVoucher(context, item),
                          )
                        ],
                      ),
                      onRefresh: _handleRefresh),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildVoucher(
    BuildContext context,
    Voucher voucher,
  ) {
    int type = voucher.type == VoucherType.help
        ? 1
        : voucher.type == VoucherType.support
            ? 2
            : 3;
    return Center(
      child: InkWell(
        onTap: () {
          showQR(context, voucher.id);
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            children: [
              Image.asset(
                type == 1
                    ? "assets/images/voucher1.png"
                    : type == 2
                        ? "assets/images/voucher2.png"
                        : "assets/images/voucher3.png",
              ),
              Positioned(
                  top: 10,
                  right: 80,
                  child: Text(
                    "Xin Group\nVoucher",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  )),
              Positioned(
                  top: 100,
                  right: 80,
                  child: Container(
                    width: 50,
                    height: 5,
                    color: Colors.orange.withOpacity(0.8),
                  )),
              Positioned(
                  top: 120,
                  right: 80,
                  child: Text(
                    type == 1
                        ? "Hỗ trợ"
                        : type == 2
                            ? "Cứu trợ"
                            : "Khẩn cấp",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: type == 1
                            ? Colors.green
                            : type == 2
                                ? Colors.blue.withOpacity(0.8)
                                : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  )),
              Positioned(
                  top: 10,
                  right: 15,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Text(
                      "Voucher để đổi\nnhu yếu phẩm và dịch vụ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherQRWidget extends StatefulWidget {
  final String id;

  const VoucherQRWidget({Key? key, required this.id}) : super(key: key);

  @override
  State<VoucherQRWidget> createState() => _VoucherQRWidgetState();
}

class _VoucherQRWidgetState extends State<VoucherQRWidget> {
  bool isLoading = true;
  late VoucherQR qr;
  GeneralApi _generalApi = getIt<GeneralApi>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handleLoad();
  }

  _handleLoad() async {
    try {
      VoucherQR qrInfo = await _generalApi.getVoucherQr(widget.id);
      setState(() {
        qr = qrInfo;
        isLoading = false;
      });
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Center(
        child: isLoading == false
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Mã thanh toán",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 300,
                    height: 300,
                    child: Image.memory(Base64Decoder().convert(
                        qr.url.replaceAll("data:image/png;base64,", ""))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Thời hạn trong: 30s",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: InkWell(
                      child: RoundedButtonWidget(
                        buttonText: "Đóng",
                        buttonColor: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
