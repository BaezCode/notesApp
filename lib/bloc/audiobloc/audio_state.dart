part of 'audio_bloc.dart';

class AudioState {
  final int recordDuration;
  final String seconds;
  final String minutes;
  final bool stop;
  final String path;
  final Duration duration;
  final Duration position;
  final bool isPlaying;
  final String totalDuration;

  AudioState(
      {this.recordDuration = 0,
      this.minutes = '00',
      this.seconds = '00',
      this.stop = false,
      this.path = '',
      this.duration = Duration.zero,
      this.position = Duration.zero,
      this.isPlaying = false,
      this.totalDuration = '00:00'});

  AudioState copyWith({
    int? recordDuration,
    String? seconds,
    String? minutes,
    bool? stop,
    String? path,
    Duration? duration,
    Duration? position,
    bool? isPlaying,
    String? totalDuration,
  }) =>
      AudioState(
          recordDuration: recordDuration ?? this.recordDuration,
          seconds: seconds ?? this.seconds,
          minutes: minutes ?? this.minutes,
          stop: stop ?? this.stop,
          path: path ?? this.path,
          duration: duration ?? this.duration,
          position: position ?? this.position,
          isPlaying: isPlaying ?? this.isPlaying,
          totalDuration: totalDuration ?? this.totalDuration);
}
