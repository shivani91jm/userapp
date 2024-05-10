import 'package:demandium/feature/create_post/widget/custom_date_time_picker.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class ServiceSchedule extends StatefulWidget {
  const ServiceSchedule({super.key}) ;

  @override
  State<ServiceSchedule> createState() => _ServiceScheduleState();
}

class _ServiceScheduleState extends State<ServiceSchedule> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(builder: (scheduleController){
      return  Column( children: [

        Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Text("preferable_time".tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
        ),

        Container(
          width: Get.width,
          padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 0.5),
            color: Theme.of(context).hoverColor.withOpacity(0.5),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 0.5),
              color: Theme.of(context).hoverColor.withOpacity(0.5),
            ),
            padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
            child: Center(child: Row( children: [

              Expanded( flex: 7, child: Row( children: [

                Text(
                  scheduleController.selectedScheduleType == ScheduleType.asap ?'ASAP'.tr :
                  scheduleController.selectedScheduleType == ScheduleType.schedule && scheduleController.scheduleTime != null ?
                  DateConverter.dateMonthYearTimeTwentyFourFormat(DateConverter.dateTimeStringToDate(scheduleController.scheduleTime!)) : "select_schedule_time".tr,
                  style: ubuntuMedium,
                ),
              ])),

              InkWell( onTap: () {

                if(Get.find<SplashController>().configModel.content?.scheduleBooking ==1 ){
                  showModalBottomSheet(backgroundColor: Colors.transparent, isScrollControlled: true, context: context, builder: (BuildContext context){
                    return const CustomDateTimePicker();
                  });
                }else{
                  customSnackBar("schedule_booking_currently_unavailable".tr );
                }
              },
                child: Image.asset(Images.scheduleIcon, width: 20, color: Theme.of(context).colorScheme.primary,),
              ),

            ])),
          ),
        ),

        const SizedBox(height: Dimensions.paddingSizeDefault),

      ]);},
    );
  }
}
