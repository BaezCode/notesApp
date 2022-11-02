import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:record/record.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  Timer? _timer;
  final _audioRecorder = Record();

  AudioBloc() : super(AudioState()) {
    on<SetTimer>((event, emit) {
      emit(state.copyWith(
          recordDuration: event.recordDuration,
          seconds: event.seconds,
          minutes: event.minutes,
          path: ''));
    });
    on<StopStart>((event, emit) {
      emit(state.copyWith(stop: event.stop));
    });
    on<SetPath>((event, emit) {
      emit(state.copyWith(
          totalDuration: '${state.minutes}:${state.seconds}',
          stop: event.stop,
          path: event.path));
    });
    on<SetDuration>((event, emit) {
      emit(state.copyWith(duration: event.duration));
    });
    on<SetPosition>((event, emit) {
      emit(state.copyWith(position: event.position));
    });
    on<IsPLaying>((event, emit) {
      emit(state.copyWith(isPlaying: event.isPlaying));
    });
    on<ChargerAudio>((event, emit) {
      emit(state.copyWith(path: event.path));
    });
  }

  Future<void> start() async {
    add(SetTimer('00', '00', 0));

    if (await _audioRecorder.hasPermission()) {
      await _audioRecorder.start();
      starTimer(0);
      add(SetPath('', false));
    }
  }

  void starTimer(int duration) {
    int _duration = duration;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _duration++;
      String minutes = _formatNumber(_duration ~/ 60);
      String seconds = _formatNumber(_duration % 60);
      add(SetTimer(minutes, seconds, _duration));
    });
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  Future<void> pauseTimer() async {
    _timer?.cancel();
    await _audioRecorder.pause();
    add(StopStart(true));
  }

  Future<void> resumeTimer() async {
    add(StopStart(false));
    await _audioRecorder.resume();
    starTimer(state.recordDuration);
  }

  Future<void> confirmAudio() async {
    _timer?.cancel();
    final path = await _audioRecorder.stop();
    File file = File(path!);
    String img64 = base64Encode(file.readAsBytesSync());

    add(SetPath(img64, true));
  }

  Future<void> stopTimer() async {
    _timer?.cancel();
    await _audioRecorder.stop();
    add(SetTimer('00', '00', 0));
    add(StopStart(false));
  }

  String formatTime(Duration duration) {
    String towDigits(int n) => n.toString().padLeft(2, '0');
    final hours = towDigits(duration.inHours);
    final minutes = towDigits(duration.inMinutes.remainder(60));
    final seconds = towDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}
