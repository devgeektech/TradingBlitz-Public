
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trading/utils/theme.dart';

enum ChartRange { oneWeek, oneMonth, oneYear }

class WeeklyDataPoint {
  WeeklyDataPoint({
    this.time,
    this.value,
  });

  final DateTime? time;
  final double? value;

  factory WeeklyDataPoint.fromJson(Map<String, dynamic> json){
    return WeeklyDataPoint(
      time: DateTime.tryParse(json["date"] ?? ""),
      value: json["value"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "date": time?.toIso8601String(),
    "value": value,
  };

}



class DailyDataPoint {
  final DateTime date;
  final double value;

  DailyDataPoint({required this.date, required this.value});
}




// class WeeklyPerformanceChart extends StatelessWidget {
//   final List<WeeklyDataPoint> apiData;
//
//   const WeeklyPerformanceChart({super.key, required this.apiData});
//
//   List<WeeklyDataPoint> fillMissingWeekData(DateTime now, List<WeeklyDataPoint> apiData) {
//     final DateTime monday = DateTime(now.year, now.month, now.day)
//         .subtract(Duration(days: now.weekday - 1));
//     final DateTime today = DateTime(now.year, now.month, now.day);
//     List<WeeklyDataPoint> filled = [];
//
//     for (int day = 0; day < 7; day++) {
//       final DateTime currentDay = monday.add(Duration(days: day));
//
//       // Get all data points for this day
//       final dayPoints = apiData.where((d) =>
//       d.time.year == currentDay.year &&
//           d.time.month == currentDay.month &&
//           d.time.day == currentDay.day &&
//           d.value != null
//       ).toList();
//
//       double? firstValue;
//       if (dayPoints.isNotEmpty) {
//         firstValue = dayPoints.first.value;
//       }
//
//       if (currentDay.isAfter(today)) {
//         filled.add(WeeklyDataPoint(time: currentDay, value: null));
//       } else {
//         filled.add(WeeklyDataPoint(time: currentDay, value: firstValue));
//       }
//     }
//
//     return filled;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final DateTime now = DateTime.now();
//     final DateTime monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
//     final DateTime sunday = monday.add(const Duration(days: 6));
//     final List<WeeklyDataPoint> data = fillMissingWeekData(now, apiData);
//
//     final TooltipBehavior tooltipBehavior = TooltipBehavior(
//       enable: true,
//       tooltipPosition: TooltipPosition.pointer,
//       borderWidth: 0,
//       canShowMarker: false,
//       format: 'point.y',
//     );
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 1.5.w),
//       decoration: BoxDecoration(
//         color: Theme.of(context).brightness == Brightness.dark
//             ? Colors.black12
//             : const Color(0xFFF6F6F6),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: SfCartesianChart(
//         title: ChartTitle(
//           text: 'Overall Performance',
//           textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         tooltipBehavior: tooltipBehavior,
//         backgroundColor: Colors.transparent,
//         plotAreaBorderWidth: 0,
//         primaryXAxis: DateTimeAxis(
//           opposedPosition: true,
//           minimum: monday,
//           maximum: sunday,
//           interval: 1,
//           intervalType: DateTimeIntervalType.days,
//           dateFormat: DateFormat('EEE\nd'),
//           edgeLabelPlacement: EdgeLabelPlacement.none,
//           axisLine: const AxisLine(width: 0),
//           majorGridLines: MajorGridLines(
//             width: 1,
//             dashArray: [4, 2],
//             color: Colors.grey.withOpacity(0.3),
//           ),
//         ),
//         primaryYAxis: NumericAxis(
//           isVisible: true,
//           minimum: 0,
//           maximum: data.where((e) => e.value != null).isNotEmpty
//               ? (data.map((e) => e.value ?? 0).reduce((a, b) => a > b ? a : b) * 1.2)
//               : 10000,
//         ),
//         series: <CartesianSeries>[
//           SplineAreaSeries<WeeklyDataPoint, DateTime>(
//             dataSource: data,
//             xValueMapper: (point, _) => point.time,
//             yValueMapper: (point, _) => point.value,
//             gradient: LinearGradient(
//               colors: [Colors.blue.withOpacity(0.5), Colors.transparent],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             borderColor: Colors.blue,
//             borderWidth: 2,
//             name: 'Performance',
//             markerSettings: const MarkerSettings(isVisible: false),
//           ),
//         ],
//       ),
//     );
//   }
// }




class WeeklyPerformanceChart extends StatelessWidget {
  final List<WeeklyDataPoint> apiData;
  const WeeklyPerformanceChart({super.key, required this.apiData});

