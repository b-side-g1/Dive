import 'package:Dive/services/statistics/statistics_service.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:Dive/config/size_config.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class MonthGraph extends StatefulWidget {
  final int _year;
  final int _month;

  MonthGraph(this._year, this._month);

  @override
  _MonthGraphState createState() => _MonthGraphState();
}

class _MonthGraphState extends State<MonthGraph> {
  var data;
  List<Map<String, dynamic>> testData;

  @override
  void initState() {
    super.initState();
    data = [
      new TimeSeriesSales(new DateTime(2017, 10, 1), null),
      new TimeSeriesSales(new DateTime(2017, 10, 31), null),
    ];


    setState(() {


      StatisticsService().getGraphData(widget._month, widget._year).then((value)  {

//        data = [
//          new TimeSeriesSales(new DateTime(2017, 10, 1), 10),
//          new TimeSeriesSales(new DateTime(2017, 10, 2), null),
//          new TimeSeriesSales(new DateTime(2017, 10, 3), null),
//          new TimeSeriesSales(new DateTime(2017, 10, 31), null),
//        ];

        testData = value;
        print("테스트 : ${testData}");
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.blockSizeVertical * 35,
      decoration: BoxDecoration(border: Border.all()),
      child: GraphBuilder(this.data),
    );
  }
}

class GraphBuilder extends StatelessWidget {
  final data;

  GraphBuilder(this.data);

  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: this.data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(_createSampleData(),
        animate: false,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        defaultRenderer: new charts.LineRendererConfig(includePoints: true),
        primaryMeasureAxis: new charts.NumericAxisSpec(
            tickProviderSpec:
                new charts.BasicNumericTickProviderSpec(desiredTickCount: 1)));
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
