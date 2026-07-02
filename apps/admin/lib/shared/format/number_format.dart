/// Formats an integer with comma thousands separators, matching the designer's
/// `toLocaleString()` output (e.g. 5120400 -> "5,120,400").
String groupThousands(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }
  final grouped = buffer.toString();
  return value < 0 ? '-$grouped' : grouped;
}
