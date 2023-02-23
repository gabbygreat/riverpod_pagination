import 'package:dio/dio.dart';

import 'model.dart';

Future<List<Map<String, dynamic>>> getVideos(PaginationModel pagination) async {
  int size = 20;

  final String url =
      'https://api.instantwebtools.net/v1/passenger?page=${pagination.page}&size=$size';

  final Dio dio = Dio();
  final response = await dio.get(url);
  pagination.total = response.data['totalPages'] as int;
  pagination.page++;
  return (response.data['data'] as List)
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
}
