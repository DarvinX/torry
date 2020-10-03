final int nRetry = 3;

final String mailUs = 'mailto:Torrywithease@gmail.com?subject=Torry Feedback';

final List<String> categories = [
  'Movies',
  'TV Shows',
  'Comics',
  'Audio Books',
  'PC Games',
  'Ebooks'
];

final Map<String, String> categoryMap = {
  'Default': '0',
  'Audio': '100',
  'Video': '200',
  'Software': '300',
  'Game': '400',
  'Others': '600'
};

String getAPIUrl(String text) {
  text = text.replaceAll(RegExp(r' '), '+');
  return "https://cors-anywhere.herokuapp.com/http://suggestqueries.google.com/complete/search?output=toolbar&q=$text&hl=en";
}

final List<String> sortByList = [
  'Default',
  'Recent',
  'Old',
  'Size: ▲',
  'Size: ▼',
  'Seeds: ▼',
  'Leechs: ▲',
  'Leechs: ▼'
];

final List<String> searchTypeList = [
  'Default',
  'Video',
  'Audio',
  'Software',
  'Game',
  'Other'
];

final String appPackageName = 'com.utorrent.client&hl=en';
final String appLink = 'market://details?id=' + appPackageName;

String launchId = "";

final dummyMagLink =
    "magnet:?xt=urn:btih:dbf21fc9a28d7c292b5cd9462683a1e150d4e0e3&dn=John.Wick.3.2019.HDRip.XviD.AC3-EVO&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80&tr=udp%3A%2F%2Fopen.demonii.com%3A1337&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Fexodus.desync.com%3A6969";
