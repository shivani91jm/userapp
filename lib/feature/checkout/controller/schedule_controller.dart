import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';
import 'package:intl/intl.dart';

enum ScheduleType {asap, schedule}

class ScheduleController extends GetxController implements GetxService{

  final ScheduleRepo scheduleRepo;
  ScheduleController({required this.scheduleRepo});

  ScheduleType _selectedScheduleType = ScheduleType.asap;
  ScheduleType get selectedScheduleType => _selectedScheduleType;


  String selectedDate =   DateFormat('yyyy-MM-dd').format(DateTime.now());
  String selectedTime = DateFormat('hh:mm:ss').format(DateTime.now());

  String? scheduleTime;


  void buildSchedule({bool shouldUpdate = true, required ScheduleType scheduleType, String? schedule}){

    if(schedule != null){
      _selectedScheduleType = ScheduleType.schedule;
      scheduleTime = schedule;
    }else if(scheduleType == ScheduleType.asap){
     _selectedScheduleType = ScheduleType.asap;
     scheduleTime = "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${DateFormat('hh:mm:ss').format(DateTime.now())}";
   }else{
     _selectedScheduleType = ScheduleType.schedule;
     scheduleTime = "$selectedDate $selectedTime";
   }

    if(shouldUpdate){
      update();
    }
  }

  String? checkValidityOfTimeRestriction( AdvanceBooking advanceBooking){

    Duration  difference = DateConverter.dateTimeStringToDate("$selectedDate $selectedTime").difference(DateTime.now());

    if(advanceBooking.advancedBookingRestrictionType == "day" && difference.inDays < advanceBooking.advancedBookingRestrictionValue!){
      return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(DateTime.now().add(Duration(days: advanceBooking.advancedBookingRestrictionValue!)))}";
    }else if (advanceBooking.advancedBookingRestrictionType == "hour" && difference.inHours < advanceBooking.advancedBookingRestrictionValue!){
      return "${'you_can_not_select_schedule_before'.tr} ${DateConverter.dateMonthYearTimeTwentyFourFormat(DateTime.now().add(Duration(hours: advanceBooking.advancedBookingRestrictionValue!)))}";
    }else{
      return null;
    }

  }

  void resetSchedule(){

    if(Get.find<SplashController>().configModel.content?.instantBooking == 1){
      _selectedScheduleType = ScheduleType.asap;
      scheduleTime = "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${DateFormat('hh:mm:ss').format(DateTime.now())}";
    }else{
      _selectedScheduleType = ScheduleType.schedule;
      scheduleTime = null;
    }
  }

  void updateSelectedDate(String? date){
    if(date!=null){
      scheduleTime = date;
    }else{
     scheduleTime = null;
    }
  }

  Future<void> updatePostInformation(String postId,String scheduleTime) async {
    Response response = await scheduleRepo.changePostScheduleTime(postId,scheduleTime);

    if(response.statusCode==200 && response.body['response_code']=="default_update_200"){
      customSnackBar("service_schedule_updated_successfully".tr,isError: false);
    }
  }

}