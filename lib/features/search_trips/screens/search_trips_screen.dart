import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/choose_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/from_to_text_arrow_icon_widget.dart';
import 'package:ride_sharing_user_app/features/search_trips/widgets/search_tripe_details_text_widgets.dart';
import 'package:ride_sharing_user_app/features/search_trips/widgets/search_tripe_list_view_widget.dart';
import 'package:ride_sharing_user_app/features/search_trips/widgets/search_tripe_search_date_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class SearchTripsScreen extends StatefulWidget {
  const SearchTripsScreen({super.key});

  @override
  State<SearchTripsScreen> createState() => _SearchTripsScreenState();
}

List<String> select = ["one", "two", "three", "four", "five"];

class _SearchTripsScreenState extends State<SearchTripsScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Stack(
        children: [
          // Container(
          //   height: 160,
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).primaryColor,
          //     borderRadius: const BorderRadius.only(
          //       bottomLeft: Radius.circular(30),
          //       bottomRight: Radius.circular(30),
          //     ),
          //   ),
          // ),

          BodyWidget(
            appBar: AppBarWidget(
              title: '',
              showBackButton: false,
              height: 150,
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  18,
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SearchTripeDetailsTextWidgets(),
                    SizedBox(height: size.height * 0.02),
                    FromToTextArrowIconWidget(
                        width: size.width, isShowArrowButton: false),
                    SizedBox(height: size.height * 0.02),
                    ChooseWidget(nameList: select),
                    SizedBox(height: size.height * 0.02),
                    SearchTripeSearchDateWidget(),
                    Expanded(child: SearchTripeListViewWidget()),
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
