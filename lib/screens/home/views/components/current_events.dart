import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

// Define constant to replace the imported one
//const double defaultPadding = 16.0;

class CurrentEvents extends StatelessWidget {
  const CurrentEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Financial News & Updates",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("View All"),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 280,
          child: CurrentEventsCarousel(),
        ),
      ],
    );
  }
}

class CurrentEventsCarousel extends StatelessWidget {
  const CurrentEventsCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample financial news articles
    final List<Map<String, dynamic>> demoArticles = [
      {
        "title": "Fed Interest Rate Decision: What It Means for Your Wallet",
        "source": "Finance Today",
        "date": "April 28, 2025",
        "image": "assets/images/fed_rate.jpg",
        "readTime": "5 min read",
      },
      {
        "title": "New Tax Credits Available for Homeowners",
        "source": "The Fiscal Times",
        "date": "April 25, 2025",
        "image": "assets/images/fed_rate.jpg",
        "readTime": "8 min read",
      },
      {
        "title": "Savings Accounts with Best Rates in 2025",
        "source": "Money Matters",
        "date": "April 22, 2025",
        "image": "assets/images/savings_rates.jpg",
        "readTime": "4 min read",
      },
      {
        "title": "Understanding the Impact of Global Economic Trends",
        "source": "Global Economics",
        "date": "April 20, 2025",
        "image": "assets/images/fed_rate.jpg",
        "readTime": "10 min read",
      },
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: demoArticles.length,
      itemBuilder: (context, index) {
        final article = demoArticles[index];
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? defaultPadding : defaultPadding / 2,
            right: index == demoArticles.length - 1
                ? defaultPadding
                : defaultPadding / 2,
          ),
          child: ArticleCard(
            title: article["title"],
            source: article["source"],
            date: article["date"],
            image: article["image"],
            readTime: article["readTime"],
            onTap: () {
              Navigator.pushNamed(context, 'articleDetailScreenRoute');
            },
          ),
        );
      },
    );
  }
}

class ArticleCard extends StatelessWidget {
  final String title;
  final String source;
  final String date;
  final String image;
  final String readTime;
  final VoidCallback onTap;

  const ArticleCard({
    Key? key,
    required this.title,
    required this.source,
    required this.date,
    required this.image,
    required this.readTime,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(
                image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                // Use a placeholder for demo
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey.shade300,
                    child: Center(
                      child: Icon(
                        Icons.article,
                        size: 40,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // Source and Date
                  Row(
                    children: [
                      Text(
                        source,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: defaultPadding / 2),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  // Read Time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: defaultPadding / 4),
                      Text(
                        readTime,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoreArticles extends StatelessWidget {
  const MoreArticles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample more financial news articles
    final List<Map<String, dynamic>> moreArticles = [
      {
        "title": "Dividing Up Finances In a Serious Relationship",
        "source": "Investment Weekly",
        "date": "April 29, 2025",
        "image": "assets/images/fed_rate.jpg",
        "readTime": "7 min read",
      },
      {
        "title": "How Fashion Brands Are Adapting to Inflation",
        "source": "Digital Finance",
        "date": "April 27, 2025",
        "image": "assets/images/crypto_regulations.jpg",
        "readTime": "6 min read",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Culture & Lifestyle",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("View All"),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: moreArticles.length,
          itemBuilder: (context, index) {
            final article = moreArticles[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding / 2,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'articleDetailScreenRoute');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        article["image"],
                        width: 100,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 80,
                            color: Colors.grey.shade300,
                            child: Center(
                              child: Icon(
                                Icons.article,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    // Article details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article["title"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: defaultPadding / 2),
                          Row(
                            children: [
                              Text(
                                article["source"],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(width: defaultPadding / 2),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: defaultPadding / 2),
                              Text(
                                article["date"],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: defaultPadding / 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: defaultPadding / 4),
                              Text(
                                article["readTime"],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
