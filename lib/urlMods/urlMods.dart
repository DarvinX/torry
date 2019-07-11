String getDecodedUrl(String sortBy, String searchType, String searchTerm) {
  String sortCode;
  String typeCode;

  searchTerm = searchTerm.replaceAll(RegExp(r' '), '%20');

  switch (sortBy) {
    case 'Recent':
      sortCode = '3';
      break;

    case 'Old':
      sortCode = '4';
      break;

    case 'Size: ▼':
      sortCode = '5';
      break;

    case 'Size: ▲':
      sortCode = '6';
      break;

    case 'Seeds: ▼':
      sortCode = '7';
      break;

    case 'Leechs: ▲':
      sortCode = '10';
      break;

    case 'Leechs: ▼':
      sortCode = '9';
      break;

    default:
      sortCode = '0';
  }

  switch(searchType){
    case 'Video':
      typeCode = '200';
      break;
    case 'Audio':
      typeCode = '100';
      break;
    case 'Software':
      typeCode = '300';
      break;
    case 'Game':
      typeCode = '400';
      break;
    case 'Other':
      typeCode = '600';
      break;

    default:
      typeCode = '0';
  }

  return '/search/$searchTerm/0/$sortCode/$typeCode';
}
