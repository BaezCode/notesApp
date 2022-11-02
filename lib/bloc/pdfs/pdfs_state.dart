part of 'pdfs_bloc.dart';

class PdfsState {
  final List<PdfsModel> pdfs;
  final bool password;
  final String passwordData;

  PdfsState(
      {this.pdfs = const [], this.password = true, this.passwordData = ''});

  PdfsState copyWith(
          {List<PdfsModel>? pdfs, bool? password, String? passwordData}) =>
      PdfsState(
          pdfs: pdfs ?? this.pdfs,
          password: password ?? this.password,
          passwordData: passwordData ?? this.passwordData);
}
