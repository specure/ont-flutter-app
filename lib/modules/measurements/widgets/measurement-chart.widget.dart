import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/measurements/constants/measurement-phase.dart';
import 'package:nt_flutter_standalone/modules/measurements/screens/measurement.screen.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.bloc.dart';
import 'package:nt_flutter_standalone/modules/measurements/store/measurements.state.dart';

class MeasurementChart extends StatefulWidget {
  static const xStep = 160;

  const MeasurementChart({Key? key}) : super(key: key);

  @override
  _MeasurementChartState createState() => _MeasurementChartState();
}

class _MeasurementChartState extends State<MeasurementChart> {
  late StreamSubscription<MeasurementsState> _progressSub;
  List<_Spot> _spots = [_Spot(0, 0)];
  Timer? _timer;
  double _lastX = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _progressSub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _progressSub = GetIt.I
        .get<MeasurementsBloc>()
        .stream
        .distinct((a, b) => a.phase == b.phase)
        .listen(_updateProgressTween);
  }

  @override
  Widget build(BuildContext context) {
    final state = GetIt.I.get<MeasurementsBloc>().state;
    return Container(
        height: 42,
        child: ConditionalContent(
          conditional: _isChartPhase(state) || _isPostChartPhase(state),
          truthyBuilder: () => LayoutBuilder(builder: (context, constraints) {
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _ChartPainter.forSpots(_spots),
            );
          }),
        ));
  }

  bool _isChartPhase(MeasurementsState state) => [
        MeasurementPhase.down,
        MeasurementPhase.up,
      ].contains(state.phase);

  bool _isPostChartPhase(MeasurementsState state) => [
        MeasurementPhase.initUp,
        MeasurementPhase.submittingTestResult,
      ].contains(state.phase);

  void _setSpots() {
    final state = GetIt.I.get<MeasurementsBloc>().state;
    if (!_isChartPhase(state)) {
      return;
    }
    setState(() {
      _lastX = _lastX + MeasurementChart.xStep;
      _spots.add(_Spot(_lastX, state.lastResultForCurrentPhase));
    });
  }

  _updateProgressTween(MeasurementsState state) {
    if (!_isPostChartPhase(state)) {
      _spots = [_Spot(0, 0)];
    }
    _lastX = 0;
    _timer?.cancel();
    if (_isChartPhase(state)) {
      _timer = Timer.periodic(
        Duration(milliseconds: MeasurementChart.xStep),
        (timer) {
          _setSpots();
        },
      );
    }
  }
}

class _ChartPainter extends CustomPainter {
  final List<_Spot> spots;
  final double _maxX = MeasurementScreen.defaultTestDuration.toDouble() * 1000;
  late double _maxY;
  late Canvas _canvas;
  late Size _size;

  _ChartPainter.forSpots(this.spots);

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;
    _maxY = spots.reduce((acc, next) => acc.y < next.y ? next : acc).y;
    _drawBorder();
    _drawGradient();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawBorder() {
    final Paint curvePaint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        colors: [
          NTColors.measurementBoxGradient1,
          NTColors.measurementBoxGradient2,
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, _size.width, _size.height),
      );
    _canvas.drawPath(
      _drawCurve(),
      curvePaint,
    );
  }

  void _drawGradient() {
    final Paint curvePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.1),
          Colors.black.withOpacity(0.01),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, _size.width, _size.height),
      );
    _canvas.drawPath(
      _drawCurve(close: true),
      curvePaint,
    );
  }

  Path _drawCurve({close = false}) {
    Path path = Path();
    path.moveTo(0, _size.height);
    double lastX = 0;
    for (var i = 1; i < spots.length - 1; i++) {
      final spot1 = spots[i];
      path.lineTo(_absoluteX(spot1.x), _absoluteY(spot1.y));
      lastX = _absoluteX(spot1.x);
      if (_absoluteX(spot1.x) >= _size.width) {
        break;
      }
    }
    if (close) {
      path.lineTo(lastX, _size.height);
      path.lineTo(0, _size.height);
      path.close();
    }
    return path;
  }

  double _absoluteX(double x) {
    return x * _size.width / _maxX;
  }

  double _absoluteY(double y) {
    return _size.height - y * _size.height / _maxY;
  }
}

class _Spot {
  final double x;
  final double y;

  _Spot(this.x, this.y);

  @override
  String toString() {
    return '{ x: $x, y: $y }';
  }
}
