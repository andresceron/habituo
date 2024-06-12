import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final DateTime startDate;

  const MyHeatMap({
    super.key,
    required this.startDate,
    required this.datasets,
  });

  @override
  Widget build(BuildContext context) {
    // return HeatMapCalendar(
    //   defaultColor: Colors.white,
    //   flexible: true,
    //   colorMode: ColorMode.color,
    //   showColorTip: false,
    //   datasets: datasets,
    //   colorsets: {
    //     1: Colors.green.shade100,
    //     2: Colors.green.shade200,
    //     3: Colors.green.shade300,
    //     4: Colors.green.shade400,
    //     5: Colors.green.shade500,
    //     6: Colors.green.shade600,
    //     7: Colors.green.shade700,
    //     8: Colors.green.shade800,
    //     9: Colors.green.shade900,
    //   },
    //   // onClick: (value) {
    //   //   ScaffoldMessenger.of(context)
    //   //       .showSnackBar(SnackBar(content: Text(value.toString())));
    //   // },
    // );

    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, 1, 1);
    DateTime endDate = DateTime(now.year, 12, 31);

    return HeatMap(
      startDate: startDate,
      endDate: endDate,
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.primary,
      showColorTip: false,
      showText: false,
      scrollable: true,
      size: 30,
      colorsets: {
        1: Colors.green.shade100,
        2: Colors.green.shade200,
        3: Colors.green.shade300,
        4: Colors.green.shade400,
        5: Colors.green.shade500,
        6: Colors.green.shade600,
        7: Colors.green.shade700,
        8: Colors.green.shade800,
        9: Colors.green.shade900,
      },
    );
  }
}
