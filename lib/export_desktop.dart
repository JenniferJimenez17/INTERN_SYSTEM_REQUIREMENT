import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> downloadFile(List<int> bytes, String fileName) async {
  final directory = await getDownloadsDirectory();

  if (directory == null) {
    throw Exception("Could not access Downloads directory");
  }

  final file = File('${directory.path}/$fileName');
  await file.writeAsBytes(bytes);

  print("File saved at: ${file.path}");
}
