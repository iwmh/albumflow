import 'package:dio/dio.dart';

/// Spotify のページング（`next` が `null` になるまで）を辿り、
/// 全ページの `items` を結合して返す。
///
/// `next` は絶対 URL のため、2 ページ目以降は baseUrl を無視して直接取得する。
Future<List<Map<String, dynamic>>> fetchAllItems(
  Dio dio,
  String path, {
  Map<String, dynamic>? queryParameters,
}) async {
  final items = <Map<String, dynamic>>[];
  var url = path;
  var query = queryParameters;

  while (true) {
    final response = await dio.get<Map<String, dynamic>>(
      url,
      queryParameters: query,
    );
    final data = response.data ?? const <String, dynamic>{};
    final pageItems = (data['items'] as List<dynamic>? ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    items.addAll(pageItems);

    final next = data['next'] as String?;
    if (next == null) break;
    url = next;
    query = null; // `next` にクエリが含まれるため以降は付与しない。
  }
  return items;
}
