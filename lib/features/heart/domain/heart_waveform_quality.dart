/// Signal-quality gate for band waveform recordings (PPG pulse wave).
///
/// Runs on the completed capture BEFORE anything is saved: a rejected
/// waveform never reaches the server, so it can never feed blood-pressure
/// estimates or ATLAS. Deliberately conservative — only clearly bad signals
/// (flatline, stuck value, no-contact zeros, or no pulse oscillation) are
/// rejected; borderline recordings pass so valid readings are not lost.
bool heartWaveformLooksValid(List<int> samples, {int minCycles = 10}) {
  // A ~30s capture at the vendor's rate yields thousands of samples;
  // fewer than ~2.5s worth means the band never really streamed.
  if (samples.length < 250) return false;
  final sorted = [...samples]..sort();
  final range = sorted.last - sorted.first;
  // Perfectly flat trace = no optical signal at all.
  if (range <= 0) return false;

  final median = sorted[sorted.length ~/ 2];
  // Stuck-value trace: >90% of samples share the median value.
  var stuck = 0, zeros = 0;
  for (final s in samples) {
    if (s == median) stuck++;
    if (s == 0) zeros++;
  }
  if (stuck / samples.length > 0.9) return false;
  // Sensor off-contact: the vendor streams zeros without skin contact.
  if (zeros / samples.length > 0.6) return false;

  // Hysteresis peak counting: a pulse wave must oscillate. The threshold
  // uses the 2nd–98th percentile range, not max–min, so a single motion
  // artifact cannot inflate it enough to hide the real pulse cycles.
  final lo = sorted[(sorted.length * 0.02).floor()];
  final hiIndex = (sorted.length * 0.98).floor().clamp(0, sorted.length - 1);
  final robustRange = (sorted[hiIndex] - lo) > 0 ? sorted[hiIndex] - lo : range;
  final threshold = robustRange * 0.35;
  var extreme = samples.first;
  var inPeak = false;
  var cycles = 0;
  for (var i = 1; i < samples.length; i++) {
    final s = samples[i];
    if (!inPeak) {
      if (s < extreme) extreme = s;
      if (s - extreme >= threshold) {
        extreme = s;
        inPeak = true;
      }
    } else {
      if (s > extreme) extreme = s;
      if (extreme - s >= threshold) {
        cycles++;
        extreme = s;
        inPeak = false;
      }
    }
  }
  // 10 full cycles in ~30s ≈ a 20 bpm floor; anything slower-looking
  // (or arrhythmic drift) has no usable pulse.
  return cycles >= minCycles;
}
