import 'dart:convert';

import 'package:army120/features/events/data/model/event.dart';
import 'package:army120/features/events/data/model/event_response.dart';
import 'package:army120/features/notifications/data/model/notifciation_listing_response.dart';
import 'package:army120/features/home/data/model/patron_listing_response.dart';
import 'package:army120/network/apiError.dart';
import 'package:army120/network/api_urls.dart';
import 'package:army120/network/api_handler.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class HomeRepository {



  //fetch Event Listing
  Future<EventListResponse> fetchEvents() async {
    try {
      var response = await RestClient.dio.get(ApiURL.getEvents );
      if (response.statusCode == 200) {
        var data = response.data;
        EventListResponse prayersResponse = EventListResponse.fromJson(data);
        return prayersResponse;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }  catch (e,st) {
      print("Exception $e,$st");

      if(e is DioError && e.type== DioErrorType.RESPONSE){
        print("got api Eorror");
        var data = e.response.data;
        throw ApiException(message:data['message']);

      }else{
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }

  //fetch Event Listing
  Future<bool> bookMarkEvent({Event event}) async {
    try {
      var response = await RestClient.dio.post(ApiURL.bookMarkEvent +"/${event?.id}/bookmark" );
      if (response.statusCode == 200) {
        var data = response.data;
        EventListResponse prayersResponse = EventListResponse.fromJson(data);
        return true;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }  catch (e,st) {
      print("Exception $e,$st");

      if(e is DioError && e.type== DioErrorType.RESPONSE){
        print("got api Eorror");
        var data = e.response.data;
        throw ApiException(message:data['message']);

      }else{
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }

  //fetch User Listing
  Future<PatronListResponse> fetchPatrons({searchBy,currentPage:1}) async {
    try {
      var response = await RestClient.dio.get(ApiURL.getPatrons+"?page=${currentPage??1}");
      if (response.statusCode == 200) {
        var data = response.data;
        PatronListResponse prayersResponse = PatronListResponse.fromJson(data);
        return prayersResponse;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }  catch (e,st) {
      print("Exception $e,$st");

      if(e is DioError && e.type== DioErrorType.RESPONSE){
        print("got api Eorror");
        var data = e.response.data;
        throw ApiException(message:data['message']);

      }else{
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }
  //fetch User Listing
  Future<NotificationListingResponse> fetchNotifications({searchBy}) async {
    try {
      var response = await RestClient.dio.get(ApiURL.getNotifications);
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

      if(e is DioError && e.type== DioErrorType.RESPONSE){
        print("got api Eorror");
        var data = e.response.data;
        throw ApiException(message:data['message']);

      }else{
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }

}