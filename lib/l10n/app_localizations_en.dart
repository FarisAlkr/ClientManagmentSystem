// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Client Management';

  @override
  String get clientManagement => 'Client Management';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get enterEmail => 'Please enter your email';

  @override
  String get enterValidEmail => 'Please enter a valid email';

  @override
  String get enterPassword => 'Please enter password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordMessage => 'Please confirm your password';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signInToSystem => 'Sign in to system';

  @override
  String get signUpToSystem => 'Register to system';

  @override
  String get accountCreated => 'Account created successfully!';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get userNotFound => 'User not found';

  @override
  String get wrongPassword => 'Wrong password';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get userDisabled => 'User account is disabled';

  @override
  String get tooManyRequests => 'Too many attempts. Try again later';

  @override
  String get weakPassword => 'The password is too weak';

  @override
  String get emailInUse => 'The email is already in use';

  @override
  String get operationNotAllowed => 'Registration is not enabled';

  @override
  String get southernCities => 'Southern Cities';

  @override
  String get searchCities => 'Search cities...';

  @override
  String get noCitiesFound => 'No cities found for';

  @override
  String get noCitiesInSystem => 'No cities in system';

  @override
  String get addSouthernCities => 'Add southern Israeli cities';

  @override
  String get addSampleCities => 'Add sample cities';

  @override
  String get addNewCity => 'Add New City';

  @override
  String get clients => 'Clients';

  @override
  String get clientDetails => 'Client Details';

  @override
  String get searchClients => 'Search clients...';

  @override
  String get noClientsFound => 'No clients found for';

  @override
  String get noClientsInCity => 'No clients in';

  @override
  String get addFirstClient => 'Add first client to get started';

  @override
  String get addClient => 'Add Client';

  @override
  String get projectTasks => 'Project Tasks';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get projectSummary => 'Project Summary';

  @override
  String get created => 'Created';

  @override
  String get completed => 'Completed';

  @override
  String get overallProgress => 'Overall Progress';

  @override
  String get stagesOf => 'stages of';

  @override
  String get projectStages => 'Project Stages';

  @override
  String get addTask => 'Add Task';

  @override
  String get addNote => 'Add Note';

  @override
  String get addCustomTask => 'Add Custom Task';

  @override
  String get addCustomNote => 'Add Custom Note';

  @override
  String get writeTask => 'Write task name...';

  @override
  String get writeNote => 'Write note...';

  @override
  String get add => 'Add';

  @override
  String get cancel => 'Cancel';

  @override
  String get addNotes => 'Add notes...';

  @override
  String get idNumber => 'ID';

  @override
  String get committee => 'Committee';

  @override
  String get errorLoadingClient => 'Error loading client details';

  @override
  String get errorExportingPdf => 'Error exporting PDF';

  @override
  String get clientName => 'Name';

  @override
  String get clientId => 'ID';

  @override
  String get propertyAddress => 'Property Address';

  @override
  String get handlingCommittee => 'Handling Committee';

  @override
  String get errorLoadingProject => 'Error loading project';

  @override
  String get projectNotFound => 'Project not found';

  @override
  String get error => 'Error';

  @override
  String get addNew => 'Add New';

  @override
  String get addNewClientProject => 'Add New Client/Project';

  @override
  String get manageClients => 'Manage Clients';

  @override
  String get committees => 'Committees';

  @override
  String get searchClientsByCommittee => 'Search Clients by Committee';

  @override
  String get globalClientSearch => 'Search clients by committee';

  @override
  String get enterCommitteeOrCity => 'Enter committee or city name...';

  @override
  String get searchResultsFor => 'Search results for';

  @override
  String get enterSearchTerm => 'Enter search term to find clients';

  @override
  String get pendingTasks => 'Pending Tasks';

  @override
  String get activeProjests => 'Active Projects';

  @override
  String get clientProjectManagementSystem => 'Client Project Management System';

  @override
  String get clientsFound => 'clients found';

  @override
  String get toggleLanguage => 'Toggle Language';

  @override
  String get signOut => 'Sign Out';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get addingCities => 'Adding cities...';

  @override
  String get citiesAdded => 'cities added successfully';

  @override
  String get errorAddingCities => 'Error adding cities';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemMode => 'System Mode';

  @override
  String get fileManagement => 'File Management';

  @override
  String get uploadNewFiles => 'Upload New Files';

  @override
  String get uploadOneOrMoreFiles => 'Upload one or more files to this task';

  @override
  String get chooseFilesToUpload => 'Choose Files to Upload';

  @override
  String get storageNotAvailable => 'Storage not available';

  @override
  String get existingFiles => 'Existing Files';

  @override
  String get attachedFiles => 'Attached Files';

  @override
  String get downloadAll => 'Download All';

  @override
  String get loadingFiles => 'Loading files...';

  @override
  String get firebaseStorageNotConfigured => 'Firebase Storage not configured';

  @override
  String get needToConfigureStorageRules => 'Need to configure Firebase Storage rules to use file management feature';

  @override
  String get noFilesAttached => 'No files attached';

  @override
  String get uploadFilesUsingButtonAbove => 'Upload files using the upload button above';

  @override
  String get fileAttachedToTask => 'File attached to task';

  @override
  String get downloadFile => 'Download file';

  @override
  String get deleteFile => 'Delete file';

  @override
  String get userNotLoggedIn => 'User not logged in';

  @override
  String get errorLoadingFiles => 'Error loading files';

  @override
  String get uploaded => 'Uploaded';

  @override
  String get filesOf => 'files of';

  @override
  String get fileUploadedSuccessfully => 'File uploaded successfully';

  @override
  String get filesUploadedSuccessfully => 'files uploaded successfully';

  @override
  String get errorUploadingFiles => 'Error uploading files';

  @override
  String get downloadingFile => 'Downloading file';

  @override
  String get file => 'File';

  @override
  String get copyLinkOrClickToDownload => 'Copy link or click to download';

  @override
  String get close => 'Close';

  @override
  String get download => 'Download';

  @override
  String get errorDownloadingFile => 'Error downloading file';

  @override
  String get noFilesToDownload => 'No files to download';

  @override
  String get preparingDownload => 'Preparing download';

  @override
  String get filesReady => 'files ready to download';

  @override
  String get cannotDownloadFiles => 'Cannot download files';

  @override
  String get downloadAllFiles => 'Download All Files';

  @override
  String get downloading => 'Downloading';

  @override
  String get deletingFile => 'Deleting File';

  @override
  String get confirmDeleteFile => 'Are you sure you want to delete the file';

  @override
  String get delete => 'Delete';

  @override
  String get fileDeletedSuccessfully => 'File deleted successfully';

  @override
  String get errorDeletingFile => 'Error deleting file';

  @override
  String get mainMenu => 'Main Menu';

  @override
  String get statistics => 'Statistics';

  @override
  String get settings => 'Settings';

  @override
  String get user => 'User';

  @override
  String get unknown => 'Unknown';

  @override
  String get verified => 'Verified';

  @override
  String get notVerified => 'Not Verified';

  @override
  String get registered => 'Registered';

  @override
  String get appSettings => 'App Settings';

  @override
  String get darkModeToggle => 'Dark Mode';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get language => 'Language';

  @override
  String get hebrew => 'Hebrew';

  @override
  String get english => 'English';

  @override
  String get manageCommittees => 'Manage Committees';

  @override
  String get addEditDeleteCommittees => 'Add, edit and delete committees';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportAllYourData => 'Export all your data';

  @override
  String get aboutApp => 'About the App';

  @override
  String get version => 'Version';

  @override
  String get clientManagementSystem => 'Client Management System';

  @override
  String get technicalSupport => 'Technical Support';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get signOutTitle => 'Sign Out';

  @override
  String get confirmSignOut => 'Are you sure you want to sign out?';

  @override
  String get exportDataTitle => 'Export Data';

  @override
  String get exportDataConfirm => 'Do you want to export all your data as a PDF file?\n\nThe file will include:\n• All cities and committees\n• All clients\n• All projects\n• General statistics';

  @override
  String get exportDataButton => 'Export Data';

  @override
  String get exportingData => 'Exporting data...';

  @override
  String get dataExportedSuccessfully => 'Data exported successfully';

  @override
  String get errorExportingData => 'Error exporting data';

  @override
  String get backupAndRestore => 'Backup & Restore Data';

  @override
  String get backupAllData => 'Backup all your data (cities, clients, projects) to a JSON file and restore when needed';

  @override
  String get exportAllDataBackup => 'Export All Data (Backup)';

  @override
  String get restoreDataFromBackup => 'Restore Data from Backup';

  @override
  String get cityAddedSuccessfully => 'City added successfully';

  @override
  String get pleaseSelectHandlingCommittee => 'Please select handling committee';

  @override
  String get clientDetailsUpdatedSuccessfully => 'Client details updated successfully';

  @override
  String get pleaseEnterIdNumber => 'Please enter ID number';

  @override
  String get idMustBe9Digits => 'ID must be 9 digits';

  @override
  String get idMustContainOnlyDigits => 'ID must contain only digits';

  @override
  String get editClientDetails => 'Edit Client Details -';

  @override
  String get clientNameLabel => 'Client Name *';

  @override
  String get fullName => 'Full Name';

  @override
  String get pleaseEnterClientName => 'Please enter client name';

  @override
  String get clientNameMin2Chars => 'Client name must be at least 2 characters';

  @override
  String get propertyAddressLabel => 'Property Address *';

  @override
  String get streetNumberCity => 'Street, number, city';

  @override
  String get pleaseEnterPropertyAddress => 'Please enter property address';

  @override
  String get propertyAddressMin5Chars => 'Property address must be at least 5 characters';

  @override
  String get idNumberLabel => 'ID Number *';

  @override
  String get handlingCommitteeLabel => 'Handling Committee *';

  @override
  String get searchOrSelectCommittee => 'Search or select committee...';

  @override
  String get noCommitteesFound => 'No committees found - Add committee by clicking committees button';

  @override
  String get errorLoadingCommittees => 'Error loading committees';

  @override
  String get requiredFields => '* Required fields';

  @override
  String get updateDetails => 'Update Details';

  @override
  String get clientAddedSuccessfully => 'Client added successfully';

  @override
  String get addNewClient => 'Add New Client';

  @override
  String get addClientButton => 'Add Client';

  @override
  String get committeeAddedSuccessfully => 'Committee added successfully';

  @override
  String get addCommittee => 'Add Committee';

  @override
  String get committeeName => 'Committee Name';

  @override
  String get pleaseEnterCommitteeName => 'Please enter committee name';

  @override
  String get save => 'Save';

  @override
  String get committeeUpdatedSuccessfully => 'Committee updated successfully';

  @override
  String get editCommittee => 'Edit Committee';

  @override
  String get searchCommittees => 'Search committees...';

  @override
  String get noCommitteesInSystem => 'No committees in system';

  @override
  String get noCommitteesFoundSearch => 'No committees found';

  @override
  String get addFirstCommittee => 'Add first committee to get started';

  @override
  String get errorLoadingCommitteesList => 'Error loading committees';

  @override
  String get deleteCommitteeTitle => 'Delete Committee';

  @override
  String confirmDeleteCommittee(Object name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get committeeDeletedSuccessfully => 'Committee deleted successfully';

  @override
  String get clientsIn => 'Clients -';

  @override
  String get searchClientsPlaceholder => 'Search clients...';

  @override
  String get noClientsFoundFor => 'No clients found for';

  @override
  String get loadingClients => 'Loading clients...';

  @override
  String get noPermissionToAccessData => 'No permission to access data\nPlease sign in again';

  @override
  String get dataServiceUnavailable => 'Data service unavailable\nCheck internet connection';

  @override
  String get dataNotFound => 'Data not found\nCity may not exist';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get addFirstClientToStart => 'Add first client to get started';

  @override
  String get errorLoadingClientDetails => 'Error loading client details';

  @override
  String get back => 'Back';

  @override
  String get clientNotFound => 'Client not found';

  @override
  String get clientDetailsTitle => 'Client Details';

  @override
  String get idNumberInfo => 'ID Number';

  @override
  String get propertyAddressInfo => 'Property Address';

  @override
  String get handlingCommitteeInfo => 'Handling Committee';

  @override
  String get viewProject => 'View Project';

  @override
  String get edit => 'Edit';

  @override
  String get exportDetails => 'Export Details';

  @override
  String get deleteClient => 'Delete Client';

  @override
  String get deleteClientTitle => 'Delete Client';

  @override
  String confirmDeleteClient(Object name) {
    return 'Are you sure you want to delete $name?\nThis action cannot be undone.';
  }

  @override
  String get clientDeletedSuccessfully => 'Client deleted successfully';

  @override
  String get errorDeletingClient => 'Error deleting client';

  @override
  String get committeeAlreadyExists => 'Committee already exists';

  @override
  String get errorAddingCommittee => 'Error adding committee';

  @override
  String get clientWithIdAlreadyExists => 'Client with this ID already exists in system';

  @override
  String get noPermissionForAction => 'No permission to perform this action - Please sign in again';

  @override
  String get firebaseServiceUnavailable => 'Firebase service unavailable - Check internet connection';

  @override
  String get firebaseError => 'Firebase error';

  @override
  String get errorAddingClient => 'Error adding client';

  @override
  String get errorGeneral => 'Error';

  @override
  String get accountPendingApproval => 'Your account is pending approval. Please wait for the administrator to approve your account.';

  @override
  String get pendingUsers => 'Pending Users';

  @override
  String get userManagement => 'User Management';

  @override
  String get refreshData => 'Refresh Data...';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String userApprovedSuccessfully(Object email) {
    return 'User $email approved successfully';
  }

  @override
  String get errorApprovingUser => 'Error approving user';

  @override
  String userRejected(Object email) {
    return 'User $email rejected';
  }

  @override
  String get errorRejectingUser => 'Error rejecting user';

  @override
  String get noAdminPermissions => 'You don\'t have admin permissions';

  @override
  String get noPendingUsers => 'No pending users';

  @override
  String get noUsersInSystem => 'No users in system';

  @override
  String get errorSigningOut => 'Error signing out';

  @override
  String get cityName => 'City Name';

  @override
  String get enterCityName => 'Please enter city name';

  @override
  String get cityNameMin2Chars => 'City name must be at least 2 characters';

  @override
  String get description => 'Description';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get errorAddingCity => 'Error adding city';

  @override
  String get lightModeTooltip => 'Light Mode';

  @override
  String get darkModeTooltip => 'Dark Mode';

  @override
  String get pendingApprovalTitle => 'Pending Approval';

  @override
  String get accountCreatedAwaitingApproval => 'Your account was created successfully and is awaiting admin approval.';

  @override
  String get pleaseWaitForApproval => 'Please wait for admin approval. Click \'Check Status Again\' to try logging in again.';

  @override
  String get checkStatusAgain => 'Check Status Again';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get systemAdminLogin => 'System Administrator Login';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterEmailAddress => 'Please enter email address';

  @override
  String get loginToPanel => 'Login to Panel';

  @override
  String get backToMainApp => 'Back to Main App';

  @override
  String get refreshingData => 'Refreshing data...';

  @override
  String get pendingApproval => 'Pending Approval';

  @override
  String get allUsers => 'All Users';

  @override
  String get registrationDate => 'Registration Date';

  @override
  String get approvalDate => 'Approval Date';

  @override
  String get approvedBy => 'Approved by';

  @override
  String get rejectionDate => 'Rejection Date';

  @override
  String get rejectedBy => 'Rejected by';

  @override
  String get errorLoggingOut => 'Error logging out';

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get invalidCredentials => 'Invalid credentials - Email or password is incorrect';

  @override
  String get generalError => 'General error';

  @override
  String get accountPendingApprovalMessage => 'Your account is pending approval. Please wait for approval.';

  @override
  String get accountRejectedMessage => 'Your account was rejected. Please contact the system administrator.';

  @override
  String get accountNotApprovedMessage => 'Your account is not yet approved. Please contact the system administrator.';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get loginError => 'Login error';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully!';

  @override
  String get accountAwaitingApproval => 'Your account is awaiting admin approval. Please wait until the admin approves your account.';

  @override
  String get approvalTime => 'Approval time: Usually 24-48 hours.';

  @override
  String get addStage => 'Add Stage';

  @override
  String get deleteStage => 'Delete Stage';

  @override
  String get stageTitle => 'Stage Title';

  @override
  String get enterStageName => 'Enter stage name...';

  @override
  String get editStageTitle => 'Edit Stage Title';

  @override
  String confirmDeleteStage(Object name) {
    return 'Are you sure you want to delete the stage \"$name\"? This will delete all tasks in this stage.';
  }
}
