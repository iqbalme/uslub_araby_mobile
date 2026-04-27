import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  static final AppInfoService _instance = AppInfoService._internal();

  AppInfoService._internal();

  factory AppInfoService() {
    return _instance;
  }

  // Display name konstant (berbeda dari package name)
  static const String appDisplayName = 'Kamus Uslub';
  static const String appDescription =
      '''Aplikasi pembelajaran bahasa Arab yang dirancang khusus untuk membantu Anda mempelajari ungkapan dan idiom dalam bahasa Arab dengan cara yang menyenangkan dan interaktif.

Semua ungkapan yang ada di dalam aplikasi ini diambil dari tulisan **Ust. Dr. Nasaruddin Jauhar** dalam program "Nambah Uslub" di Facebook dan Aplikasi ini juga langsung di bawah bimbingan dan pengawasan beliau. Dengan fitur pencarian yang cerdas, Anda dapat dengan mudah menemukan ungkapan yang ingin dipelajari, serta menyimpan favorit untuk akses cepat.

Kami berharap aplikasi ini dapat menjadi teman belajar yang menyenangkan dan bermanfaat bagi semua pengguna yang ingin menguasai bahasa Arab.''';
  static const String appDeveloper = 'Muhammad Iqbal, Lc.';

  late PackageInfo _packageInfo;

  Future<void> initialize() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  /// Get app version dari pubspec.yaml
  /// Format: "1.0.0" (versi tanpa build number)
  String get appVersion => _packageInfo.version;

  /// Get full version dengan build number
  /// Format: "1.0.0+1"
  String get fullVersion =>
      '${_packageInfo.version}+${_packageInfo.buildNumber}';

  /// Get package name dari pubspec.yaml
  String get packageName => _packageInfo.packageName;

  /// Get app display name
  String get displayName => appDisplayName;

  /// Get app description
  String get description => appDescription;

  /// Get developer name
  String get developerName => appDeveloper;
}
