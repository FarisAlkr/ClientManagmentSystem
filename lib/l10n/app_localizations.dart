import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('he')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Client Management'**
  String get appTitle;

  /// No description provided for @clientManagement.
  ///
  /// In en, this message translates to:
  /// **'Client Management'**
  String get clientManagement;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enterEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get enterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @confirmPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordMessage;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsDontMatch;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @signInToSystem.
  ///
  /// In en, this message translates to:
  /// **'Sign in to system'**
  String get signInToSystem;

  /// No description provided for @signUpToSystem.
  ///
  /// In en, this message translates to:
  /// **'Register to system'**
  String get signUpToSystem;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreated;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @userDisabled.
  ///
  /// In en, this message translates to:
  /// **'User account is disabled'**
  String get userDisabled;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later'**
  String get tooManyRequests;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak'**
  String get weakPassword;

  /// No description provided for @emailInUse.
  ///
  /// In en, this message translates to:
  /// **'The email is already in use'**
  String get emailInUse;

  /// No description provided for @operationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Registration is not enabled'**
  String get operationNotAllowed;

  /// No description provided for @southernCities.
  ///
  /// In en, this message translates to:
  /// **'Southern Cities'**
  String get southernCities;

  /// No description provided for @searchCities.
  ///
  /// In en, this message translates to:
  /// **'Search cities...'**
  String get searchCities;

  /// No description provided for @noCitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No cities found for'**
  String get noCitiesFound;

  /// No description provided for @noCitiesInSystem.
  ///
  /// In en, this message translates to:
  /// **'No cities in system'**
  String get noCitiesInSystem;

  /// No description provided for @addSouthernCities.
  ///
  /// In en, this message translates to:
  /// **'Add southern Israeli cities'**
  String get addSouthernCities;

  /// No description provided for @addSampleCities.
  ///
  /// In en, this message translates to:
  /// **'Add sample cities'**
  String get addSampleCities;

  /// No description provided for @addNewCity.
  ///
  /// In en, this message translates to:
  /// **'Add New City'**
  String get addNewCity;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @clientDetails.
  ///
  /// In en, this message translates to:
  /// **'Client Details'**
  String get clientDetails;

  /// No description provided for @searchClients.
  ///
  /// In en, this message translates to:
  /// **'Search clients...'**
  String get searchClients;

  /// No description provided for @noClientsFound.
  ///
  /// In en, this message translates to:
  /// **'No clients found for'**
  String get noClientsFound;

  /// No description provided for @noClientsInCity.
  ///
  /// In en, this message translates to:
  /// **'No clients in'**
  String get noClientsInCity;

  /// No description provided for @addFirstClient.
  ///
  /// In en, this message translates to:
  /// **'Add first client to get started'**
  String get addFirstClient;

  /// No description provided for @addClient.
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get addClient;

  /// No description provided for @projectTasks.
  ///
  /// In en, this message translates to:
  /// **'Project Tasks'**
  String get projectTasks;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @projectSummary.
  ///
  /// In en, this message translates to:
  /// **'Project Summary'**
  String get projectSummary;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @overallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get overallProgress;

  /// No description provided for @stagesOf.
  ///
  /// In en, this message translates to:
  /// **'stages of'**
  String get stagesOf;

  /// No description provided for @projectStages.
  ///
  /// In en, this message translates to:
  /// **'Project Stages'**
  String get projectStages;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @addCustomTask.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Task'**
  String get addCustomTask;

  /// No description provided for @addCustomNote.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Note'**
  String get addCustomNote;

  /// No description provided for @writeTask.
  ///
  /// In en, this message translates to:
  /// **'Write task name...'**
  String get writeTask;

  /// No description provided for @writeNote.
  ///
  /// In en, this message translates to:
  /// **'Write note...'**
  String get writeNote;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @addNotes.
  ///
  /// In en, this message translates to:
  /// **'Add notes...'**
  String get addNotes;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get idNumber;

  /// No description provided for @committee.
  ///
  /// In en, this message translates to:
  /// **'Committee'**
  String get committee;

  /// No description provided for @errorLoadingClient.
  ///
  /// In en, this message translates to:
  /// **'Error loading client details'**
  String get errorLoadingClient;

  /// No description provided for @errorExportingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error exporting PDF'**
  String get errorExportingPdf;

  /// No description provided for @clientName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get clientName;

  /// No description provided for @clientId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get clientId;

  /// No description provided for @propertyAddress.
  ///
  /// In en, this message translates to:
  /// **'Property Address'**
  String get propertyAddress;

  /// No description provided for @handlingCommittee.
  ///
  /// In en, this message translates to:
  /// **'Handling Committee'**
  String get handlingCommittee;

  /// No description provided for @errorLoadingProject.
  ///
  /// In en, this message translates to:
  /// **'Error loading project'**
  String get errorLoadingProject;

  /// No description provided for @projectNotFound.
  ///
  /// In en, this message translates to:
  /// **'Project not found'**
  String get projectNotFound;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// No description provided for @addNewClientProject.
  ///
  /// In en, this message translates to:
  /// **'Add New Client/Project'**
  String get addNewClientProject;

  /// No description provided for @manageClients.
  ///
  /// In en, this message translates to:
  /// **'Manage Clients'**
  String get manageClients;

  /// No description provided for @committees.
  ///
  /// In en, this message translates to:
  /// **'Committees'**
  String get committees;

  /// No description provided for @searchClientsByCommittee.
  ///
  /// In en, this message translates to:
  /// **'Search Clients by Committee'**
  String get searchClientsByCommittee;

  /// No description provided for @globalClientSearch.
  ///
  /// In en, this message translates to:
  /// **'Search clients by committee'**
  String get globalClientSearch;

  /// No description provided for @enterCommitteeOrCity.
  ///
  /// In en, this message translates to:
  /// **'Enter committee or city name...'**
  String get enterCommitteeOrCity;

  /// No description provided for @searchResultsFor.
  ///
  /// In en, this message translates to:
  /// **'Search results for'**
  String get searchResultsFor;

  /// No description provided for @enterSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Enter search term to find clients'**
  String get enterSearchTerm;

  /// No description provided for @pendingTasks.
  ///
  /// In en, this message translates to:
  /// **'Pending Tasks'**
  String get pendingTasks;

  /// No description provided for @activeProjests.
  ///
  /// In en, this message translates to:
  /// **'Active Projects'**
  String get activeProjests;

  /// No description provided for @clientProjectManagementSystem.
  ///
  /// In en, this message translates to:
  /// **'Client Project Management System'**
  String get clientProjectManagementSystem;

  /// No description provided for @clientsFound.
  ///
  /// In en, this message translates to:
  /// **'clients found'**
  String get clientsFound;

  /// No description provided for @toggleLanguage.
  ///
  /// In en, this message translates to:
  /// **'Toggle Language'**
  String get toggleLanguage;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @addingCities.
  ///
  /// In en, this message translates to:
  /// **'Adding cities...'**
  String get addingCities;

  /// No description provided for @citiesAdded.
  ///
  /// In en, this message translates to:
  /// **'cities added successfully'**
  String get citiesAdded;

  /// No description provided for @errorAddingCities.
  ///
  /// In en, this message translates to:
  /// **'Error adding cities'**
  String get errorAddingCities;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System Mode'**
  String get systemMode;

  /// No description provided for @fileManagement.
  ///
  /// In en, this message translates to:
  /// **'File Management'**
  String get fileManagement;

  /// No description provided for @uploadNewFiles.
  ///
  /// In en, this message translates to:
  /// **'Upload New Files'**
  String get uploadNewFiles;

  /// No description provided for @uploadOneOrMoreFiles.
  ///
  /// In en, this message translates to:
  /// **'Upload one or more files to this task'**
  String get uploadOneOrMoreFiles;

  /// No description provided for @chooseFilesToUpload.
  ///
  /// In en, this message translates to:
  /// **'Choose Files to Upload'**
  String get chooseFilesToUpload;

  /// No description provided for @storageNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Storage not available'**
  String get storageNotAvailable;

  /// No description provided for @existingFiles.
  ///
  /// In en, this message translates to:
  /// **'Existing Files'**
  String get existingFiles;

  /// No description provided for @attachedFiles.
  ///
  /// In en, this message translates to:
  /// **'Attached Files'**
  String get attachedFiles;

  /// No description provided for @downloadAll.
  ///
  /// In en, this message translates to:
  /// **'Download All'**
  String get downloadAll;

  /// No description provided for @loadingFiles.
  ///
  /// In en, this message translates to:
  /// **'Loading files...'**
  String get loadingFiles;

  /// No description provided for @firebaseStorageNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Firebase Storage not configured'**
  String get firebaseStorageNotConfigured;

  /// No description provided for @needToConfigureStorageRules.
  ///
  /// In en, this message translates to:
  /// **'Need to configure Firebase Storage rules to use file management feature'**
  String get needToConfigureStorageRules;

  /// No description provided for @noFilesAttached.
  ///
  /// In en, this message translates to:
  /// **'No files attached'**
  String get noFilesAttached;

  /// No description provided for @uploadFilesUsingButtonAbove.
  ///
  /// In en, this message translates to:
  /// **'Upload files using the upload button above'**
  String get uploadFilesUsingButtonAbove;

  /// No description provided for @fileAttachedToTask.
  ///
  /// In en, this message translates to:
  /// **'File attached to task'**
  String get fileAttachedToTask;

  /// No description provided for @downloadFile.
  ///
  /// In en, this message translates to:
  /// **'Download file'**
  String get downloadFile;

  /// No description provided for @deleteFile.
  ///
  /// In en, this message translates to:
  /// **'Delete file'**
  String get deleteFile;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User not logged in'**
  String get userNotLoggedIn;

  /// No description provided for @errorLoadingFiles.
  ///
  /// In en, this message translates to:
  /// **'Error loading files'**
  String get errorLoadingFiles;

  /// No description provided for @uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploaded;

  /// No description provided for @filesOf.
  ///
  /// In en, this message translates to:
  /// **'files of'**
  String get filesOf;

  /// No description provided for @fileUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'File uploaded successfully'**
  String get fileUploadedSuccessfully;

  /// No description provided for @filesUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'files uploaded successfully'**
  String get filesUploadedSuccessfully;

  /// No description provided for @errorUploadingFiles.
  ///
  /// In en, this message translates to:
  /// **'Error uploading files'**
  String get errorUploadingFiles;

  /// No description provided for @downloadingFile.
  ///
  /// In en, this message translates to:
  /// **'Downloading file'**
  String get downloadingFile;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @copyLinkOrClickToDownload.
  ///
  /// In en, this message translates to:
  /// **'Copy link or click to download'**
  String get copyLinkOrClickToDownload;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @errorDownloadingFile.
  ///
  /// In en, this message translates to:
  /// **'Error downloading file'**
  String get errorDownloadingFile;

  /// No description provided for @noFilesToDownload.
  ///
  /// In en, this message translates to:
  /// **'No files to download'**
  String get noFilesToDownload;

  /// No description provided for @preparingDownload.
  ///
  /// In en, this message translates to:
  /// **'Preparing download'**
  String get preparingDownload;

  /// No description provided for @filesReady.
  ///
  /// In en, this message translates to:
  /// **'files ready to download'**
  String get filesReady;

  /// No description provided for @cannotDownloadFiles.
  ///
  /// In en, this message translates to:
  /// **'Cannot download files'**
  String get cannotDownloadFiles;

  /// No description provided for @downloadAllFiles.
  ///
  /// In en, this message translates to:
  /// **'Download All Files'**
  String get downloadAllFiles;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get downloading;

  /// No description provided for @deletingFile.
  ///
  /// In en, this message translates to:
  /// **'Deleting File'**
  String get deletingFile;

  /// No description provided for @confirmDeleteFile.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the file'**
  String get confirmDeleteFile;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @fileDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'File deleted successfully'**
  String get fileDeletedSuccessfully;

  /// No description provided for @errorDeletingFile.
  ///
  /// In en, this message translates to:
  /// **'Error deleting file'**
  String get errorDeletingFile;

  /// No description provided for @mainMenu.
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get mainMenu;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get notVerified;

  /// No description provided for @registered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registered;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @darkModeToggle.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeToggle;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @hebrew.
  ///
  /// In en, this message translates to:
  /// **'Hebrew'**
  String get hebrew;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @manageCommittees.
  ///
  /// In en, this message translates to:
  /// **'Manage Committees'**
  String get manageCommittees;

  /// No description provided for @addEditDeleteCommittees.
  ///
  /// In en, this message translates to:
  /// **'Add, edit and delete committees'**
  String get addEditDeleteCommittees;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @exportAllYourData.
  ///
  /// In en, this message translates to:
  /// **'Export all your data'**
  String get exportAllYourData;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @clientManagementSystem.
  ///
  /// In en, this message translates to:
  /// **'Client Management System'**
  String get clientManagementSystem;

  /// No description provided for @technicalSupport.
  ///
  /// In en, this message translates to:
  /// **'Technical Support'**
  String get technicalSupport;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutTitle;

  /// No description provided for @confirmSignOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get confirmSignOut;

  /// No description provided for @exportDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportDataTitle;

  /// No description provided for @exportDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to export all your data as a PDF file?\n\nThe file will include:\n• All cities and committees\n• All clients\n• All projects\n• General statistics'**
  String get exportDataConfirm;

  /// No description provided for @exportDataButton.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportDataButton;

  /// No description provided for @exportingData.
  ///
  /// In en, this message translates to:
  /// **'Exporting data...'**
  String get exportingData;

  /// No description provided for @dataExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully'**
  String get dataExportedSuccessfully;

  /// No description provided for @errorExportingData.
  ///
  /// In en, this message translates to:
  /// **'Error exporting data'**
  String get errorExportingData;

  /// No description provided for @backupAndRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore Data'**
  String get backupAndRestore;

  /// No description provided for @backupAllData.
  ///
  /// In en, this message translates to:
  /// **'Backup all your data (cities, clients, projects) to a JSON file and restore when needed'**
  String get backupAllData;

  /// No description provided for @exportAllDataBackup.
  ///
  /// In en, this message translates to:
  /// **'Export All Data (Backup)'**
  String get exportAllDataBackup;

  /// No description provided for @restoreDataFromBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore Data from Backup'**
  String get restoreDataFromBackup;

  /// No description provided for @cityAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'City added successfully'**
  String get cityAddedSuccessfully;

  /// No description provided for @pleaseSelectHandlingCommittee.
  ///
  /// In en, this message translates to:
  /// **'Please select handling committee'**
  String get pleaseSelectHandlingCommittee;

  /// No description provided for @clientDetailsUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Client details updated successfully'**
  String get clientDetailsUpdatedSuccessfully;

  /// No description provided for @pleaseEnterIdNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter ID number'**
  String get pleaseEnterIdNumber;

  /// No description provided for @idMustBe9Digits.
  ///
  /// In en, this message translates to:
  /// **'ID must be 9 digits'**
  String get idMustBe9Digits;

  /// No description provided for @idMustContainOnlyDigits.
  ///
  /// In en, this message translates to:
  /// **'ID must contain only digits'**
  String get idMustContainOnlyDigits;

  /// No description provided for @editClientDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Client Details -'**
  String get editClientDetails;

  /// No description provided for @clientNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Client Name *'**
  String get clientNameLabel;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @pleaseEnterClientName.
  ///
  /// In en, this message translates to:
  /// **'Please enter client name'**
  String get pleaseEnterClientName;

  /// No description provided for @clientNameMin2Chars.
  ///
  /// In en, this message translates to:
  /// **'Client name must be at least 2 characters'**
  String get clientNameMin2Chars;

  /// No description provided for @propertyAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Property Address *'**
  String get propertyAddressLabel;

  /// No description provided for @streetNumberCity.
  ///
  /// In en, this message translates to:
  /// **'Street, number, city'**
  String get streetNumberCity;

  /// No description provided for @pleaseEnterPropertyAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter property address'**
  String get pleaseEnterPropertyAddress;

  /// No description provided for @propertyAddressMin5Chars.
  ///
  /// In en, this message translates to:
  /// **'Property address must be at least 5 characters'**
  String get propertyAddressMin5Chars;

  /// No description provided for @idNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'ID Number *'**
  String get idNumberLabel;

  /// No description provided for @handlingCommitteeLabel.
  ///
  /// In en, this message translates to:
  /// **'Handling Committee *'**
  String get handlingCommitteeLabel;

  /// No description provided for @searchOrSelectCommittee.
  ///
  /// In en, this message translates to:
  /// **'Search or select committee...'**
  String get searchOrSelectCommittee;

  /// No description provided for @noCommitteesFound.
  ///
  /// In en, this message translates to:
  /// **'No committees found - Add committee by clicking committees button'**
  String get noCommitteesFound;

  /// No description provided for @errorLoadingCommittees.
  ///
  /// In en, this message translates to:
  /// **'Error loading committees'**
  String get errorLoadingCommittees;

  /// No description provided for @requiredFields.
  ///
  /// In en, this message translates to:
  /// **'* Required fields'**
  String get requiredFields;

  /// No description provided for @updateDetails.
  ///
  /// In en, this message translates to:
  /// **'Update Details'**
  String get updateDetails;

  /// No description provided for @clientAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Client added successfully'**
  String get clientAddedSuccessfully;

  /// No description provided for @addNewClient.
  ///
  /// In en, this message translates to:
  /// **'Add New Client'**
  String get addNewClient;

  /// No description provided for @addClientButton.
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get addClientButton;

  /// No description provided for @committeeAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Committee added successfully'**
  String get committeeAddedSuccessfully;

  /// No description provided for @addCommittee.
  ///
  /// In en, this message translates to:
  /// **'Add Committee'**
  String get addCommittee;

  /// No description provided for @committeeName.
  ///
  /// In en, this message translates to:
  /// **'Committee Name'**
  String get committeeName;

  /// No description provided for @pleaseEnterCommitteeName.
  ///
  /// In en, this message translates to:
  /// **'Please enter committee name'**
  String get pleaseEnterCommitteeName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @committeeUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Committee updated successfully'**
  String get committeeUpdatedSuccessfully;

  /// No description provided for @editCommittee.
  ///
  /// In en, this message translates to:
  /// **'Edit Committee'**
  String get editCommittee;

  /// No description provided for @searchCommittees.
  ///
  /// In en, this message translates to:
  /// **'Search committees...'**
  String get searchCommittees;

  /// No description provided for @noCommitteesInSystem.
  ///
  /// In en, this message translates to:
  /// **'No committees in system'**
  String get noCommitteesInSystem;

  /// No description provided for @noCommitteesFoundSearch.
  ///
  /// In en, this message translates to:
  /// **'No committees found'**
  String get noCommitteesFoundSearch;

  /// No description provided for @addFirstCommittee.
  ///
  /// In en, this message translates to:
  /// **'Add first committee to get started'**
  String get addFirstCommittee;

  /// No description provided for @errorLoadingCommitteesList.
  ///
  /// In en, this message translates to:
  /// **'Error loading committees'**
  String get errorLoadingCommitteesList;

  /// No description provided for @deleteCommitteeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Committee'**
  String get deleteCommitteeTitle;

  /// No description provided for @confirmDeleteCommittee.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String confirmDeleteCommittee(Object name);

  /// No description provided for @committeeDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Committee deleted successfully'**
  String get committeeDeletedSuccessfully;

  /// No description provided for @clientsIn.
  ///
  /// In en, this message translates to:
  /// **'Clients -'**
  String get clientsIn;

  /// No description provided for @searchClientsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search clients...'**
  String get searchClientsPlaceholder;

  /// No description provided for @noClientsFoundFor.
  ///
  /// In en, this message translates to:
  /// **'No clients found for'**
  String get noClientsFoundFor;

  /// No description provided for @loadingClients.
  ///
  /// In en, this message translates to:
  /// **'Loading clients...'**
  String get loadingClients;

  /// No description provided for @noPermissionToAccessData.
  ///
  /// In en, this message translates to:
  /// **'No permission to access data\nPlease sign in again'**
  String get noPermissionToAccessData;

  /// No description provided for @dataServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Data service unavailable\nCheck internet connection'**
  String get dataServiceUnavailable;

  /// No description provided for @dataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Data not found\nCity may not exist'**
  String get dataNotFound;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @addFirstClientToStart.
  ///
  /// In en, this message translates to:
  /// **'Add first client to get started'**
  String get addFirstClientToStart;

  /// No description provided for @errorLoadingClientDetails.
  ///
  /// In en, this message translates to:
  /// **'Error loading client details'**
  String get errorLoadingClientDetails;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @clientNotFound.
  ///
  /// In en, this message translates to:
  /// **'Client not found'**
  String get clientNotFound;

  /// No description provided for @clientDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Client Details'**
  String get clientDetailsTitle;

  /// No description provided for @idNumberInfo.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumberInfo;

  /// No description provided for @propertyAddressInfo.
  ///
  /// In en, this message translates to:
  /// **'Property Address'**
  String get propertyAddressInfo;

  /// No description provided for @handlingCommitteeInfo.
  ///
  /// In en, this message translates to:
  /// **'Handling Committee'**
  String get handlingCommitteeInfo;

  /// No description provided for @viewProject.
  ///
  /// In en, this message translates to:
  /// **'View Project'**
  String get viewProject;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @exportDetails.
  ///
  /// In en, this message translates to:
  /// **'Export Details'**
  String get exportDetails;

  /// No description provided for @deleteClient.
  ///
  /// In en, this message translates to:
  /// **'Delete Client'**
  String get deleteClient;

  /// No description provided for @deleteClientTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Client'**
  String get deleteClientTitle;

  /// No description provided for @confirmDeleteClient.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?\nThis action cannot be undone.'**
  String confirmDeleteClient(Object name);

  /// No description provided for @clientDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Client deleted successfully'**
  String get clientDeletedSuccessfully;

  /// No description provided for @errorDeletingClient.
  ///
  /// In en, this message translates to:
  /// **'Error deleting client'**
  String get errorDeletingClient;

  /// No description provided for @committeeAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Committee already exists'**
  String get committeeAlreadyExists;

  /// No description provided for @errorAddingCommittee.
  ///
  /// In en, this message translates to:
  /// **'Error adding committee'**
  String get errorAddingCommittee;

  /// No description provided for @clientWithIdAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Client with this ID already exists in system'**
  String get clientWithIdAlreadyExists;

  /// No description provided for @noPermissionForAction.
  ///
  /// In en, this message translates to:
  /// **'No permission to perform this action - Please sign in again'**
  String get noPermissionForAction;

  /// No description provided for @firebaseServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Firebase service unavailable - Check internet connection'**
  String get firebaseServiceUnavailable;

  /// No description provided for @firebaseError.
  ///
  /// In en, this message translates to:
  /// **'Firebase error'**
  String get firebaseError;

  /// No description provided for @errorAddingClient.
  ///
  /// In en, this message translates to:
  /// **'Error adding client'**
  String get errorAddingClient;

  /// No description provided for @errorGeneral.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorGeneral;

  /// No description provided for @accountPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Your account is pending approval. Please wait for the administrator to approve your account.'**
  String get accountPendingApproval;

  /// No description provided for @pendingUsers.
  ///
  /// In en, this message translates to:
  /// **'Pending Users'**
  String get pendingUsers;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @refreshData.
  ///
  /// In en, this message translates to:
  /// **'Refresh Data...'**
  String get refreshData;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @userApprovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User {email} approved successfully'**
  String userApprovedSuccessfully(Object email);

  /// No description provided for @errorApprovingUser.
  ///
  /// In en, this message translates to:
  /// **'Error approving user'**
  String get errorApprovingUser;

  /// No description provided for @userRejected.
  ///
  /// In en, this message translates to:
  /// **'User {email} rejected'**
  String userRejected(Object email);

  /// No description provided for @errorRejectingUser.
  ///
  /// In en, this message translates to:
  /// **'Error rejecting user'**
  String get errorRejectingUser;

  /// No description provided for @noAdminPermissions.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have admin permissions'**
  String get noAdminPermissions;

  /// No description provided for @noPendingUsers.
  ///
  /// In en, this message translates to:
  /// **'No pending users'**
  String get noPendingUsers;

  /// No description provided for @noUsersInSystem.
  ///
  /// In en, this message translates to:
  /// **'No users in system'**
  String get noUsersInSystem;

  /// No description provided for @errorSigningOut.
  ///
  /// In en, this message translates to:
  /// **'Error signing out'**
  String get errorSigningOut;

  /// No description provided for @cityName.
  ///
  /// In en, this message translates to:
  /// **'City Name'**
  String get cityName;

  /// No description provided for @enterCityName.
  ///
  /// In en, this message translates to:
  /// **'Please enter city name'**
  String get enterCityName;

  /// No description provided for @cityNameMin2Chars.
  ///
  /// In en, this message translates to:
  /// **'City name must be at least 2 characters'**
  String get cityNameMin2Chars;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @errorAddingCity.
  ///
  /// In en, this message translates to:
  /// **'Error adding city'**
  String get errorAddingCity;

  /// No description provided for @lightModeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightModeTooltip;

  /// No description provided for @darkModeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeTooltip;

  /// No description provided for @pendingApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingApprovalTitle;

  /// No description provided for @accountCreatedAwaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Your account was created successfully and is awaiting admin approval.'**
  String get accountCreatedAwaitingApproval;

  /// No description provided for @pleaseWaitForApproval.
  ///
  /// In en, this message translates to:
  /// **'Please wait for admin approval. Click \'Check Status Again\' to try logging in again.'**
  String get pleaseWaitForApproval;

  /// No description provided for @checkStatusAgain.
  ///
  /// In en, this message translates to:
  /// **'Check Status Again'**
  String get checkStatusAgain;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @systemAdminLogin.
  ///
  /// In en, this message translates to:
  /// **'System Administrator Login'**
  String get systemAdminLogin;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter email address'**
  String get enterEmailAddress;

  /// No description provided for @loginToPanel.
  ///
  /// In en, this message translates to:
  /// **'Login to Panel'**
  String get loginToPanel;

  /// No description provided for @backToMainApp.
  ///
  /// In en, this message translates to:
  /// **'Back to Main App'**
  String get backToMainApp;

  /// No description provided for @refreshingData.
  ///
  /// In en, this message translates to:
  /// **'Refreshing data...'**
  String get refreshingData;

  /// No description provided for @pendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingApproval;

  /// No description provided for @allUsers.
  ///
  /// In en, this message translates to:
  /// **'All Users'**
  String get allUsers;

  /// No description provided for @registrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration Date'**
  String get registrationDate;

  /// No description provided for @approvalDate.
  ///
  /// In en, this message translates to:
  /// **'Approval Date'**
  String get approvalDate;

  /// No description provided for @approvedBy.
  ///
  /// In en, this message translates to:
  /// **'Approved by'**
  String get approvedBy;

  /// No description provided for @rejectionDate.
  ///
  /// In en, this message translates to:
  /// **'Rejection Date'**
  String get rejectionDate;

  /// No description provided for @rejectedBy.
  ///
  /// In en, this message translates to:
  /// **'Rejected by'**
  String get rejectedBy;

  /// No description provided for @errorLoggingOut.
  ///
  /// In en, this message translates to:
  /// **'Error logging out'**
  String get errorLoggingOut;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials - Email or password is incorrect'**
  String get invalidCredentials;

  /// No description provided for @generalError.
  ///
  /// In en, this message translates to:
  /// **'General error'**
  String get generalError;

  /// No description provided for @accountPendingApprovalMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account is pending approval. Please wait for approval.'**
  String get accountPendingApprovalMessage;

  /// No description provided for @accountRejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account was rejected. Please contact the system administrator.'**
  String get accountRejectedMessage;

  /// No description provided for @accountNotApprovedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account is not yet approved. Please contact the system administrator.'**
  String get accountNotApprovedMessage;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Login error'**
  String get loginError;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccessfully;

  /// No description provided for @accountAwaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Your account is awaiting admin approval. Please wait until the admin approves your account.'**
  String get accountAwaitingApproval;

  /// No description provided for @approvalTime.
  ///
  /// In en, this message translates to:
  /// **'Approval time: Usually 24-48 hours.'**
  String get approvalTime;

  /// No description provided for @addStage.
  ///
  /// In en, this message translates to:
  /// **'Add Stage'**
  String get addStage;

  /// No description provided for @deleteStage.
  ///
  /// In en, this message translates to:
  /// **'Delete Stage'**
  String get deleteStage;

  /// No description provided for @stageTitle.
  ///
  /// In en, this message translates to:
  /// **'Stage Title'**
  String get stageTitle;

  /// No description provided for @enterStageName.
  ///
  /// In en, this message translates to:
  /// **'Enter stage name...'**
  String get enterStageName;

  /// No description provided for @editStageTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Stage Title'**
  String get editStageTitle;

  /// No description provided for @confirmDeleteStage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the stage \"{name}\"? This will delete all tasks in this stage.'**
  String confirmDeleteStage(Object name);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'he': return AppLocalizationsHe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
