import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/home/widgets/voice_search_dialog.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/set_destination/screens/set_destination_screen.dart';

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => Get.to(() => const SetDestinationScreen()),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 14,
              right: 14,
              top: 37,
              bottom: 20,
            ),
            child: Container(
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .buttonTheme
                    .colorScheme
                    ?.secondaryFixedDim, // Light grey color
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  // Search icon
                  IconButton(
                      color: Theme.of(context).hintColor,
                      onPressed: () =>
                          Get.to(() => const SetDestinationScreen()),
                      icon: Icon(Icons.search, color: Colors.black, size: 25)),
                  const SizedBox(width: 8),

                  // Hint text
                  Expanded(
                    child: Text(
                      'where_to_go'.tr,
                      style: textRegular.copyWith(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Voice search icon (if you want to add it back)
                  // IconButton(
                  //   color: Theme.of(context).hintColor,
                  //   onPressed: () {
                  //     Get.dialog(const VoiceSearchDialog(), barrierDismissible: false);
                  //   },
                  //   icon: Icon(Icons.mic, color: Colors.black, size: 25),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}
