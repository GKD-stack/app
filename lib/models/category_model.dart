class CategoryModel {
  final String title;
  final String? image, svgSrc;
  final List<CategoryModel>? subCategories;

  CategoryModel({
    required this.title,
    this.image,
    this.svgSrc,
    this.subCategories,
  });
}

final List<CategoryModel> demoCategoriesWithImage = [
  CategoryModel(title: "Saving", image: "https://i.imgur.com/5M89G2P.png"),
  CategoryModel(title: "Debt", image: "https://i.imgur.com/UM3GdWg.png"),
  CategoryModel(title: "Investing", image: "https://i.imgur.com/Lp0D6k5.png"),
];

final List<CategoryModel> demoCategories = [
  CategoryModel(
    title: "Saving",
    svgSrc: "assets/icons/saving.svg",
    subCategories: [
      CategoryModel(title: "All"),
      CategoryModel(title: "Beginner"),
      CategoryModel(title: "Intermediate"),
      CategoryModel(title: "Advanced"),
    ],
  ),
  CategoryModel(
    title: "Debt",
    svgSrc: "assets/icons/debt.svg",
    subCategories: [
      CategoryModel(title: "All"),
      CategoryModel(title: "Beginner"),
      CategoryModel(title: "Intermediate"),
      CategoryModel(title: "Advanced"),
    ],
  ),
  CategoryModel(
    title: "Investing",
    svgSrc: "assets/icons/investing.svg",
    subCategories: [
      CategoryModel(title: "All"),
      CategoryModel(title: "Beginner"),
      CategoryModel(title: "Intermediate"),
      CategoryModel(title: "Advanced"),
    ],
  ),
];
