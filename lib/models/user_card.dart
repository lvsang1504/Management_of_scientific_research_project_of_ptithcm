
class CardModel {
  String imagePath, followers, posts, following, name, location;
  bool isFollow;

  CardModel(
    this.imagePath,
    this.followers,
    this.posts,
    this.following,
    this.name,
    this.location,
    this.isFollow,
  );
}

final List<CardModel> cards = [
    CardModel(
      'assets/images/research-techniques.jpg',
      '869',
      '135',
      '437',
      'Aliya Zamarina',
      'Nantes, France',
      false,
    ),
    CardModel(
      'assets/images/research-techniques.jpg',
      '1,5K',
      '720',
      '369',
      'Emily Burton',
      'Paris, France',
      false,
    ),
    CardModel(
      'assets/images/research-techniques.jpg',
      '559',
      '312',
      '407',
      'Jane Doe',
      'Lyon, France',
      true,
    ),
    CardModel(
      'assets/images/research-techniques.jpg',
      '607',
      '481',
      '651',
      'Xeyna Dalamar',
      'Perpignan, France',
      false,
    ),
    CardModel(
      'assets/images/research-techniques.jpg',
      '869',
      '135',
      '437',
      'Cleopatra Davis',
      'Villeurbanne, France',
      true,
    ),
    CardModel(
      'assets/images/research-techniques.jpg',
      '1,5K',
      '720',
      '369',
      'Leila Russo',
      'Lyon, France',
      false,
    ),
  ];