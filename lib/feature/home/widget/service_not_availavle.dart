import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class ServiceNotAvailableScreen extends StatelessWidget {
  final String fromPage;
  const ServiceNotAvailableScreen({super.key, this.fromPage = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Images.notAvailableIcon, width:  100.0, height: 100.0, color: Colors.grey ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text(fromPage == "search_page"? "there_are_no_services_related_to_your_search".tr : "services_are_not_available".tr, style: ubuntuMedium.copyWith( fontSize: Dimensions.fontSizeExtraLarge)),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        fromPage != "search_page"?
        Text("please_select_among".tr, style: ubuntuMedium.copyWith( fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor), textAlign: TextAlign.center)
        : const SizedBox(),

        const SizedBox(height: Dimensions.paddingSizeLarge),

        fromPage != "search_page"?
        InkWell(
          onTap: () {
            Get.toNamed(RouteHelper.getServiceArea());
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              border: Border.all(color: Theme.of(context).colorScheme.primary),
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
            child: Text("view_available_areas".tr, style: ubuntuMedium.copyWith( fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).colorScheme.primary)),
          ),
        ) : const SizedBox(),

      ]
    );
  }
}
