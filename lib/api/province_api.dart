import 'dart:convert';

import 'package:eRoomApp/models/province.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProvinceApi {
  static Future<List<Province>> getProvinces(String provinceName) async {
    List<Province> countries = [];
    final data = await getFileData('assets/res/za.json');
    final parsedJson = jsonDecode(data);

    final zas = parsedJson != null
        ? parsedJson.map((zas) => Province.fromJson(zas)).toList()
        : <Province>[];

    for (Province province in zas) {
      if (province.adminName!.contains(provinceName)) {
        countries.add(province);
      }
    }
    return countries;
  }

  static Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }
}
