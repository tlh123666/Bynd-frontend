import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../heart_copy.dart';
import '../../domain/heart_models.dart';
import 'heart_charts.dart';

class HeartRecordPreview extends StatefulWidget {
  const HeartRecordPreview({
    required this.repository,
    required this.record,
    super.key,
  });
  final HeartRepository repository;
  final HeartRecording record;
  @override
  State<HeartRecordPreview> createState() => _HeartRecordPreviewState();
}

class _HeartRecordPreviewState extends State<HeartRecordPreview> {
  late Future<HeartRecording> _future = _load();
  Future<HeartRecording> _load() => widget.record.samples.isNotEmpty
      ? Future.value(widget.record)
      : widget.repository.recording(widget.record.id);
  @override
  void didUpdateWidget(HeartRecordPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.record.id != widget.record.id ||
        oldWidget.repository != widget.repository) {
      _future = _load();
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 64,
    child: FutureBuilder<HeartRecording>(
      future: _future,
      builder: (c, s) => s.data?.available == true
          ? HeartWaveform(samples: s.data!.samples, height: 42)
          : const Icon(
              Icons.monitor_heart_outlined,
              color: AppHeartStyle.family,
              size: 28,
            ),
    ),
  );
}

class HeartLabel extends StatelessWidget {
  const HeartLabel(this.text, {this.chevron = false, super.key});
  final String text;
  final bool chevron;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(text.toUpperCase(), style: AppHeartStyle.kicker)),
      if (chevron)
        const Icon(Icons.chevron_right, size: 18, color: AppHeartStyle.muted),
    ],
  );
}

class HeartExpandable extends StatefulWidget {
  const HeartExpandable(this.text, {super.key});
  final String text;
  @override
  State<HeartExpandable> createState() => _HeartExpandableState();
}

class _HeartExpandableState extends State<HeartExpandable> {
  bool open = false;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.text,
        style: AppHeartStyle.body,
        maxLines: open ? null : 3,
        overflow: open ? null : TextOverflow.fade,
      ),
      if (widget.text.length > 150)
        TextButton.icon(
          onPressed: () => setState(() => open = !open),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            textStyle: AppHeartStyle.body,
          ),
          iconAlignment: IconAlignment.end,
          icon: Icon(open ? Icons.expand_less : Icons.expand_more, size: 16),
          label: Text(
            heartText(
              context,
              open ? 'Mostrar menos' : 'Mostrar mais',
              open ? 'Show less' : 'Show more',
            ),
          ),
        ),
    ],
  );
}

class HeartReadingRow extends StatelessWidget {
  const HeartReadingRow(this.label, this.value, {this.onTap, super.key});
  final String label, value;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label, style: AppHeartStyle.body),
    trailing: Text(value, style: AppHeartStyle.body),
    onTap: onTap,
  );
}

class HeartStats extends StatelessWidget {
  const HeartStats(this.values, {super.key});
  final List<(String, String)> values;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final value in values)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Text(
                  value.$1,
                  style: AppHeartStyle.caption,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 7),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value.$2,
                    style: AppHeartStyle.value.copyWith(fontSize: 22),
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}
