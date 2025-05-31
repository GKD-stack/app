import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/components/dot_indicators.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../repository/onboarding_repository.dart';
import '../auth/views/components/user_provider.dart';
import '../../services/classification.dart';

class FAQScreen extends StatefulWidget {
  final User user;
  const FAQScreen({super.key, required this.user});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _expandedFAQ;

  final List<Map<String, dynamic>> _faqCategories = [
    {
      'id': 'getting_started',
      'title': 'Getting Started',
      'icon': 'assets/icons/star.svg',
      'questions': [
        {
          'question': 'How does the app personalize content for me?',
          'answer':
              'After you complete our quick 2-minute onboarding questionnaire about your age, income, employment status, financial literacy level, and goals, our app creates a personalized learning path just for you. We push relevant lessons, articles, and tips based on your specific financial situation and objectives.'
        },
        {
          'question': 'Is this app really completely free?',
          'answer':
              'Yes! Our app is 100% free with no hidden costs, premium subscriptions, or in-app purchases. We believe financial education should be accessible to everyone, especially young women who are building their financial foundation.'
        },
        {
          'question': 'Do I need any financial knowledge to start?',
          'answer':
              'Not at all! Whether you\'re a complete beginner or have some financial knowledge, our app adapts to your level. We start with the basics and gradually introduce more advanced concepts as you progress.'
        }
      ]
    },
    {
      'id': 'learning_lessons',
      'title': 'Learning & Lessons',
      'icon': 'assets/icons/book.svg',
      'questions': [
        {
          'question': 'How are lessons delivered to me?',
          'answer':
              'Lessons are automatically pushed to your feed based on your personalized profile and learning progress. You\'ll receive bite-sized, digestible content that fits into your busy schedule - perfect for learning during commutes, lunch breaks, or whenever you have a few minutes.'
        },
        {
          'question': 'What topics do the lessons cover?',
          'answer':
              'Our lessons cover everything from budgeting basics and saving strategies to investing, credit building, debt management, career advancement, and long-term financial planning. We also include topics specifically relevant to young women, like salary negotiation and financial independence.'
        },
        {
          'question': 'Can I go back and review previous lessons?',
          'answer':
              'Absolutely! All lessons remain accessible in your learning library. You can revisit any content, bookmark important information, and track your progress through different financial topics.'
        },
        {
          'question': 'How long are the lessons?',
          'answer':
              'Most lessons are designed to be completed in 3-7 minutes, making them perfect for busy schedules. We focus on actionable, practical information you can immediately apply to your financial life.'
        }
      ]
    },
    {
      'id': 'news_updates',
      'title': 'News & Updates',
      'icon': 'assets/icons/news.svg',
      'questions': [
        {
          'question': 'How often is the financial news updated?',
          'answer':
              'Our news feed is updated continuously throughout the day with the latest financial news, market updates, and economic trends. We curate content that\'s relevant and easy to understand, filtering out the noise to bring you what matters most.'
        },
        {
          'question': 'Is the news content beginner-friendly?',
          'answer':
              'Yes! We translate complex financial news into clear, understandable language. Each news item includes context and explanations of how it might impact your personal finances, making it educational rather than overwhelming.'
        },
        {
          'question': 'Can I customize what type of news I see?',
          'answer':
              'The news feed adapts to your interests and financial goals. As you engage with different types of content, our algorithm learns your preferences and shows you more relevant financial news and market updates.'
        }
      ]
    },
    {
      'id': 'privacy_security',
      'title': 'Privacy & Security',
      'icon': 'assets/icons/shield.svg',
      'questions': [
        {
          'question': 'How is my personal information protected?',
          'answer':
              'We take your privacy seriously. All your data is encrypted and stored securely. We never sell your personal information to third parties, and we only use your data to personalize your learning experience within the app.'
        },
        {
          'question': 'What information do you collect during onboarding?',
          'answer':
              'We collect basic demographic information (age range), employment status, income range, financial literacy level, and your financial goals. This helps us tailor content specifically for your situation without requiring sensitive details like exact income or bank account information.'
        },
        {
          'question': 'Can I delete my account and data?',
          'answer':
              'Yes, you have full control over your data. You can delete your account and all associated data at any time through the app settings. We\'ll completely remove your information from our servers within 30 days.'
        }
      ]
    },
    {
      'id': 'community_support',
      'title': 'Community & Support',
      'icon': 'assets/icons/users.svg',
      'questions': [
        {
          'question': 'Is there a community feature?',
          'answer':
              'While we focus primarily on personalized learning, we\'re building community features that will allow you to connect with other young women on similar financial journeys. Stay tuned for updates on forums, study groups, and peer support features.'
        },
        {
          'question': 'How can I get help if I have questions?',
          'answer':
              'You can reach our support team directly through the app\'s help section. We typically respond within 24 hours. We also have an extensive help center with guides and tutorials for common questions.'
        },
        {
          'question': 'Can I suggest new features or content?',
          'answer':
              'Absolutely! We love hearing from our users. You can submit feature requests and content suggestions through the feedback section in the app. Many of our best features have come from user suggestions.'
        }
      ]
    },
    {
      'id': 'technical',
      'title': 'Technical',
      'icon': 'assets/icons/help.svg',
      'questions': [
        {
          'question': 'Which devices does the app work on?',
          'answer':
              'Our app works on both iOS and Android devices. We\'re also working on a web version for desktop access. The app is optimized for mobile use, making it easy to learn on-the-go.'
        },
        {
          'question': 'Do I need an internet connection to use the app?',
          'answer':
              'While you need an internet connection to receive new content and news updates, many lessons can be downloaded for offline reading. This means you can continue learning even when you don\'t have a stable connection.'
        },
        {
          'question': 'How much storage space does the app require?',
          'answer':
              'The app requires minimal storage space - typically less than 100MB. Downloaded content for offline reading may use additional space, but you can manage this in your settings.'
        }
      ]
    }
  ];

  void _toggleFAQ(String categoryId, int questionIndex) {
    final faqKey = '${categoryId}_$questionIndex';
    setState(() {
      _expandedFAQ = _expandedFAQ == faqKey ? null : faqKey;
    });
  }

  Widget _buildCategoryHeader(Map<String, dynamic> category) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            category['icon'],
            height: 24,
            width: 24,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Text(
            category['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTile(Map<String, dynamic> category, int index) {
    final question = category['questions'][index];
    final faqKey = '${category['id']}_$index';
    final isExpanded = _expandedFAQ == faqKey;

    return Column(
      children: [
        InkWell(
          onTap: () => _toggleFAQ(category['id'], index),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    question['question'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              question['answer'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        if (index < category['questions'].length - 1)
          Divider(
            height: 1,
            color: Colors.grey[200],
          ),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildCategoryHeader(category),
          ...List.generate(
            category['questions'].length,
            (index) => _buildQuestionTile(category, index),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.help_outline,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Frequently Asked Questions',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Everything you need to know about your personalized financial literacy journey',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Still have questions?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'We\'re here to help you on your financial journey. Don\'t hesitate to reach out!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle contact support
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening support chat...')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: const Color(0xFF8B5CF6),
              ),
              child: const Text(
                'Contact Support',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              ..._faqCategories.map((category) => _buildCategoryCard(category)),
              const SizedBox(height: 16),
              //_buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