  List<WeeklyDataPoint> fillMissingWeekData(DateTime now, List<WeeklyDataPoint> apiData) {
    final DateTime monday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final DateTime sunday = monday.add(const Duration(days: 6));
    List<WeeklyDataPoint> filled = [];

    // Extract unique time slots (hour, minute, second) from existing API data within the week
    Set<TimeOfDay> uniqueTimes = apiData
        .where((d) => d.time != null && d.time!.isAfter(monday) && d.time!.isBefore(sunday.add(Duration(days: 1))))
        .map((d) => TimeOfDay(hour: d.time!.hour, minute: d.time!.minute))
        .toSet();

    for (int day = 0; day < 7; day++) {
      final currentDate = monday.add(Duration(days: day));

      for (final time in uniqueTimes) {
        final DateTime slotTime = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          time.hour,
          time.minute,
          0,
        );

        final match = apiData.firstWhere(
              (d) =>
          d.time?.year == slotTime.year &&
              d.time?.month == slotTime.month &&
              d.time?.day == slotTime.day &&
              d.time?.hour == slotTime.hour &&
              d.time?.minute == slotTime.minute,
          orElse: () => WeeklyDataPoint(time: slotTime, value: null),
        );

        filled.add(match);
      }
    }

    return filled;
  }




  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final DateTime sunday = monday.add(const Duration(days: 6));
    final List<WeeklyDataPoint> data = fillMissingWeekData(now, apiData);

    final TooltipBehavior tooltipBehavior = TooltipBehavior(
      enable: true,
      tooltipPosition: TooltipPosition.pointer,
      borderWidth: 0,
      canShowMarker: false,
      format: 'point.y',
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.5.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black12
            : const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(20),
      ),
      // padding: const EdgeInsets.all(2),
      child: SfCartesianChart(
        title: ChartTitle(
          text: 'Overall Performance',
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        tooltipBehavior: tooltipBehavior,
        backgroundColor: Colors.transparent,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
          opposedPosition: true,
          minimum: monday,
          maximum: sunday,
          interval: 1,
          intervalType: DateTimeIntervalType.days,
          dateFormat: DateFormat('EEE\nd'),
          edgeLabelPlacement: EdgeLabelPlacement.none,
          axisLine: const AxisLine(width: 0),
          majorGridLines: MajorGridLines(
            width: 1,
            dashArray: [4, 2],
            color: Colors.grey.withValues(alpha: 0.3),
          ),
        ),

        primaryYAxis: NumericAxis(
          isVisible: true,
          minimum: 0,
          plotOffsetStart: 10,
          maximum: data.where((e) => e.value != null).isNotEmpty ? (data.map((e) => e.value ?? 0).reduce((a, b) => a > b ? a : b) * 4) : 10000,
        ),

        series: <CartesianSeries>[
          SplineAreaSeries<WeeklyDataPoint, DateTime>(
            dataSource: data,
            xValueMapper: (point, _) => point.time,
            yValueMapper: (point, _) => point.value,
            gradient: LinearGradient(
              colors: [Colors.blue.withValues(alpha: 0.5), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderColor: Colors.blue,
            borderWidth: 2,
            name: 'Balance',
            markerSettings: MarkerSettings(isVisible: true,color: ThemeProvider.primary),
          ),
        ],
      ),
    );
  }
}
 




class MonthlyPerformanceChart extends StatelessWidget {
  const MonthlyPerformanceChart({super.key});

