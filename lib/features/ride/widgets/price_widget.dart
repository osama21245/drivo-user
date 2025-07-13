import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class PriceWidget extends StatefulWidget {
  const PriceWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PriceWidgetState createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<PriceWidget>
    with SingleTickerProviderStateMixin {
  String? lastFromAddress;
  String? lastToAddress;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(
      builder: (rideController) {
        return GetBuilder<LocationController>(
          builder: (locationController) {
            // Get location data
            final fromAddress = locationController.fromAddress?.address;
            final toAddress = locationController.toAddress?.address;
            final fromText = locationController.pickupLocationController.text;
            final toText =
                locationController.destinationLocationController.text;

            // Check if locations are set
            if (fromAddress != null &&
                fromAddress.isNotEmpty &&
                fromText.isNotEmpty &&
                toAddress != null &&
                toAddress.isNotEmpty &&
                toText.isNotEmpty) {
              // Auto-update price when locations change #find
              WidgetsBinding.instance.addPostFrameCallback((_) {
                bool shouldUpdatePrice = false;

                // Update if no price exists #find
                if (rideController.estimatedFare == 0 ||
                    rideController.fareList.isEmpty) {
                  shouldUpdatePrice = true;
                }

                // Update if locations changed #find
                if (lastFromAddress != fromAddress ||
                    lastToAddress != toAddress) {
                  shouldUpdatePrice = true;
                  lastFromAddress = fromAddress;
                  lastToAddress = toAddress;
                }

                // Call API if needed #find
                if (shouldUpdatePrice && !rideController.loading) {
                  rideController.getEstimatedFare(false);
                }
              });

              // Show loading state #find
              if (rideController.loading) {
                return _buildLoadingCard();
              }

              // Show price when available #find
              if (rideController.estimatedFare > 0) {
                return _buildPriceCard(rideController.estimatedFare);
              }
            }

            // If locations are not set, show loading (since they should be set by now) #find
            return _buildLoadingCard();
          },
        );
      },
    );
  }

  Widget _buildPriceCard(double price) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF10B981).withOpacity(0.15),
                const Color(0xFF10B981).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF10B981).withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.attach_money,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'estimated_fare'.tr,
                      style: textRegular.copyWith(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          PriceConverter.convertPrice(price,
                              loyaltyPoint: true),
                          style: textBold.copyWith(
                            fontSize: 20,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Get.find<ConfigController>().config?.currencySymbol ??
                              'EGP',
                          style: textRegular.copyWith(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'best_price'.tr,
                  style: textMedium.copyWith(
                    fontSize: 10,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.15),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 2,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'calculating_fare'.tr,
                  style: textMedium.copyWith(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'please_wait_while_we_find_best_route'.tr,
                  style: textRegular.copyWith(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
