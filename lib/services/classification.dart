enum FinancialCategory {
  foundations,
  debtRecovery,
  moneyManagement,
  investingBasics,
  wealthBuilding,
}

class FinancialCategoryInfo {
  final FinancialCategory category;
  final String title;
  final String emoji;
  final String description;
  final List<String> content;

  const FinancialCategoryInfo({
    required this.category,
    required this.title,
    required this.emoji,
    required this.description,
    required this.content,
  });
}

class ClassificationService {
  static const Map<FinancialCategory, FinancialCategoryInfo> _categoryInfo = {
    FinancialCategory.foundations: FinancialCategoryInfo(
      category: FinancialCategory.foundations,
      title: 'Foundations',
      emoji: '🧱',
      description: 'For beginners with low financial literacy',
      content: [
        'What is a budget?',
        'Needs vs wants',
        'Intro to saving and checking accounts',
        'Credit score basics'
      ],
    ),
    FinancialCategory.debtRecovery: FinancialCategoryInfo(
      category: FinancialCategory.debtRecovery,
      title: 'Debt Recovery',
      emoji: '💸',
      description: 'For users with low income or who selected "Pay off debt"',
      content: [
        'How to make a debt plan',
        'Credit card vs student loan debt',
        'Understanding interest',
        'Tools for debt tracking'
      ],
    ),
    FinancialCategory.moneyManagement: FinancialCategoryInfo(
      category: FinancialCategory.moneyManagement,
      title: 'Money Management',
      emoji: '💼',
      description: 'For users with moderate literacy but no investing goals',
      content: [
        'Budgeting apps',
        'Emergency fund planning',
        'Taxes 101',
        'Retirement accounts (IRA, 401k)'
      ],
    ),
    FinancialCategory.investingBasics: FinancialCategoryInfo(
      category: FinancialCategory.investingBasics,
      title: 'Investing Basics',
      emoji: '📈',
      description: 'For users ready to build wealth',
      content: [
        'Stock market 101',
        'Risk vs return',
        'Compound interest',
        'How to open a brokerage'
      ],
    ),
    FinancialCategory.wealthBuilding: FinancialCategoryInfo(
      category: FinancialCategory.wealthBuilding,
      title: 'Wealth Building / Retirement',
      emoji: '👵',
      description: 'For older users or those with higher income',
      content: [
        'Maximizing retirement savings',
        'Passive income ideas',
        'Real estate investing',
        'Tax optimization'
      ],
    ),
  };

  /// Classifies a user based on their financial information
  static FinancialCategory classifyUser({
    required String? ageGroup,
    required String? annualIncome,
    required String? financialLiteracyLevel,
    required List<String> financialGoals,
  }) {
    // Priority 1: Wealth Building / Retirement
    // Trigger if: Age = "45–60" or "60+" OR Income > "$150k"
    if (_isOlderUser(ageGroup) || _isHighIncome(annualIncome)) {
      return FinancialCategory.wealthBuilding;
    }

    // Priority 2: Investing Basics
    // Trigger if: Goal = "Invest" OR Literacy = "Advanced"
    if (financialGoals.contains('Invest') ||
        financialLiteracyLevel == 'Advanced') {
      return FinancialCategory.investingBasics;
    }

    // Priority 3: Debt Recovery
    // Trigger if: Income = "< $50k" OR goal = "Pay off debt"
    if (_isLowIncome(annualIncome) || financialGoals.contains('Pay off debt')) {
      return FinancialCategory.debtRecovery;
    }

    // Priority 4: Money Management
    // Trigger if: Literacy = "Intermediate" AND no investing goal
    if (financialLiteracyLevel == 'Intermediate' &&
        !financialGoals.contains('Invest')) {
      return FinancialCategory.moneyManagement;
    }

    // Default: Foundations
    // Trigger if: Literacy = "Beginner" or none of the above conditions are met
    return FinancialCategory.foundations;
  }

  /// Gets the category information for a given category
  static FinancialCategoryInfo getCategoryInfo(FinancialCategory category) {
    return _categoryInfo[category]!;
  }

  /// Gets all available categories with their information
  static Map<FinancialCategory, FinancialCategoryInfo> getAllCategories() {
    return Map.from(_categoryInfo);
  }

  // Helper methods for classification logic
  static bool _isOlderUser(String? ageGroup) {
    return ageGroup == '45–60' || ageGroup == '60+';
  }

  static bool _isHighIncome(String? annualIncome) {
    if (annualIncome == null) return false;

    // Income > $150k includes: $150k–$200k, $200k–$250k, $300k–$350k, >$350k
    return annualIncome == '\$150k–\$200k' ||
        annualIncome == '\$200k–\$250k' ||
        annualIncome == '\$300k–\$350k' ||
        annualIncome == '>\$350k';
  }

  static bool _isLowIncome(String? annualIncome) {
    if (annualIncome == null) return false;

    // Income < $50k includes: < $25k, $25k–$50k
    return annualIncome == '< \$25k' || annualIncome == '\$25k–\$50k';
  }

  /// Convenience method to classify and get category info in one call
  static FinancialCategoryInfo classifyAndGetInfo({
    required String? ageGroup,
    required String? annualIncome,
    required String? financialLiteracyLevel,
    required List<String> financialGoals,
  }) {
    final category = classifyUser(
      ageGroup: ageGroup,
      annualIncome: annualIncome,
      financialLiteracyLevel: financialLiteracyLevel,
      financialGoals: financialGoals,
    );
    return getCategoryInfo(category);
  }
}
