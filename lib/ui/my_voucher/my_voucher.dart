import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/voucher_type.dart';
import 'package:boilerplate/data/network/apis/posts/general_api.dart';
import 'package:boilerplate/di/components/service_locator.dart';
import 'package:boilerplate/models/post/voucher.model.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/widgets/rounded_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
                if(list.length > 0)
                Container(
                  height: MediaQuery.of(context).size.height * 3,
                  child: RefreshIndicator(
                      child: ListView(
                        children: [
                          ...list.reversed.toList().map(
                                (item) => _buildVoucher(context, item),
                              ),
                        ],
                      ),
                      onRefresh: _handleRefresh),
                )
                else Center(child: Text("Kh??ng c?? voucher n??o."),)
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
                        ? "H??? tr???"
                        : type == 2
                            ? "C???u tr???"
                            : "Kh???n c???p",
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
                      "Voucher ????? ?????i\nnhu y???u ph???m v?? d???ch v???",
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
  late IO.Socket socket;

  GeneralApi _generalApi = getIt<GeneralApi>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handleLoad();
    _connect();
  }

  _connect() {
    print('try to connect');
    socket = IO.io(
        'http://34.87.41.29:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket.connect();
    socket.onConnect((_) {
      print('connect');
    });
    socket.on('claim_success', _handleSuccess);
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  _handleSuccess(dynamic id) {
    if (id.length != 0) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(Routes.success);
    }
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
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
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
                    "M?? thanh to??n",
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
                  CountdownTime(
                    onComplete: _handleLoad,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: InkWell(
                      child: RoundedButtonWidget(
                        buttonText: "????ng",
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

class CountdownTime extends StatefulWidget {
  final Function onComplete;
  CountdownTime({Key? key, required this.onComplete}) : super(key: key);

  @override
  _CountdownTimeState createState() => _CountdownTimeState();
}

class _CountdownTimeState extends State<CountdownTime> {
  late Timer time;
  int timeCount = 0;

  @override
  void initState() {
    var duration = const Duration(seconds: 1);
    time = Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        setState(() {
          timeCount = timer.tick;
        });
        if (timer.tick >= 30) {
          timer.cancel();
          Navigator.of(context).pop();
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    time.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Th???i h???n trong: " + (30 - timeCount).toString() + "s",
      style: TextStyle(fontSize: 18),
    );
  }
}
