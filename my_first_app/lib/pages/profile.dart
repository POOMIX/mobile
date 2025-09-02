import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/response/customer_idx_get_res.dart';

class ProfilePage extends StatefulWidget {
  int idx = 0;
  ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<void> loadData;
  late CustomerIdxGetResponse customerIdxGetResponse;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadDataAsync(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final customers_show = snapshot.data!;
        log('Customer id: ${widget.idx}');
        return Scaffold(
          appBar: AppBar(title: const Text('ข้อมูลส่วนตัว')),
          body: FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              return Container(
                child: Column(
                  children: [
                    Image.network(customerIdxGetResponse.image),
                    Text('ชื่อ-นามสกุล: ${customerIdxGetResponse.fullname}'),
                    Text('หมายเลขโทรศัพท์: ${customerIdxGetResponse.phone}'),
                    Text('อีเมล: ${customerIdxGetResponse.email}'),
                    Text('รูปภาพ: ${customerIdxGetResponse.image}'),
                    FilledButton(
                      onPressed: () => (),
                      child: const Text('บันทึกข้อมูล'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<CustomerIdxGetResponse> loadDataAsync() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/customers/${widget.idx}'));
    log(res.body);
    customerIdxGetResponse = customerIdxGetResponseFromJson(res.body);
    return customerIdxGetResponse;
  }
}
