import "package:test/test.dart";
import 'package:xkcd_viewer/comics_parser.dart';

void main() {
  test('parser', () async {
    var results = await ComicsParser.getComics();
    expect(results.length, greaterThan(10));
  });
}
