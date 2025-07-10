import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

import '../../../util/images.dart';

class AppAdvertising extends StatelessWidget {
  const AppAdvertising({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Row(
        children: [
          // Safe Trips Section
          Expanded(
            child: Container(
              height: 140,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).cardColor,
                    Theme.of(context).cardColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).hintColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Privacy Policy Icon
                  Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).hintColor.withOpacity(0.15),
                          Theme.of(context).hintColor.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Image.asset(
                      Images.shieldIcon,
                      color: Theme.of(context).primaryColor,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 1),

                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title Text
                        Text(
                          'Safety and comfort',
                          style: textBold.copyWith(
                            fontSize: 13,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Subtitle Text
                        Text(
                          'Driven by Safty, Powered by Trust.',
                          style: textSemiBold.copyWith(
                            fontSize: 10,
                            color: Theme.of(context).hintColor,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Discounts Section
          Expanded(
            child: Container(
              height: 140,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).hintColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Discount Icon
                  Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.15) ??
                              Colors.grey.withOpacity(0.15),
                          Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.08) ??
                              Colors.grey.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.2) ??
                            Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Image.asset(
                      Images.discountCopoun,
                      color: Theme.of(context).primaryColor,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 1),

                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title Text

                        const SizedBox(height: 2),

                        // Subtitle Text
                        Text(
                          'Nonstop Offers',
                          style: textSemiBold.copyWith(
                            fontSize: 13,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Description
                        Flexible(
                          child: Text(
                            'Unlock exclusive coupones every month - only on Drivo',
                            style: textRegular.copyWith(
                              fontSize: 10,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.6),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
