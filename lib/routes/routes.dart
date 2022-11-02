import 'package:flutter/material.dart';
import 'package:notes/pages/audio_page.dart';
import 'package:notes/pages/backup_page.dart';
import 'package:notes/pages/images_page.dart';
import 'package:notes/pages/pdfs.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'imagePage': (_) => const ImagesPage(
        data: null,
      ),
  'pdfs': (_) => const PdfsPage(),
  'audio': (_) => const AudioPage(
        data: null,
      ),
  'backup': (_) => const BackUpPage(),
};
