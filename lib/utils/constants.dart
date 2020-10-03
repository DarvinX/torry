final List<String> url = [
  'https://pirateproxy.ink',
  'https://proxybay.tech',
  'https://tpb-proxy.net',
  'https://tpbunblocked.net',
  'https://piratebays.biz',
  'https://thepiratebay2.net',
  'https://ahoyahoy.co',
  'https://lepiratebay.org',
  'https://indiapirate.org',
  'https://tpb.world',
  'https://tpbproxy.vip',
  'https://tpb.icu'
];

final int nRetry = 3;

final String saviorLink = 'https://google.com';

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

final List<String> testDeviceId = []; //['BFE0EFAC538B3BA6C9B605707370E14F'];
final String TorryLink =
    'https://play.google.com/store/apps/details?id=com.darvin.Torry';
final String shareText =
    'Love Movies, Web Series or Games ?\nNow search and download torrents with ease.\n\n$TorryLink';

final String appPackageName = 'com.utorrent.client&hl=en';
final String appLink = 'market://details?id=' + appPackageName;

String launchId = "";

final dummyMagLink =
    "magnet:?xt=urn:btih:dbf21fc9a28d7c292b5cd9462683a1e150d4e0e3&dn=John.Wick.3.2019.HDRip.XviD.AC3-EVO&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80&tr=udp%3A%2F%2Fopen.demonii.com%3A1337&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Fexodus.desync.com%3A6969";
