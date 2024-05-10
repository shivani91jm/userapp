import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/provider/model/category_model_item.dart';
import 'package:demandium/feature/provider/model/provider_details_model.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:get/get.dart';


class ProviderBookingController extends GetxController implements GetxService {
  final ProviderBookingRepo providerBookingRepo;
  ProviderBookingController({required this.providerBookingRepo});


  @override
  void onInit() async {
    super.onInit();
    getCategoryList();
  }

  final bool _isLoading = false;
  get isLoading => _isLoading;

  ProviderModel? _providerModel;
  ProviderModel? get providerModel => _providerModel;

  ProviderDetailsContent? _providerDetailsContent;
  ProviderDetailsContent? get providerDetailsContent => _providerDetailsContent;

  List<CategoryModelItem> categoryItemList =[];

  List<ProviderData>? _providerList;
  List<ProviderData>? get  providerList=> _providerList;


  String formatDays(List<String> dayList) {
    if (dayList.isEmpty) {
      return "";
    }
    List<String> formattedList = dayList.map((day) => day[0].toLowerCase() + day.substring(1)).toList();
    if (formattedList.length == 1) {
      return formattedList[0].tr;
    }
    formattedList.sort((a, b) {
      const daysOfWeek = [ "saturday", "sunday", "monday", "tuesday", "wednesday", "thursday", "friday"];
      return daysOfWeek.indexOf(a) - daysOfWeek.indexOf(b);
    });
    bool isConsecutive = true;
    for (int i = 1; i < formattedList.length; i++) {
      if (_nextDay(formattedList[i - 1]) != formattedList[i]) {
        isConsecutive = false;
        break;
      }
    }
    if (isConsecutive) {
      return "${formattedList.first.toLowerCase().tr} - ${formattedList.last.toLowerCase().tr}";
    } else {

      List<String> translatedList =[];
      for (var element in formattedList) {
        translatedList.add(element.tr);
      }
      return translatedList.join(', ');
    }
  }
  String _nextDay(String day) {
    const daysOfWeek = [ "saturday", "sunday", "monday", "tuesday", "wednesday", "thursday","friday"];
    final index = daysOfWeek.indexOf(day);
    return daysOfWeek[(index + 1) % daysOfWeek.length];
  }


  Future<void> getProviderList(int offset, bool reload) async {

    if(offset != 1 || _providerModel == null || reload){
      if(reload){
        _providerModel = null;
      }
      
      Map<String,dynamic> body={
        'sort_by': sortBy[selectedSortByIndex],
        'rating': selectedRatingIndex,
      }; 
      
      if(selectedCategoryId.isNotEmpty){
        body.addAll({'category_ids': selectedCategoryId});
      }

      Response response = await providerBookingRepo.getProviderList(offset,body);
      if (response.statusCode == 200) {
        if(reload){
          _providerList = [];
        }
        _providerModel = ProviderModel.fromJson(response.body);
        if(_providerModel != null && offset != 1){
          _providerList!.addAll(ProviderModel.fromJson(response.body).content?.data??[]);
        }else{
          _providerList = [];
          _providerList!.addAll(ProviderModel.fromJson(response.body).content?.data??[]);
        }
        update();
      } else {
       // ApiChecker.checkApi(response);
      }
    }
  }



  Future<void> getProviderDetailsData(String providerId, bool reload) async {

    if(_providerDetailsContent == null || reload){
      if(reload){
        categoryItemList =[];
        _providerDetailsContent = null;
      }
      Response response = await providerBookingRepo.getProviderDetails(providerId);
      if (response.statusCode == 200) {
        _providerDetailsContent = ProviderDetails.fromJson(response.body).content;

        if(_providerDetailsContent!.subCategories!=null || _providerDetailsContent!.subCategories!.isNotEmpty){
          for (var subcategory in _providerDetailsContent!.subCategories!) {
            List<Service> serviceList = [];
            if(subcategory.services!.isNotEmpty){
              subcategory.services?.forEach((service) {
                  serviceList.add(service);
              });

              if(serviceList.isNotEmpty){
                categoryItemList.add(CategoryModelItem(
                  title: subcategory.name!, serviceList: serviceList,
                ));
              }
            }
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  int _apiHitCount = 0;

  Future<void> updateIsFavoriteStatus({ required String providerId, required int index}) async {

    _apiHitCount ++;
    updateIsFavoriteValue(providerList?[index].isFavorite ==1 ? 0 : 1,providerId);
    update();
    Response response = await providerBookingRepo.updateIsFavoriteStatus(serviceId: providerId);

    _apiHitCount --;
    int status;
    if(response.statusCode == 200 && (response.body['response_code'] == "provider_favorite_store_200" || response.body['response_code'] == "provider_remove_favorite_200")){
      if(response.body['content']['status'] !=null){
        status  = response.body['content']['status'];
        updateIsFavoriteValue(status,providerId);
        customSnackBar(response.body['message'], isError: status == 1 ? false : true);
      }
    }

    if(_apiHitCount ==0){
      update();
    }
  }

  updateIsFavoriteValue(int status, String providerId, {bool shouldUpdate = false}){

    int? index = providerList?.indexWhere((element) => element.id == providerId);
    if(index !=null && index > -1){
      providerList?[index].isFavorite = status;
    }
    if(shouldUpdate){
      update();
    }
  }



  /// filter Section
  int selectedRatingIndex = 0;
  int selectedSortByIndex = 0;

  List<CategoryModel> categoryList =[];

  List<String> sortBy = ['asc',"desc"];

  List<bool> categoryCheckList =[];
  List<String> selectedCategoryId =[];

  Future<void> getCategoryList() async {
    Response response = await providerBookingRepo.getCategoryList();
    if(response.statusCode == 200){

      categoryList = [];
      categoryCheckList = [];

      List<dynamic> serviceCategoryList = response.body['content']['data'];
      for (var category in serviceCategoryList) {
        categoryList.add(CategoryModel.fromJson(category));
        categoryCheckList.add(false);
      }
    }
    else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  updateSortByIndex(int rating){
    selectedSortByIndex= rating;
    update();
  }

  updateRatingIndex(int rating){
    selectedRatingIndex= rating;
    update();
  }

  void toggleFromCampaignChecked(int index) {

    categoryCheckList[index] = !categoryCheckList[index];

    if(categoryCheckList[index]==true){
      if(!selectedCategoryId.contains(categoryList[index].id)){
        selectedCategoryId.add(categoryList[index].id!);
      }
    }else{
      if(selectedCategoryId.contains(categoryList[index].id)){
        selectedCategoryId.remove(categoryList[index].id);
      }
    }
    update();

  }

  resetProviderFilterData({bool shouldUpdate= false}){
    selectedCategoryId=[];
    categoryCheckList = [];
    selectedRatingIndex=0;
    selectedSortByIndex = 0;

    for (var element in categoryList) {
      categoryCheckList.add(false);
      if (kDebugMode) {
        print(element.name);
      }
    }
    if(shouldUpdate){
      update();
    }
  }

}