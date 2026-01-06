class Architect {
  final String id;
  final String name;
  final String expertise;
  final double rating;
  final int projectsCompleted;
  final String imageUrl;
  final int startingPrice;
  final String description;
  final List<String> portfolioImages;

  Architect({
    required this.id,
    required this.name,
    required this.expertise,
    required this.rating,
    required this.projectsCompleted,
    required this.imageUrl,
    required this.startingPrice,
    required this.description,
    required this.portfolioImages,
  });
}
