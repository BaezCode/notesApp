part of 'audio_bloc.dart';

@immutable
abstract class AudioEvent {}

class SetTimer extends AudioEvent {
  final String minutes;
  final String seconds;
  final int recordDuration;

  SetTimer(this.minutes, this.seconds, this.recordDuration);
}

class StopStart extends AudioEvent {
  final bool stop;

  StopStart(this.stop);
}

class SetPath extends AudioEvent {
  final String path;
  final bool stop;

  SetPath(
    this.path,
    this.stop,
  );
}

class SetDuration extends AudioEvent {
  final Duration duration;

  SetDuration(this.duration);
}

class SetPosition extends AudioEvent {
  final Duration position;

  SetPosition(this.position);
}

class IsPLaying extends AudioEvent {
  final bool isPlaying;

  IsPLaying(this.isPlaying);
}

class ChargerAudio extends AudioEvent {
  final String path;
  final String totalDuration;

  ChargerAudio(this.path, this.totalDuration);
}
