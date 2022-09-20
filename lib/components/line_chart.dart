import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

import 'WeightData.dart';

Widget WeightLineChart({required List<WeightData> data, required String chartName}){
  List<charts.Series<WeightData, DateTime>> lineChartData = [
    charts.Series<WeightData, DateTime>(
      id: chartName,
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (WeightData wd, _) => wd.getDateTime(),
      measureFn: (WeightData wd, _) => wd.weight,
      data: data,
    )
  ];
  return charts.TimeSeriesChart(
    lineChartData,
    defaultRenderer: charts.LineRendererConfig(includePoints: true),
    secondaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec:
        charts.BasicNumericTickProviderSpec(desiredMinTickCount: 7)),
    primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec:
        charts.BasicNumericTickProviderSpec(zeroBound: false)),
    animate: true,
      behaviors: [
        LinePointHighlighter(
          drawFollowLinesAcrossChart: true,
          showHorizontalFollowLine: LinePointHighlighterFollowLineType.all,
        ),
        PanAndZoomBehavior(),
      ],
  );
}