import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return  SliverPersistentHeader(pinned: true,
      delegate: SliverDelegate(extentSize: 65,
        child: InkWell(onTap: () => Get.toNamed(RouteHelper.getSearchResultRoute()),

          child: Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall,),
            child: Container(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeExtraSmall),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                boxShadow:Get.isDarkMode ? null: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1,)],
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
                color: Theme.of(context).cardColor,
              ),
              child: Row(mainAxisAlignment : MainAxisAlignment.spaceBetween, children: [
                Text('search_services'.tr, style: ubuntuMedium.copyWith(color: Theme.of(context).hintColor)),
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                  child: Container(height: 45, width: 45,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraLarge)),
                    ),
                    child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall + 3),
                      child: Image.asset(Images.searchIcon),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}


class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget? child;
  double? extentSize;

  SliverDelegate({@required this.child,@required this.extentSize});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child!;
  }

  @override
  double get maxExtent => extentSize!;

  @override
  double get minExtent => extentSize!;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != maxExtent || child != oldDelegate.child;
  }
}