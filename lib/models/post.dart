class Post {
  final int? id;
  final double? price;
  final String? title;
  final String? description;
  final bool? status;

  Post({this.id, this.price, this.title, this.description, this.status});
}

final Post post1 = Post(
  id: 1,
  price: 29000,
  title: 'Incredible room a ',
  description: 'A stylish great room suitable for a stylish',
  status: true, // true == approved & false == panding
);

final Post post2 = Post(
  id: 2,
  price: 29003,
  title: 'Spacious large Cottage',
  description: 'A fantastc spacious cottage located in a',
  status: false, // true == approved & false == panding
);

final Post post3 = Post(
  id: 3,
  price: 29400,
  title: 'Awesome cottage',
  description: 'Giant awesome cottage for your comfort',
  status: true, // true == approved & false == panding
);

List<Post> posts = [post1, post2, post3];
