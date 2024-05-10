import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, width: 500,
      child: GetBuilder<ScheduleController>(builder: (scheduleController){
        return SfDateRangePicker(
          backgroundColor: Theme.of(context).cardColor,
         showNavigationArrow: true,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
            scheduleController.selectedDate =  DateFormat('yyyy-MM-dd').format(args.value);
          },
          selectionMode: DateRangePickerSelectionMode.single,
          selectionShape: DateRangePickerSelectionShape.rectangle,
          viewSpacing: 10,
          headerHeight: 50,
          enablePastDates: false,
          headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: Theme.of(context).cardColor,
            textAlign: TextAlign.center,
            textStyle: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.8),
            ),
          ),
        );
      }),
    );
  }
}
