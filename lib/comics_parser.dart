import 'dart:async';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xkcd_viewer/comic.dart';

class ComicsParser {
  static Future<List<Comic>> getComics() async {
    const url = 'https://xkcd.com/archive/';
    var content = await http.get(url).then((response) => response.body);
    return parse(content)
        .querySelectorAll('#middleContainer a')
        .map((element) => new Comic(element.attributes['href'],
            element.attributes['title'], element.text))
        .toList();
  }

  static Future<ComicDetails> getComicDetails(Comic comic) async {
    var url = 'https://xkcd.com${comic.href}info.0.json';
    return await http.get(url).then((response) {
      var data = json.decode(response.body);
      return ComicDetails(data['title'], data['img']);
    });
  }
}
