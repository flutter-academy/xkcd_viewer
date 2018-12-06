import 'dart:async';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xkcd_viewer/comic.dart';

class ComicsParser {
  Future<List<Comic>> getComics() async {
    const url = 'https://xkcd.com/archive/';
    var content = await http.get(url).then((response) => response.body);
    return parse(content)
        .querySelectorAll('#middleContainer a')
        .map((element) => new Comic(element.attributes['href'],
            element.attributes['title'], element.text))
        .toList();
  }

  Future<ComicDetails> getComicDetails(String comicHref) async {
    var url = 'https://xkcd.com${comicHref}info.0.json';
    return await http.get(url).then((response) {
      var data = json.decode(response.body);
      return ComicDetails(data['title'], data['img']);
    });
  }
}
