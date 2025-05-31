import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../banner_discount_tag.dart';
import '../../../constants.dart';

class BannerSStyle1 extends StatelessWidget {
  const BannerSStyle1({
    super.key,
    required this.title,
    this.subtitle,
    required this.discountParcent,
  });

  final String title;
  final String? subtitle;
  final int discountParcent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: grandisExtendedFont,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  if (subtitle != null)
                    Text(
                      subtitle!.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: defaultPadding),
            // Decorative icon (not clickable). Remove if you don't want it.
            SizedBox(
              height: 48,
              width: 48,
              child: SvgPicture.asset(
                "assets/icons/Arrow - Right.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
      // Uncomment if you want the discount tag:
      // Stack(
      //   children: [
      //     // Your existing content above
      //     Align(
      //       alignment: Alignment.topCenter,
      //       child: BannerDiscountTag(
      //         percentage: discountParcent,
      //         height: 56,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
