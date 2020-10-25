import 'package:Dive/services/statistics/statistics_service.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:Dive/config/size_config.dart';
import 'package:flutter/material.dart';

class MonthGraph extends StatefulWidget {
  final int _year;
  final int _month;

  MonthGraph(this._year, this._month);

  @override
  _MonthGraphState createState() => _MonthGraphState();
}

class _MonthGraphState extends State<MonthGraph> {
  List<TimeSeriesSales> graphData;

  @override
  void initState() {
    super.initState();

    int year = widget._year;
    int month = widget._month;

    initGraphData(month, year);

    StatisticsService().getGraphData(widget._month, widget._year).then((value) {
      setState(() {
        List<TimeSeriesSales> monthStatistics = value
            .map((e) => TimeSeriesSales(
                DateTime(year, month, e["day"]), e["score"].round()))
            .toList();
        graphData = [...graphData, ...monthStatistics];
      });
    });
  }

  void initGraphData(month, year) {
    graphData = [
      TimeSeriesSales(DateTime(year, month, 1), null), // month의 첫날
      TimeSeriesSales(DateTime(year, month + 1, 0), null), // month의 마지막날
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.blockSizeVertical * 35,
      child: GraphBuilder(this.graphData),
    );
  }
}

class GraphBuilder extends StatelessWidget {
  final graphData;

  GraphBuilder(this.graphData);

  List<charts.Series<TimeSeriesSales, DateTime>> _createGraphData() {
    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: this.graphData,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(_createGraphData(),
        animate: false,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        defaultRenderer: charts.LineRendererConfig(includePoints: true),
        primaryMeasureAxis: charts.NumericAxisSpec(
            tickProviderSpec:
                charts.BasicNumericTickProviderSpec(desiredTickCount: 1)));
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
