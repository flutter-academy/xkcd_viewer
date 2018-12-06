import "package:test/test.dart";
import 'package:xkcd_viewer/comics_parser.dart';

void main() {
  test('parser', () async {
    var parser = new ComicsParser();
    var results = await parser.getComics();
    expect(results.length, greaterThan(10));
  });
}
