import 'package:flutter_dotenv/flutter_dotenv.dart';

var url = dotenv.env["API_CAKRAWALA"];
var http = dotenv.env["HTTP_CAKRAWALA"];
var dummy = dotenv.env["DUMMY_CAKRAWALA"];

Future<void> envSetup() async {
  await dotenv.load(fileName: ".env");
}
