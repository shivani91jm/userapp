import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final TextDecoration? textDecoration;
  final Function()? onTap;
  const TitleWidget({super.key, required this.title, this.onTap, this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title!.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: title=='recently_view_services'
          ? Colors.white:Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.8))),
      (onTap != null && !ResponsiveHelper.isDesktop(context)) ? InkWell(
        onTap: onTap,
        child: Text(
          'see_all'.tr,
          style: ubuntuRegular.copyWith(
              decoration: textDecoration,
              color:Get.isDarkMode ?Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.8):
                  title=='recently_view_services'? Colors.white
                  : Theme.of(context).colorScheme.primary,
              fontSize: Dimensions.fontSizeLarge, ),
        ),
      ) : const SizedBox(),
    ]);
  }
}
