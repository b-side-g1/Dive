import 'package:Dive/services/statistics/statistics_service.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:Dive/config/size_config.dart';
import 'package:flutter/material.dart';

class MonthGraph extends StatefulWidget {
  final int _year;
  final int _month;

  const MonthGraph(this._year, this._month, {super.key});

  @override
  State<MonthGraph> createState() => _MonthGraphState();
}

class _MonthGraphState extends State<MonthGraph> {
  List<FlSpot> _spots = const [];
  int _daysInMonth = 30;

  @override
  void initState() {
    super.initState();

    final int year = widget._year;
    final int month = widget._month;
    _daysInMonth = DateTime(year, month + 1, 0).day;

    StatisticsService()
        .getGraphData(widget._month, widget._year)
        .then((value) {
      setState(() {
        _spots = value
            .map<FlSpot>((e) =>
                FlSpot((e["day"] as num).toDouble(), (e["score"] as num).toDouble()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.blockSizeVertical * 35,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineChart(
          LineChartData(
            minX: 1,
            maxX: _daysInMonth.toDouble(),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: true),
            titlesData: const FlTitlesData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: _spots,
                isCurved: false,
                color: Colors.blue,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
