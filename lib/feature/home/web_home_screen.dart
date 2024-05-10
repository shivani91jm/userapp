import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';


class WebHomeScreen extends StatelessWidget {
  final ScrollController? scrollController;
  final int availableServiceCount;
  const WebHomeScreen({super.key, required this.scrollController, required this.availableServiceCount});

  @override
  Widget build(BuildContext context) {

    Get.find<BannerController>().setCurrentIndex(0, false);
    ConfigModel configModel = Get.find<SplashController>().configModel;

    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [

        const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeExtraLarge,)),

        SliverToBoxAdapter(child: Center( child: SizedBox(width: Dimensions.webMaxWidth,
          child: WebBannerView(),
        ))),

        (availableServiceCount > 0) ? SliverToBoxAdapter(child: Center(
          child: SizedBox( width: Dimensions.webMaxWidth,
            child: Column(children: [

              const SizedBox(height: Dimensions.paddingSizeLarge),
              const CategoryView(),

              const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                WebRecommendedServiceView(),
                SizedBox(width: Dimensions.paddingSizeLarge,),
                Expanded(child: WebPopularServiceView()),
              ],),


              const SizedBox(height: Dimensions.paddingSizeLarge),

              GetBuilder<ProviderBookingController>(builder: (providerController){
                return GetBuilder<ServiceController>(
                  builder: (serviceController) {
                    return Row(
                      children:  [
                        if(configModel.content!.biddingStatus == 1)
                          (serviceController.serviceContent != null && serviceController.allService != null && serviceController.allService!.isEmpty) ? const SizedBox() :
                          SizedBox(
                            width: providerController.providerList != null && providerController.providerList!.isNotEmpty && configModel.content?.directProviderBooking==1
                                ? Dimensions.webMaxWidth/3.5 : Dimensions.webMaxWidth,
                            height:  240,
                            child: const HomeCreatePostView(),
                          ),
                        if(configModel.content?.directProviderBooking==1 && configModel.content!.biddingStatus == 1 && providerController.providerList != null && providerController.providerList!.isNotEmpty)
                          const SizedBox(width: Dimensions.paddingSizeLarge+5),
                        if(configModel.content?.directProviderBooking == 1 && serviceController.allService != null && serviceController.allService!.isNotEmpty)
                          Expanded(child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              child: const HomeRecommendProvider()),
                          ),
                      ],
                    );
                  },

                );
              }),

              const SizedBox(height: Dimensions.paddingSizeLarge,),
              const WebTrendingServiceView(),
              const SizedBox(height: Dimensions.paddingSizeLarge,),


              if(Get.find<AuthController>().isLoggedIn() )
                const WebRecentlyServiceView(),


              const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge,),
              const WebCampaignView(),
              const SizedBox(height: Dimensions.paddingSizeLarge),


              const WebFeatheredCategoryView(),
              const SizedBox(height: Dimensions.paddingSizeLarge),


              Padding(padding: const EdgeInsets.fromLTRB(0, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall,
                ), child: TitleWidget(title: 'all_service'.tr,),
              ),

              GetBuilder<ServiceController>(builder: (serviceController) {
                return PaginatedListView(
                  showBottomSheet: true,
                  scrollController: scrollController!,
                  totalSize: serviceController.serviceContent?.total,
                  offset: serviceController.serviceContent?.currentPage,
                  onPaginate: (int offset) async => await serviceController.getAllServiceList(offset,false),
                  itemView: ServiceViewVertical(
                    service: serviceController.serviceContent != null ? serviceController.allService : null,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
                      vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
                    ),
                    type: 'others',
                    noDataType: NoDataType.home,
                  ),
                );
              }),

            ],),
          ),

        ),) : SliverToBoxAdapter(child: SizedBox( height: MediaQuery.of(context).size.height*.8, child: const ServiceNotAvailableScreen())),

        const SliverToBoxAdapter(child: FooterView(),),

      ],
    );
  }
}
