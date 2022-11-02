part of 'pdfs_bloc.dart';

@immutable
abstract class PdfsEvent {}

class SetPdfs extends PdfsEvent {
  final List<PdfsModel> pdfs;

  SetPdfs(this.pdfs);
}

class ActivePassword extends PdfsEvent {
  final bool password;

  ActivePassword(this.password);
}

class SetPasswordData extends PdfsEvent {
  final String passwordData;

  SetPasswordData(this.passwordData);
}
