import '../models/lesson_models.dart';

// The actual lesson data
final List<Lesson> financeFoundationsLessons = [
  // Lesson 1: First Day Paycheck Setup
  Lesson(
    id: "ff_001",
    title: "Your First Day Paycheck Setup",
    category: "Finance Foundations",
    description:
        "Navigate your first day at work and make smart paycheck decisions",
    image: "assets/images/office_setup.png",
    duration: "5 min",
    rating: 4.8,
    ratingCount: 234,
    xpReward: 150,
    difficultyLevel: 1,
    scenarios: [
      Scenario(
        id: "ff_001_s1",
        title: "HR Office Setup",
        context:
            "You're sitting in HR on your first day. Sarah from HR is explaining your paycheck options with forms spread across the desk. This is your chance to set yourself up for financial success from day one.",
        avatarImage: "assets/avatars/young_professional_office.png",
        backgroundImage: "assets/icons/cash.svg",
        choices: [
          ScenarioChoice(
            id: "choice_1a",
            text: "Set up direct deposit to my checking account",
            xpReward: 50,
            outcome:
                "Smart choice! Your money arrives faster and more securely.",
            explanation:
                "Direct deposit gets you paid 1-2 days earlier and eliminates the risk of lost checks.",
            isOptimal: true,
          ),
          ScenarioChoice(
            id: "choice_1b",
            text: "I'll take paper checks, I like having physical control",
            xpReward: 25,
            outcome:
                "You'll need to deposit checks manually and might face delays.",
            explanation:
                "Paper checks can be lost, stolen, or delayed. Direct deposit is safer and faster.",
            isOptimal: false,
          ),
        ],
        nextScenarioId: "ff_001_s2",
      ),
      Scenario(
        id: "ff_001_s2",
        title: "401k Decision",
        context:
            """HR mentions your company matches 3% of your salary in your 401k if you contribute 3%. On your \$35,000 salary, that's free money worth \$1,050 per year!""",
        avatarImage: "assets/avatars/young_professional_thinking.png",
        backgroundImage: "assets/icons/cash.svg",
        choices: [
          ScenarioChoice(
            id: "choice_2a",
            text: "Yes! Sign me up for the 3% match",
            xpReward: 75,
            outcome:
                "Excellent! You just secured \$1,050 in free money annually.",
            explanation:
                "Company 401k matches are literally free money. Always take the full match if you can afford it.",
            isOptimal: true,
          ),
          ScenarioChoice(
            id: "choice_2b",
            text: "I need every dollar right now, I'll skip it",
            xpReward: 25,
            outcome: "You're missing out on \$87.50 in free money every month.",
            explanation:
                "Even on a tight budget, try to contribute enough to get the company match. It's an instant 100% return.",
            isOptimal: false,
          ),
        ],
      ),
    ],
  ),

  // Lesson 2: Paycheck Reality Check
  Lesson(
    id: "ff_002",
    title: "Paycheck Reality Check",
    category: "Finance Foundations",
    description:
        "Understand why your paycheck is smaller than expected and plan accordingly",
    image: "assets/images/paycheck_surprise.png",
    duration: "6 min",
    rating: 4.6,
    ratingCount: 189,
    xpReward: 100,
    difficultyLevel: 1,
    prerequisiteId: "ff_001",
    scenarios: [
      Scenario(
        id: "ff_002_s1",
        title: "The Paycheck Shock",
        context:
            "Your first paycheck just hit your account. You expected about \$2,900 from your \$35k salary, but you only see \$2,100. You're staring at your phone in disbelief.",
        avatarImage: "assets/avatars/confused_phone_checking.png",
        backgroundImage: "assets/icons/cash.svg",
        choices: [
          ScenarioChoice(
            id: "choice_3a",
            text: "Review my paystub to understand all the deductions",
            xpReward: 50,
            outcome:
                "Good thinking! You see taxes, health insurance, and 401k contributions taken out.",
            explanation:
                "Understanding your paystub helps you plan better. Taxes, benefits, and retirement contributions all reduce take-home pay.",
            isOptimal: true,
          ),
          ScenarioChoice(
            id: "choice_3b",
            text: "Panic and assume there's an error - call HR immediately",
            xpReward: 20,
            outcome:
                "HR explains this is normal. You feel embarrassed for panicking.",
            explanation:
                "Paycheck deductions are normal. It's better to understand them first before assuming errors.",
            isOptimal: false,
          ),
        ],
        nextScenarioId: "ff_002_s2",
      ),
      Scenario(
        id: "ff_002_s2",
        title: "Budget Reality Adjustment",
        context:
            "Now you know your real take-home pay is \$2,100/month, not the \$2,900 you planned for. Your budget needs a major adjustment.",
        avatarImage: "assets/avatars/budget_planning.png",
        backgroundImage: "assets/icons/cash.svg",
        choices: [
          ScenarioChoice(
            id: "choice_4a",
            text: "Redo my budget with the real \$2,100 take-home amount",
            xpReward: 50,
            outcome: "Smart! Your new budget is realistic and achievable.",
            explanation:
                "Always budget with your actual take-home pay, not your gross salary.",
            isOptimal: true,
          ),
          ScenarioChoice(
            id: "choice_4b",
            text: "Keep my original budget and figure it out later",
            xpReward: 15,
            outcome:
                "You'll likely overspend and struggle to pay bills this way.",
            explanation:
                "Unrealistic budgets lead to financial stress. Always use your actual income.",
            isOptimal: false,
          ),
        ],
      ),
    ],
  ),

  // Lesson 3: The Spending Temptation
  Lesson(
    id: "ff_003",
    title: "The Spending Temptation",
    category: "Finance Foundations",
    description:
        "Learn to handle your first real paycheck responsibly while still enjoying life",
    image: "assets/images/shopping_temptation.png",
    duration: "7 min",
    rating: 4.7,
    ratingCount: 156,
    xpReward: 125,
    difficultyLevel: 2,
    prerequisiteId: "ff_002",
    scenarios: [
      Scenario(
        id: "ff_003_s1",
        title: "Friends Want to Celebrate",
        context:
            "Your friends want to celebrate your first 'real job' with an expensive dinner and night out. The total would be about \$150 - nearly 10% of your monthly budget.",
        avatarImage: "assets/avatars/friends_celebration.png",
        backgroundImage: "assets/icons/cash.svg",
        choices: [
          ScenarioChoice(
            id: "choice_5a",
            text: "Suggest a more budget-friendly celebration option",
            xpReward: 60,
            outcome:
                "Your friends understand and you have a great time for \$40 instead.",
            explanation:
                "Good friends will respect your budget. There are many ways to celebrate that don't break the bank.",
            isOptimal: true,
          ),
          ScenarioChoice(
            id: "choice_5b",
            text: "Go all out - I deserve this after getting hired!",
            xpReward: 20,
            outcome:
                "Fun night, but now you're stressed about money for the rest of the month.",
            explanation:
                "Occasional splurges are okay, but make sure they fit your budget to avoid financial stress.",
            isOptimal: false,
          ),
        ],
        nextScenarioId: "ff_003_s2",
      ),
      Scenario(
        id: "ff_003_s2",
        title: "The Online Shopping Cart",
        context:
            "You're browsing online and your cart has \$300 worth of clothes and gadgets you've wanted for months. Your finger hovers over 'Buy Now'.",
        avatarImage: "assets/avatars/online_shopping_decision.png",
        backgroundImage: "assets/icons/cash.svg",
        choices: [
          ScenarioChoice(
            id: "choice_6a",
            text: "Close the browser and create a wishlist for later",
            xpReward: 65,
            outcome:
                "Good restraint! You realize you didn't actually need most of those items.",
            explanation:
                "The 24-hour rule helps avoid impulse purchases. Most 'must-haves' aren't actually necessary.",
            isOptimal: true,
          ),
          ScenarioChoice(
            id: "choice_6b",
            text: "Buy just one small item (\$50) as a reward",
            xpReward: 35,
            outcome:
                "A reasonable compromise that satisfies your shopping urge without breaking the budget.",
            explanation:
                "Small, planned rewards can be part of a healthy budget if you account for them.",
            isOptimal: false,
          ),
          ScenarioChoice(
            id: "choice_6c",
            text: "Buy everything - I have income now!",
            xpReward: 10,
            outcome:
                "Your budget is blown and you feel guilty about the purchases.",
            explanation:
                "Having income doesn't mean spending it all. Budget for wants, but don't let them derail your finances.",
            isOptimal: false,
          ),
        ],
      ),
    ],
  ),

  // Lesson 4: Your First Budget
  Lesson(
    id: "ff_004",
    title: "Your First Budget",
    category: "Finance Foundations",
    description:
        "Create a realistic budget that actually works for your lifestyle and income",
    image: "assets/images/budget_creation.png",
    duration: "8 min",
    rating: 4.9,
    ratingCount: 278,
    xpReward: 200,
    difficultyLevel: 2,
    prerequisiteId: "ff_003",
    scenarios: [
      Scenario(
        id: "ff_004_s1",
        title: "Choosing Your Budget Method",
        context:
            "Rent is due in a week, and you need a system to manage your money. You have \$2,100 take-home pay and need to cover rent (\$800), utilities, food, and hopefully save something.",
        avatarImage: "assets/avatars/budget_planning_focused.png",
        backgroundImage: "assets/icons/cash.svg",
        choices: [
          ScenarioChoice(
            id: "choice_7a",
            text: "Use the 50/30/20 rule (Needs/Wants/Savings)",
            xpReward: 70,
            outcome:
                "Simple and effective! \$1,050 for needs, \$630 for wants, \$420 for savings.",
            explanation:
                "The 50/30/20 rule is perfect for beginners. It's simple to follow and ensures you save money.",
            isOptimal: true,
          ),
          ScenarioChoice(
            id: "choice_7b",
            text: "Track everything manually in a notebook",
            xpReward: 40,
            outcome:
                "Old school but works! You become very aware of every dollar spent.",
            explanation:
                "Manual tracking builds great awareness, but can be time-consuming. Consider apps for easier tracking.",
            isOptimal: false,
          ),
          ScenarioChoice(
            id: "choice_7c",
            text: "Wing it and just try not to overspend",
            xpReward: 10,
            outcome:
                "By week 3, you're scrambling to pay bills and have no idea where your money went.",
            explanation:
                "Without a plan, money disappears quickly. Even a simple budget is better than no budget.",
            isOptimal: false,
          ),
        ],
        nextScenarioId: "ff_004_s2",
      ),
      Scenario(
        id: "ff_004_s2",
        title: "The Irregular Expense Challenge",
        context:
            "Your budget is working great until your car registration (\$120) and annual software subscription (\$80) hit in the same month. You didn't plan for these!",
        avatarImage: "assets/avatars/unexpected_bills_stress.png",
        backgroundImage: "assets/icons/cash.svg",
        choices: [
          ScenarioChoice(
            id: "choice_8a",
            text: "Create a separate 'irregular expenses' fund going forward",
            xpReward: 60,
            outcome:
                "Brilliant! You start saving \$50/month for these predictable 'surprises'.",
            explanation:
                "Irregular expenses happen to everyone. Planning for them prevents budget emergencies.",
            isOptimal: true,
          ),
          ScenarioChoice(
            id: "choice_8b",
            text: "Use your emergency fund to cover these",
            xpReward: 30,
            outcome:
                "It works this time, but your emergency fund is now smaller.",
            explanation:
                "Emergency funds are for true emergencies. Regular irregular expenses need their own budget category.",
            isOptimal: false,
          ),
        ],
      ),
    ],
  ),

  // Lesson 5: The Emergency Fund Dilemma
  Lesson(
    id: "ff_005",
    title: "The Emergency Fund Dilemma",
    category: "Finance Foundations",
    description:
        "Learn why emergency funds are crucial through a real-world crisis scenario",
    image: "assets/images/emergency_fund.png",
    duration: "6 min",
    rating: 4.8,
    ratingCount: 203,
    xpReward: 150,
    difficultyLevel: 3,
    prerequisiteId: "ff_004",
    scenarios: [
      Scenario(
        id: "ff_005_s1",
        title: "Car Breakdown Crisis",
        context:
            "Your car won't start and you need it for work. The mechanic says it needs \$400 in repairs. You have \$150 in your checking account and no emergency fund yet.",
        avatarImage: "assets/avatars/car_breakdown_stress.png",
        backgroundImage: "assets/icons/cash.svg",
        choices: [
          ScenarioChoice(
            id: "choice_9a",
            text: "Put it on a credit card and pay it off over 3 months",
            xpReward: 40,
            outcome:
                "You get the repair but pay \$30 in interest. You resolve to build an emergency fund ASAP.",
            explanation:
                "Sometimes credit is necessary for emergencies, but having savings is much better than paying interest.",
            isOptimal: false,
          ),
          ScenarioChoice(
            id: "choice_9b",
            text: "Ask family/friends for a loan",
            xpReward: 35,
            outcome:
                "Your parents help out, but you feel bad about needing to ask.",
            explanation:
                "Family can be a good safety net, but financial independence feels better.",
            isOptimal: false,
          ),
          ScenarioChoice(
            id: "choice_9c",
            text: "Look for cheaper repair options and carpool temporarily",
            xpReward: 50,
            outcome:
                "You find a reliable mechanic who fixes it for \$250. You start emergency fund immediately.",
            explanation:
                "Creative problem-solving can reduce costs. Shopping around for services often saves money.",
            isOptimal: true,
          ),
        ],
        nextScenarioId: "ff_005_s2",
      ),
      Scenario(
        id: "ff_005_s2",
        title: "Building Your Safety Net",
        context:
            "After the car scare, you're committed to building an emergency fund. You have \$200/month you could potentially save, but it means cutting back on fun activities.",
        avatarImage: "assets/avatars/savings_planning.png",
        backgroundImage: "assets/icons/cash.svg",
        choices: [
          ScenarioChoice(
            id: "choice_10a",
            text: "Save \$100/month for emergency fund, \$100 for other goals",
            xpReward: 60,
            outcome:
                "Balanced approach! You'll have \$1,000 emergency fund in 10 months.",
            explanation:
                "Starting with a smaller emergency fund while maintaining other goals creates sustainable habits.",
            isOptimal: true,
          ),
          ScenarioChoice(
            id: "choice_10b",
            text: "Go extreme: save \$200/month until I have \$1,000",
            xpReward: 40,
            outcome:
                "You'll be fully protected in 5 months, but it's tough to maintain this pace.",
            explanation:
                "Aggressive saving works if you can stick to it, but balance helps create lasting habits.",
            isOptimal: false,
          ),
          ScenarioChoice(
            id: "choice_10c",
            text:
                "Start with just \$25/month - something is better than nothing",
            xpReward: 30,
            outcome:
                "It's a start, but at this rate it'll take 3+ years to build adequate emergency savings.",
            explanation:
                "Small amounts are better than nothing, but try to save more as you get comfortable with budgeting.",
            isOptimal: false,
          ),
        ],
      ),
    ],
  ),
];
