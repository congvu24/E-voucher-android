import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/constants/font_family.dart';
import 'package:boilerplate/constants/voucher_type.dart';
import 'package:boilerplate/data/network/apis/posts/general_api.dart';
import 'package:boilerplate/di/components/service_locator.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/widgets/rounded_button_widget.dart';
import 'package:boilerplate/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var dateFormat = DateFormat('HH:mm dd/MM/yyyy');

class HistoryRequest extends StatefulWidget {
  const HistoryRequest({Key? key}) : super(key: key);

  @override
  State<HistoryRequest> createState() => _HistoryRequestState();
}

class _HistoryRequestState extends State<HistoryRequest> {
  late GeneralApi _generalApi;
  bool isLoading = true;
  bool isError = false;
  List<dynamic> list = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generalApi = getIt<GeneralApi>();
    _handleRefresh();
  }

  renderRow(dynamic item) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 50,
            child: Image.asset(
              "assets/images/payment.png",
              scale: 0.8,
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      "Tạo yêu cầu thành công",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontFamily.roboto),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      dateFormat.format(DateTime.parse(item["createdAt"])),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          fontFamily: FontFamily.roboto),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      'Loại hỗ trợ: ' + item["type"],
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontFamily.roboto,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    try {
      isLoading = true;
      List<dynamic> result = await _generalApi.getRequestHistory();
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
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color: Theme.of(context).primaryColorLight)),
                          child: Icon(
                            Icons.chevron_left,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 2 - 100),
                        child: Center(
                            child: Text(
                          "Yêu cầu của tôi",
                          style: TextStyle(fontSize: 16),
                        )),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 1,
                        onChanged: (text) {},
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 4.0),
                            ),
                            hintText: "Tìm kiếm yêu cầu"),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ...list.map((e) => renderRow(e)).toList()
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