  List<DailyDataPoint> getLast30DaysData() {
    final now = DateTime.now();
    return List.generate(30, (i) {
      final day = now.subtract(Duration(days: 29 - i)); // oldest to today
      final value = 2.0 + (i % 7) + (i % 3 * 0.5); // mock data
      return DailyDataPoint(date: day, value: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<DailyDataPoint> data = getLast30DaysData();

    final List<FlSpot> spots = data.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      return FlSpot(index, entry.value.value);
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 2.w),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ?Colors.white10
              :Color(0XFFF6F6F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: data.length.toDouble() - 1,
            minY: 0,
            maxY: 10, // or dynamically calculate based on data
            gridData: FlGridData(
              show: true,
              verticalInterval: 5,
              drawHorizontalLine: false,
              drawVerticalLine: true,
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.grey.withValues(alpha: 0.3),
                  strokeWidth: 1,
                  dashArray: [4, 2], // remove this line if you want solid lines
                );
              },
            ),

            extraLinesData: ExtraLinesData(
              verticalLines: [
                VerticalLine(x: 0, color: Colors.grey.withValues(alpha: 0.3), strokeWidth: 1, dashArray: [4, 2]),
                VerticalLine(x: 29, color: Colors.grey.withValues(alpha: 0.3), strokeWidth: 1, dashArray: [4, 2]),
              ],
            ),
            borderData: FlBorderData(show: false), // ✅ remove box/border
            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 5,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= data.length) return const SizedBox.shrink();
                    final date = data[index].date;
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        DateFormat('d MMM').format(date),
                        style: TextStyle(fontSize: 10,color: Theme.of(context).brightness == Brightness.dark
                            ?Colors.white70
                            :Color(0XFF000000)),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 8,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final day = data[spot.x.toInt()].date;
                    return LineTooltipItem(
                      '${DateFormat('MMM d').format(day)}\nValue: ${spot.y.toStringAsFixed(1)}',
                      TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ?Colors.white70
                            :Color(0XFF000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 2,
                color: Colors.blue,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [Colors.blue.withValues(alpha: 0.3), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                dotData: FlDotData(show: false),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class YearlyPerformanceChart extends StatelessWidget {
  const YearlyPerformanceChart({super.key});

  List<DailyDataPoint> getLast12MonthsData() {
    final now = DateTime.now();
    return List.generate(12, (i) {
      final date = DateTime(now.year, now.month - 11 + i);
      final value = 5 + (i % 5) * 2.0 + (i % 3); // mock value
      return DailyDataPoint(date: date, value: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<DailyDataPoint> data = getLast12MonthsData();

    final List<FlSpot> spots = data.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      return FlSpot(index, entry.value.value);
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 2.w),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ?Colors.white10
              :Color(0XFFF6F6F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: data.length.toDouble() - 1,
            minY: 0,
            maxY: 15, // adjust if needed
            gridData: FlGridData(
              show: true,
              verticalInterval: 1,
              drawHorizontalLine: false,
              drawVerticalLine: true,
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.grey.withValues(alpha: 0.3),
                  strokeWidth: 1,
                  dashArray: [4, 2], // remove this line if you want solid lines
                );
              },
            ),
            extraLinesData: ExtraLinesData(
              verticalLines: [
                VerticalLine(x: 0, color: Colors.grey.withValues(alpha: 0.3), strokeWidth: 1, dashArray: [4, 2]),
                VerticalLine(x: 11, color: Colors.grey.withValues(alpha: 0.3), strokeWidth: 1, dashArray: [4, 2]),
              ],
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= data.length) return const SizedBox.shrink();
                    final date = data[index].date;
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        DateFormat('MMM').format(date), // Jan, Feb...
                        style: TextStyle(fontSize: 10,color: Theme.of(context).brightness == Brightness.dark
                            ?Colors.white70
                            :Color(0XFF000000),),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 8,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final month = data[spot.x.toInt()].date;
                    return LineTooltipItem(
                      '${DateFormat('MMM yyyy').format(month)}\nValue: ${spot.y.toStringAsFixed(1)}',
                      TextStyle(
                        color:Theme.of(context).brightness == Brightness.dark
                            ?Colors.white70
                            :Color(0XFF000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 2,
                color: Colors.blue,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [Colors.blue.withValues(alpha: 0.3), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                dotData: FlDotData(show: false),
              )
            ],
          ),
        ),
      ),
    );
  }
}