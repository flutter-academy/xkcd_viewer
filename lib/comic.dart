class Comic {
  Comic(this.href, this.pubDate, this.title);

  final String href;
  final String pubDate;
  final String title;
}

class ComicDetails {
  ComicDetails(this.title, this.imageUrl);

  final String title;
  final String imageUrl;
}
