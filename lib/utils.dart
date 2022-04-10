import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';

class Utils {
  static StreamTransformer transformer<T>(
          T Function(Map<String, dynamic> json) fromJson) =>
      StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
        handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
          final snaps = data.docs.map((doc) => doc.data()).toList();
          debugPrint(snaps.toString());
          //final snaps = data.documents.map((doc) => doc.data()).toList();

          //final users = snaps.map((json) => fromJson(json)).toList();

          //sink.add(users);
        },
      );

  static DateTime? toDateTime(Timestamp value) {
    try {
      return value.toDate();
    } catch (_) {
      return null;
    }
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    // ignore: unnecessary_null_comparison
    if (date == null) return null;

    return date.toUtc();
  }
}
