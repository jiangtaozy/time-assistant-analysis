/*
 * Maintained by jemo from 2019.12.13 to now
 * Created by jemo on 2019.12.13 17:00:36
 * Home
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'config.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  var seriesList = [];

  @override
  void initState(){
    super.initState();
    getUserRecordTimes();
  }

  void getUserRecordTimes() async {
    final query = r'''
      query {
        userRecordTimes {
          times,
          recordData {
            date,
            userNumber,
          }
        }
      }
    ''';
    final data = {
      'query': query,
    };
    final body = json.encode(data);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    if(response.statusCode == 200) {
      final data = json.decode(response.body);
      final userRecordTimes = data['data']['userRecordTimes'];
      final series = getSeriesList(userRecordTimes);
      setState(() {
        seriesList = series;
      });
    } else {
      print('response: $response');
    }
  }

  getSeriesList(userRecordTimes) {
    final seriesList = userRecordTimes.map((recordTimes) {
      final series = [
        charts.Series<dynamic, DateTime>(
          id: recordTimes['times'].toString(),
          domainFn: (record, _) {
            DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss Z');
            final date = format.parse(record['date']);
            return date;
          },
          measureFn: (record, _) => record['userNumber'],
          data: recordTimes['recordData'],
        ),
      ];
      return {
        'series': series,
        'times': recordTimes['times'],
      };
    }).toList();
    return seriesList;
  }

  @override
  Widget build(BuildContext context) {
    final seriesChartList = seriesList.map((seriesList) {
      return SizedBox(
        height: 240,
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: charts.TimeSeriesChart(
            seriesList['series'],
            animate: true,
            behaviors: [
              charts.ChartTitle(
                seriesList['times'].toString(),
                behaviorPosition: charts.BehaviorPosition.top,
                titleOutsideJustification: charts.OutsideJustification.start,
                innerPadding: 18,
              ),
            ],
            domainAxis: charts.DateTimeAxisSpec(
              tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                day: charts.TimeFormatterSpec(
                  format: 'd',
                  transitionFormat: 'MM-dd',
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('用户数据分析'),
      ),
      body: ListView(
        children: seriesChartList,
      ),
    );
  }
}
