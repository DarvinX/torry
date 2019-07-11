final List<String> url = [
  'https://bea247.in/',
  'https://blueunblocked.club/',
  'https://ikwilthepiratebaytpb.rocks/',
  'https://beatpb.club/',
  'https://baybea.net/'
];

final List<String> categories = [
  'Movies',
  'TV Shows',
  'Comics',
  'Audio Books',
  'PC Games',
  'Ebooks'
];

final Map<String, String> categoryMap = {
  'Movies': 'top/201',
  'TV Shows': 'top/205',
  'Comics': 'top/602',
  'Audio Books': 'top/102',
  'PC Games': 'top/401',
  'Ebooks': 'top/601'
};

String getAPIUrl(String text){
  text = text.replaceAll(RegExp(r' '), '+');
  return "http://suggestqueries.google.com/complete/search?output=toolbar&q=$text&hl=en";
}

