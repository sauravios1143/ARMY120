
import 'package:army120/features/notifications/data/model/notifciation_listing_response.dart';
import 'package:army120/network/apiError.dart';
import 'package:army120/network/api_handler.dart';
import 'package:army120/network/api_urls.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:dio/dio.dart';

class NotificationRepository {

  Future<NotificationListingResponse> fetchNotifications({searchBy,currentPage:1}) async {
    try {
      var response = await RestClient.dio.get(ApiURL.getNotifications+"?page=${currentPage??1}");
      if (response.statusCode == 200) {
        var data = response.data;
        print('opend--> ${data}');
        NotificationListingResponse prayersResponse = NotificationListingResponse.fromJson(data);
        return prayersResponse;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }  catch (e,st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);

      }else{
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }


}