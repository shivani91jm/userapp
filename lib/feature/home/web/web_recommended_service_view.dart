import 'package:demandium/components/favorite_icon_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class WebRecommendedServiceView extends StatelessWidget {
  const WebRecommendedServiceView({super.key});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(
      builder: (serviceController){
        if(serviceController.recommendedServiceList != null && serviceController.recommendedServiceList!.isEmpty){
          return const SizedBox();
        }else{
          if(serviceController.recommendedServiceList != null){
            List<Service>? recommendedServiceList = serviceController.recommendedServiceList;
            return SizedBox(
              width: Dimensions.webMaxWidth / 3.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    child: Text('recommended_for_you'.tr,
                        style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                  ),

                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: recommendedServiceList!.length > 3 ? 4 : recommendedServiceList.length,
                    itemBuilder: (context, index){
                      Discount discount = PriceConverter.discountCalculation(serviceController.recommendedServiceList![index]);

                      return InkWell(
                        onTap: () => Get.toNamed(RouteHelper.getServiceRoute(recommendedServiceList[index].id!)),
                        child: index == 3 ?
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ServiceModelView(
                                serviceList: serviceController.recommendedServiceList!,
                                discountAmountType: discount.discountAmountType,
                                discountAmount: discount.discountAmount,
                                index: index,
                              ),
                              Positioned(
                                bottom: -10,
                                child: Container(
                                  width: Dimensions.webMaxWidth / 3.5,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Theme.of(context).cardColor, // Shadow color with opacity// Shadow color with opacity
                                        Theme.of(context).cardColor.withOpacity(0.3), // Transparent to the top
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 10, left: 0, right: 0,
                                child: CustomButton(
                                  buttonText: 'see_more'.tr, width: 120,
                                  radius: Dimensions.radiusExtraMoreLarge,
                                  onPressed: () {
                                    Get.toNamed(RouteHelper.allServiceScreenRoute("fromRecommendedScreen"));
                                  },
                                ),
                              )
                            ],
                          )

                        : ServiceModelView(
                          serviceList: serviceController.recommendedServiceList!,
                          discountAmountType: discount.discountAmountType,
                          discountAmount: discount.discountAmount,
                          index: index,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          else{
            return const WebCampaignShimmer(enabled: true,);
          }
        }
      },
    );
  }
}

class ServiceModelView extends StatelessWidget {
  final List<Service> serviceList;
  final int index;
  final num? discountAmount;
  final String? discountAmountType;
  final bool showIsFavoriteButton;

  const  ServiceModelView({super.key,
    required this.serviceList,
    required this.index,
    required this.discountAmount,
    required this.discountAmountType,
    this.showIsFavoriteButton = true,
  }) ;

  @override
  Widget build(BuildContext context) {
    double lowestPrice = 0.0;
    if(serviceList[index].variationsAppFormat!.zoneWiseVariations != null){
       lowestPrice = serviceList[index].variationsAppFormat!.zoneWiseVariations![0].price!.toDouble();
      for (var i = 0; i < serviceList[index].variationsAppFormat!.zoneWiseVariations!.length; i++) {
        if (serviceList[index].variationsAppFormat!.zoneWiseVariations![i].price! < lowestPrice) {
          lowestPrice = serviceList[index].variationsAppFormat!.zoneWiseVariations![i].price!.toDouble();
        }
      }
    }
    return GetBuilder<ServiceController>(builder: (serviceController){
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor ,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow:Get.isDarkMode ? null: cardShadow,
          border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.1)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: 10),
        child: Row(children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: CustomImage(
                  image: '${Get.find<SplashController>().configModel.content!.imageBaseUrl!}/service/${serviceList[index].thumbnail}',
                  height: 90, width: 90, fit: BoxFit.cover,
                ),
              ),

              if( discountAmount != null && discountAmountType!=null && discountAmount! > 0) Positioned.fill(
                child: Align(alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(Dimensions.radiusDefault),
                        topRight: Radius.circular(Dimensions.radiusSmall),
                      ),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        PriceConverter.percentageOrAmount('$discountAmount', discountAmountType!),
                        style: ubuntuMedium.copyWith(color: Theme.of(context).primaryColorLight),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: Dimensions.paddingSizeSmall,),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      serviceList[index].name!,
                      style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                  if(showIsFavoriteButton)
                  FavoriteIconWidget(
                    value: serviceList[index].isFavorite,
                    onTap: (){

                      if(Get.find<AuthController>().isLoggedIn()){
                        serviceController.updateIsFavoriteStatus(
                          serviceId: serviceList[index].id!,
                          currentStatus: serviceList[index].isFavorite ?? 0,
                        );
                      }else{
                        customSnackBar("please_login_to_add_favorite_list".tr);
                      }
                    },
                  )
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              RatingBar(
                rating: double.parse(serviceList[index].avgRating.toString()), size: 15,
                ratingCount: serviceList[index].ratingCount,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Text(serviceList[index].shortDescription ?? "",
                style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5)),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("starts_from".tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5)),),

                  Column(
                      children: [
                        if(discountAmount! > 0)
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text("${PriceConverter.convertPrice(lowestPrice)} ",
                              style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                  decoration: TextDecoration.lineThrough,
                                  color: Theme.of(context).colorScheme.error.withOpacity(.8)),
                            ),
                          ),

                        discountAmount! > 0?
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(PriceConverter.convertPrice(lowestPrice,
                              discount: discountAmount!.toDouble(),
                              discountType: discountAmountType
                          ),
                            style: ubuntuBold.copyWith(fontSize: Dimensions.paddingSizeDefault,
                                color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor),
                          ),
                        ): Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(PriceConverter.convertPrice(lowestPrice),
                            style: ubuntuBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor),
                          ),
                        ),
                      ]
                  ),


                ],
              ),
            ]),
          ),

        ]),
      );
    });
  }
}





