class AppInfo {
  final String packageName;
  final String appName;

  const AppInfo({
    required this.packageName,
    required this.appName,
  });

  factory AppInfo.fromMap(Map<String, dynamic> map) {
    return AppInfo(
      packageName: map['packageName'] as String,
      appName: map['appName'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'appName': appName,
    };
  }
}
