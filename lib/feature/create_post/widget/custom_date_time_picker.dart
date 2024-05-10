import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/create_post/widget/custom_date_picker.dart';
import 'package:demandium/feature/create_post/widget/custom_time_picker.dart';
import 'package:get/get.dart';


class CustomDateTimePicker extends StatelessWidget {
  const CustomDateTimePicker({super.key});

  @override
  Widget build(BuildContext context) {

    if(ResponsiveHelper.isDesktop(context)) {
      return  Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
      );
    }
    return pointerInterceptor();
  }
  pointerInterceptor(){
    ConfigModel configModel = Get.find<SplashController>().configModel;
    return Container(
      width:ResponsiveHelper.isDesktop(Get.context!)? Dimensions.webMaxWidth/2:Dimensions.webMaxWidth,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusLarge),
            topRight: Radius.circular(Dimensions.radiusLarge),
          ),
          color: Theme.of(Get.context!).cardColor
      ),padding: const EdgeInsets.all(15),
      child: GetBuilder<ScheduleController>(builder: (scheduleController){
        return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).hintColor,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 4 , width: 80,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            const CustomDatePicker(),
            Padding(padding: EdgeInsets.symmetric(
                horizontal:  ResponsiveHelper.isDesktop(Get.context!)?Dimensions.paddingSizeLarge*2:0),
              child: const CustomTimePicker(),
            ),

            if(configModel.content?.instantBooking == 1)
            Padding(
              padding: EdgeInsets.symmetric(horizontal:  ResponsiveHelper.isDesktop(Get.context!)?Dimensions.paddingSizeLarge*2:0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                Divider(color: Theme.of(Get.context!).hintColor ,height: 0.5,),
                const SizedBox(height: Dimensions.paddingSizeSmall,),
                Row(
                  children: [
                    CustomButton(
                      width: 100,
                      height: 40,
                      radius: Dimensions.radiusExtraMoreLarge,
                      buttonText: "ASAP".tr.toUpperCase(),
                      onPressed: (){
                          scheduleController.buildSchedule(scheduleType: ScheduleType.asap);
                          Get.back();
                      },
                    ),
                  ],
                ),

              ],),

            ),
            Padding(padding: EdgeInsets.symmetric(
                horizontal:  ResponsiveHelper.isDesktop(Get.context!)?Dimensions.paddingSizeLarge*3:0),
              child: actionButtonWidget(Get.context!, scheduleController),
            ),


          ],
        ),
      );
      }),
    );
  }

  Row actionButtonWidget(BuildContext context, ScheduleController scheduleController) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [

      TextButton(style: TextButton.styleFrom(padding: EdgeInsets.zero,
        minimumSize: const Size(50,30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          onPressed: ()=> Get.back(),
          child:  Text(
          'cancel'.tr.toUpperCase(),
          style: ubuntuMedium.copyWith(
              color: Get.isDarkMode ? Theme.of(context).primaryColorLight : Colors.black.withOpacity(0.3)
          ),
        )),
      const SizedBox(width: Dimensions.paddingSizeDefault,),

      CustomButton(
        width: ResponsiveHelper.isDesktop(context)?90:70,
        height: ResponsiveHelper.isDesktop(context)?45:40,
        radius: Dimensions.radiusExtraMoreLarge,
        buttonText: "ok".tr.toUpperCase(),
        onPressed: (){
          ConfigModel config = Get.find<SplashController>().configModel;

          if(config.content!.advanceBooking != null && config.content?.scheduleBookingTimeRestriction == 1){
            if(scheduleController.checkValidityOfTimeRestriction(config.content!.advanceBooking!) !=null){
              customSnackBar(scheduleController.checkValidityOfTimeRestriction(config.content!.advanceBooking!));
            }else{
              scheduleController.buildSchedule(scheduleType: ScheduleType.schedule);
              Get.back();
            }
          }else{
            scheduleController.buildSchedule(scheduleType: ScheduleType.schedule);
            Get.back();
          }},

      ),
    ]);
  }
}