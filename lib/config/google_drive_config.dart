class GoogleDriveConfig {
  // Google Drive OAuth Client IDs
  // These will be loaded from environment or config file
  static String get androidClientId => const String.fromEnvironment(
    'GOOGLE_DRIVE_ANDROID_CLIENT_ID',
    defaultValue: 'YOUR_ANDROID_CLIENT_ID',
  );

  static String get webClientId => const String.fromEnvironment(
    'GOOGLE_DRIVE_WEB_CLIENT_ID',
    defaultValue: 'YOUR_WEB_CLIENT_ID',
  );

  static String get clientSecret => const String.fromEnvironment(
    'GOOGLE_DRIVE_CLIENT_SECRET',
    defaultValue: 'YOUR_CLIENT_SECRET',
  );

  // Google Drive Project
  static const String projectId = 'homigo-care-drive';
  static const String projectNumber = '574032802673';

  // Shared Drive Folder IDs
  static const String sharedDriveId = '1AtnCnCN9zucmEE4oGfdV6I6HgYKZywhM';
  static const String userProfileImagesFolder = '1o9czzz2yAqDeUNd9iRTkK9imSwM666xz';
  static const String doctorDocumentsFolder = '1uZQ7UODmciHKEgjEq2RG08IeOnJpbL7G';
  static const String nurseDocumentsFolder = '1MGbq2-LB9oYU9k7HFMGBn4UlJh11wFYN';
  static const String labDocumentsFolder = '1gasYeJumsu88Lig1mFY_WWqY-BuucZFD';
  static const String patientLabReportsFolder = '1UtC0OfEUxpTuJFKIiE4R7cHGw2nDdjDw';
  static const String chatImagesFolder = '1xN-WheNYxTMpjEbNf0frZEV5BSUEQn0d';
  static const String appAssetsFolder = '1QihaPeLU_JGj03gdTVzJduto4c4XJdph';

  // Scopes required for Google Drive access
  static const List<String> scopes = [
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive.appdata',
  ];

  // API Base URLs
  static const String driveApiBase = 'https://www.googleapis.com/drive/v3';
  static const String uploadApiBase = 'https://www.googleapis.com/upload/drive/v3';
}
