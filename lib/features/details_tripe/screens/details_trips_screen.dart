import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/from_to_text_arrow_icon_widget.dart';
import 'package:ride_sharing_user_app/features/details_tripe/widgets/details_tripe_all_details_widget.dart';
import 'package:ride_sharing_user_app/features/details_tripe/widgets/details_tripe_all_request.dart';
import 'package:ride_sharing_user_app/features/details_tripe/widgets/details_tripe_all_users_request.dart';
import 'package:ride_sharing_user_app/features/details_tripe/widgets/details_tripe_button.dart';
import 'package:ride_sharing_user_app/features/details_tripe/widgets/details_tripe_end_trip_button.dart';
import 'package:ride_sharing_user_app/features/details_tripe/widgets/details_tripe_from_to_widget.dart';
import 'package:ride_sharing_user_app/features/details_tripe/widgets/details_tripe_name_car_and_price.dart';
import 'package:ride_sharing_user_app/features/details_tripe/widgets/details_tripe_search_date_widget.dart';
import 'package:ride_sharing_user_app/features/details_tripe/widgets/details_tripe_start_trip_button.dart';

import 'package:ride_sharing_user_app/features/search_trips/widgets/search_tripe_details_text_widgets.dart';
import 'package:ride_sharing_user_app/features/search_trips/widgets/search_tripe_list_view_widget.dart';
import 'package:ride_sharing_user_app/features/search_trips/widgets/search_tripe_search_date_widget.dart';
import 'package:ride_sharing_user_app/features/search_trips/widgets/search_tripe_select_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:get/get.dart';

class DetailsTripScreen extends StatelessWidget {
  final bool isMyTrip;
  final bool? isEndTrip;

  const DetailsTripScreen({super.key, required this.isMyTrip, this.isEndTrip});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Stack(
        children: [
          BodyWidget(
            appBar: AppBarWidget(
              title: '',
              showBackButton: false,
            ),
            body: SafeArea(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        spacing: size.height * 0.02,
                        children: [
                          DetailsTripeSearchDateWidget(),
                          DetailsTripeFromToWidget(),
                          DetailsTripeAllRequest(),
                          DetailsTripeNameCarAndPrice(),
                          DetailsTripeAllDetailsWidget(),
                          isMyTrip
                              ? DetailsTripeAllUsersRequest()
                              : SizedBox.shrink(),
                          isMyTrip
                              ? DetailsTripeStartTripButton()
                              : isEndTrip != null
                                  ? DetailsTripeEndTripButton()
                                  : DetailsTripeButton(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
