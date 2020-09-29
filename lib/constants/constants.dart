final List<String> url = [
  'https://proxybay.tech',
  'https://uspirateproxy.com',
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

final mainBannerAdId = 'ca-app-pub-7242673405641060/8876341412';
final interstitialAdId = 'ca-app-pub-7242673405641060/6256318440';
final bookmarkInterstitialAdId = 'ca-app-pub-7242673405641060/5623917142';
final searchButtonAdId = 'ca-app-pub-7242673405641060/3673800408';
final appId = 'ca-app-pub-7242673405641060~2934529842';
final String saviorLink =
    'https://play.google.com/store/apps/details?id=com.darvin.whatsapp_savior';
final String mailUs =
    'mailto:torrywithease@gmail.com?subject=Torry Feedback';

final List<String> categories = [
  'Movies',
  'TV Shows',
  'Comics',
  'Audio Books',
  'PC Games',
  'Ebooks'
];

final Map<String, String> categoryMap = {
  'Movies': '/top/201',
  'TV Shows': '/top/205',
  'Comics': '/top/602',
  'Audio Books': '/top/102',
  'PC Games': '/top/401',
  'Ebooks': '/top/601'
};

String getAPIUrl(String text) {
  text = text.replaceAll(RegExp(r' '), '+');
  return "http://suggestqueries.google.com/complete/search?output=toolbar&q=$text&hl=en";
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
final String torryLink =
    'https://play.google.com/store/apps/details?id=com.darvin.torry';
final String shareText =
    'Love Movies, Web Series or Games ?\nNow search and download torrents with ease.\n\n$torryLink';

final List<String> keyWords = [
  'movie',
  'web series',
  'tv shows',
  'hindi movies',
  'hollywood',
  'bollywood',
  'amazon prime',
  'netflix',
  'hoichoi',
  'ALTBalaji',
  'tollywood',
  'songs',
  'hindi songs',
];

final dummyMagLink =
    "magnet:?xt=urn:btih:dbf21fc9a28d7c292b5cd9462683a1e150d4e0e3&dn=John.Wick.3.2019.HDRip.XviD.AC3-EVO&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80&tr=udp%3A%2F%2Fopen.demonii.com%3A1337&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Fexodus.desync.com%3A6969";
