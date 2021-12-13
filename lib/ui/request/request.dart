import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/voucher_type.dart';
import 'package:boilerplate/data/network/apis/posts/general_api.dart';
import 'package:boilerplate/di/components/service_locator.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/widgets/rounded_button_widget.dart';
import 'package:boilerplate/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  bool isLoading = false;
  String type = "";
  String note = "";
  GeneralApi _generalApi = getIt<GeneralApi>();

  createRequest() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _generalApi.createRequest(type, note);
      FlushbarHelper.createSuccess(
        message: "Tạo yêu cầu thành công",
        title: "Thành công",
        duration: Duration(seconds: 3),
      )..show(context);
    } catch (err) {
      FlushbarHelper.createError(
        message: "Tạo yêu cầu thất bại",
        title: "Lỗi",
        duration: Duration(seconds: 3),
      )..show(context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          SafeArea(
              child: Container(
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
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Loại voucher:",
                            style: TextStyle(fontSize: 16),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: true,
                                groupValue: type == VoucherType.support,
                                onChanged: (value) {
                                  if (value == true) {
                                    setState(() {
                                      type = VoucherType.support;
                                    });
                                  }
                                },
                              ),
                              Text("Hỗ trợ")
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: true,
                                groupValue: type == VoucherType.help,
                                onChanged: (value) {
                                  if (value == true) {
                                    setState(() {
                                      type = VoucherType.help;
                                    });
                                  }
                                },
                              ),
                              Text("Cứu trợ")
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: true,
                                groupValue: type == VoucherType.urgent,
                                onChanged: (value) {
                                  if (value == true) {
                                    setState(() {
                                      type = VoucherType.urgent;
                                    });
                                  }
                                },
                              ),
                              Text("Khẩn cấp")
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Lý do yêu cầu:",
                            style: TextStyle(fontSize: 16),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 8,
                        onChanged: (text) {
                          setState(() {
                            note = text;
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 4.0),
                            ),
                            hintText: "Nội dung yêu cầu hỗ trợ"),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: RoundedButtonWidget(
                          buttonText: "Gửi yêu cầu",
                          buttonColor: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            createRequest();
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
          Visibility(
            visible: isLoading,
            child: CustomProgressIndicatorWidget(),
          )
        ],
      ),
    );
  }
}
