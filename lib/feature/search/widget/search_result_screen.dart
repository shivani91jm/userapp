// ignore_for_file: deprecated_member_use

import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';


class SearchResultScreen extends StatefulWidget {
  final String? queryText;

  const SearchResultScreen({super.key, required this.queryText}) ;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {

  @override
  void initState() {

    Get.find<AllSearchController>().removeService(widget.queryText ?? "");

    if(widget.queryText!.isNotEmpty){
      Get.find<AllSearchController>().searchData(widget.queryText!, shouldUpdate: false);
    }
    requestFocus();
    super.initState();
  }

  requestFocus() async{
    Timer(const Duration(seconds: 1), () {
      if(!ResponsiveHelper.isWeb()) {
        Get.find<AllSearchController>().searchFocus.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  => _exitApp(),
      child: Scaffold(
        endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
        appBar: const SearchAppBar(backButton: true),
        body: GetBuilder<AllSearchController>(

          builder: (searchController){
            return FooterBaseView(
                isCenter: searchController.isSearchComplete &&  ( searchController.searchServiceList == null || searchController.searchServiceList!.isEmpty) ? true:false,
                child: searchController.searchServiceList == null ?
                Center(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: GridView.builder(
                      key: UniqueKey(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: Dimensions.paddingSizeDefault,
                        mainAxisSpacing:  Dimensions.paddingSizeDefault,
                        childAspectRatio: ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isTab(context)  ? 1 : .70,
                        crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 5,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap:  true,
                      itemCount: 15,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      itemBuilder: (context, index) {
                        return const ServiceShimmer(isEnabled: true, hasDivider: true,);
                      },
                    ),
                  ),
                ) :
                const ItemView());
          },
        ),
      ),
    );
  }

  Future<bool> _exitApp() async {
    Get.find<AllSearchController>().clearSearchController();
    return true;
  }
}
