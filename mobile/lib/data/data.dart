class InitData {
  const InitData({
    required this.words,
    required this.desc,
    required this.imagepath,
  });
  final String words;
  final String desc;
  final String imagepath;
}

const List<InitData> appInitData = [
  InitData(
      words: 'Neat quality electonics',
      desc: 'Neat quality\nelectonics',
      imagepath: 'assets/images/image-1.jpg'),
  InitData(
      words: 'Stunning Iphones?',
      desc: 'For all your\nSmartphones and accessories',
      imagepath: 'assets/images/image-2.jpg'),
  InitData(
      words: 'Laptops for gaming or work?',
      desc: 'We got You covered\nfor all sorts of laptops and desktops',
      imagepath: 'assets/images/image-3.jpg'),
  InitData(
      words: 'Accessories? any kind?',
      desc: 'We got You covered\nall kinds of quality accessories',
      imagepath: 'assets/images/image-5.jpg'),
];
