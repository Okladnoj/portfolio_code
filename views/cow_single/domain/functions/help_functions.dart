/// Calculate Max and Min
Map<String, double> getMaxMin(List<double> list) {
  final List<double> _list = list ?? [];
  final List<double> chart = [..._list.where((e) => e != null).toList()];
  chart.sort();

  if (chart.isNotEmpty) {
    final delta = chart.last - chart.first;
    final coefficient = (delta / 100) * 5;
    return {
      'maxTemperature': (chart.last + coefficient).rou,
      'minTemperature': (chart.first - coefficient).rou,
    };
  } else {
    return {
      'maxTemperature': null,
      'minTemperature': null,
    };
  }
}

extension EDouble on double {
  double get rou => double.parse(toStringAsFixed(2));
}

double safeDouble(dynamic _) {
  final String _str = '$_';
  double _n;
  try {
    _n = num.parse(_str).toDouble();
  } catch (e) {
    _n = 0;
  }
  return _n;
}

int safeInt(dynamic _) {
  final String _str = '$_';
  int _n;
  try {
    _n = num.parse(_str).toInt();
  } catch (e) {
    _n = 0;
  }
  return _n;
}
