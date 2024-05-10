import 'package:demandium/components/service_widget_vertical.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class WebPopularServiceView extends StatelessWidget {
  const WebPopularServiceView({super.key});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(

      builder: (serviceController){
        if(serviceController.popularServiceList != null && serviceController.popularServiceList!.isEmpty){
          return const SizedBox();
        }else{
          if(serviceController.popularServiceList != null){
            List<Service>? serviceList = serviceController.popularServiceList;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('popular_services'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                      InkWell(
                        onTap: () => Get.toNamed(RouteHelper.allServiceScreenRoute("popular_services")),
                        child: Text('see_all'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                          decoration: TextDecoration.underline,
                          color:Get.isDarkMode ?Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6) : Theme.of(context).colorScheme.primary,
                        )),
                      ),
                    ],
                  ),
                ),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio:ResponsiveHelper.isMobile(context) ? 0.78 : 0.75,
                    crossAxisSpacing: Dimensions.paddingSizeDefault,
                    mainAxisSpacing: Dimensions.paddingSizeDefault,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  itemCount: serviceList!.length > 7 ? 8 : serviceList.length,
                  itemBuilder: (context, index){
                    return ServiceWidgetVertical(service: serviceController.popularServiceList![index], fromType: '', );
                  },
                )
              ],
            );
          }
          else{
            return  Padding(padding: const EdgeInsets.only(top: 65),
              child: GridView.builder(
                key: UniqueKey(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Dimensions.paddingSizeDefault,
                  mainAxisSpacing:  Dimensions.paddingSizeDefault,
                  childAspectRatio:ResponsiveHelper.isMobile(context) ? 0.78 : 0.79,
                  crossAxisCount: 4,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap:  true,
                itemCount: 8,
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  return const ServiceShimmer(isEnabled: true, hasDivider: true);
                },
              ),
            );
          }
        }
      },
    );
  }
}
