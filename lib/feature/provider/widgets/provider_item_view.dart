import 'package:demandium/components/core_export.dart';
import 'package:demandium/components/favorite_icon_widget.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:get/get.dart';

class ProviderItemView extends StatelessWidget {
  final  bool fromHomePage;
  final ProviderData providerData;
  final int index;
  const ProviderItemView({super.key, this.fromHomePage = true, required this.providerData, required this.index}) ;

  @override
  Widget build(BuildContext context) {
    List<String> subcategory=[];
    providerData.subscribedServices?.forEach((element) {
      if(element.subCategory!=null){
        subcategory.add(element.subCategory?.name??"");
      }
    });

    String subcategories = subcategory.toString().replaceAll('[', '');
    subcategories = subcategories.replaceAll(']', '');
    subcategories = subcategories.replaceAll('&', ' and ');

    return GetBuilder<ProviderBookingController>(builder: (providerBookingController){
      return GestureDetector(
        onTap: ()=>Get.toNamed(RouteHelper.getProviderDetails(providerData.id!,subcategories)),
        child: Padding(padding:EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.isDesktop(context) && fromHomePage?5:Dimensions.paddingSizeSmall,
            vertical: fromHomePage?0:Dimensions.paddingSizeEight),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor , borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.3)),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start,children: [

                ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
                  child: CustomImage(height: 65, width: 65, fit: BoxFit.cover,
                      image: "${Get.find<SplashController>().configModel.content!.imageBaseUrl}/provider/logo/${providerData.logo}"),
                ),

                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,children: [
                      Text(providerData.companyName??"", style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                          maxLines: 1, overflow: TextOverflow.ellipsis),

                      Row(children: [
                        RatingBar(rating: providerData.avgRating),
                        Gaps.horizontalGapOf(5),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child:  Text('${providerData.ratingCount} ${'reviews'.tr}', style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).secondaryHeaderColor,
                          )),
                        ),
                      ],
                      ),
                    ],),
                  ),
                ),

                FavoriteIconWidget(
                  value: providerData.isFavorite,
                  onTap: (){
                    if(Get.find<AuthController>().isLoggedIn()){
                      providerBookingController.updateIsFavoriteStatus(providerId: providerData.id!, index: index);
                    }else{
                      customSnackBar("please_login_to_add_favorite_list".tr);
                    }

                  },
                ),
              ],),

              Padding( padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                child: Text(subcategories,
                  style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).secondaryHeaderColor), maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Row(children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Image.asset(Images.iconLocation, height:12,),
                ),

                Flexible(
                  child: Text(providerData.companyAddress??"",
                    style: ubuntuMedium.copyWith(color:Get.isDarkMode? Theme.of(context).secondaryHeaderColor:Theme.of(context).primaryColorDark,fontSize: Dimensions.fontSizeSmall),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              ],)
            ]),
          ),
        ),
      );
    });
  }
}