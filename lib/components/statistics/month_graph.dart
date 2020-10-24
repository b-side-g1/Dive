import 'package:charts_flutter/flutter.dart' as charts;

import 'package:Dive/config/size_config.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class MonthGraph extends StatelessWidget {
  final List<charts.Series> seriesList  = _createSampleLineData ();
  final bool animate = false;

//  factory MonthGraph.withSampleData() {
//    return new MonthGraph(
//      _createSampleData(),
//      animate: false,
//    );
//  }

  static List<charts.Series<LinearSales, int>> _createSampleLineData() {
    final data = [
      new LinearSales(0, 10),
      new LinearSales(7, 10),
      new LinearSales(14, 10),
      new LinearSales(21, 10),
      new LinearSales(28, 10),
      new LinearSales(29, 10),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
  Widget buildGraph() {
    return charts.LineChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.LineRendererConfig(includePoints: true),
    );;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.blockSizeVertical * 35,
      decoration: BoxDecoration(border: Border.all()),
      child: buildGraph(),
    );
  }
}

//class TimeSeriesSales {
//  final DateTime time;
//  final int sales;
//
//  TimeSeriesSales(this.time, this.sales);
//}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
