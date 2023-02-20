abstract class AppConstants {
  //============================================================================
  //--------------------------Database Related----------------------------------
  //============================================================================
  static const String dbName = 'coreDb';
  static const String coursePlanDbKey = 'coursePlan';
  static const String preferenceDbKey = 'appPreferences';
  static const String dataAvailabilityKey = 'dataAvailable';

  //============================================================================
  //--------------------------Online Related----------------------------------
  //============================================================================
  static const String rawUrl =
      'https://raw.githubusercontent.com/wasikulaminbipu/bsmrau_cg/master';
  static const String rawDbUrl = '$rawUrl/db/';
  static const String parentDbUrl = '$rawDbUrl/parent_db.csv';
  static const String releasesDbUrl = '$rawDbUrl/app_releases.csv';

  //============================================================================
  //--------------------------Contacts Related----------------------------------
  //============================================================================
  static const String phone = '+8801521439342';
  static const String mail = 'wasikulaminbipu@gmail.com';
  static const String mailSubject = 'BSMRAU CG: Issues';
  static const String mailBody =
      'BSMRAU CG: \n Name: \n Batch: \n Faculty: \n Issues: \n';
}
