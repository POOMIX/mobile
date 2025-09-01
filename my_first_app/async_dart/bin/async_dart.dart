import 'package:http/http.dart' as http;

Future<void> main(List<String> arguments) async {
  print('AAA');
  try {
    var value = await http.get(
      Uri.parse('http://202.28.34.197/tripbooking/trip/15'),
    );
    print(value.body);
  } catch (e) {
    print(e);
  }
  print('CCC');
}

Future<void> testAsync() {
  return Future.delayed(const Duration(seconds: 2), () => print("BBB"));
}
