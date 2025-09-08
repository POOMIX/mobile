import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/response/customer_idx_get_res.dart';

class ProfilePage extends StatefulWidget {
  final int idx;
  const ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<CustomerIdxGetResponse> loadData;
  late CustomerIdxGetResponse customerIdxGetResponse;

  // controller สำหรับฟิลด์
  final fullnameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CustomerIdxGetResponse>(
      future: loadData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(title: const Text('ข้อมูลส่วนตัว')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar กลางจอ
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(customerIdxGetResponse.image),
                ),
                const SizedBox(height: 20),

                // Fullname
                TextFormField(
                  controller: fullnameController,
                  decoration: const InputDecoration(
                    labelText: "ชื่อ-นามสกุล",
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Phone
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: "หมายเลขโทรศัพท์",
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Email
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "อีเมล์",
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Image link
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: "รูปภาพ",
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                // ปุ่มบันทึก
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      // TODO: save logic
                      log("บันทึกข้อมูลแล้ว");
                    },
                    child: const Text("บันทึกข้อมูล"),
                  ),
                ),
              ],
            ),
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

    // set ค่าเริ่มต้นใน controller
    fullnameController.text = customerIdxGetResponse.fullname;
    phoneController.text = customerIdxGetResponse.phone;
    emailController.text = customerIdxGetResponse.email;
    imageController.text = customerIdxGetResponse.image;

    return customerIdxGetResponse;
  }
}
