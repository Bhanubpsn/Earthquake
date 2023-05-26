import 'dart:convert';
import 'package:http/http.dart';
import '../model/quake.dart';

class Network{

  Future<Quake> getAllQuakes() async{
    var apiURL = "https://earthquake.usgs.gov/fdsnws/event/1/query.geojson?starttime=2023-05-08%2000:00:00&endtime=2023-05-15%2023:59:59&maxlatitude=35.604&minlatitude=7.711&maxlongitude=97.031&minlongitude=68.027&minmagnitude=2.5&orderby=time";

    final response = await get(Uri.parse(apiURL));

    if(response.statusCode == 200)
    {
      print("Quake data: ${response.body}");
      return Quake.fromJson(json.decode(response.body));
    }
    else
    {
      throw Exception("EROORRRRRRR");
    }
  }
  

}