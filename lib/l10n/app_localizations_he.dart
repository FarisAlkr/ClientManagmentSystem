// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'ניהול לקוחות';

  @override
  String get clientManagement => 'ניהול לקוחות';

  @override
  String get signIn => 'התחברות';

  @override
  String get signUp => 'הרשמה';

  @override
  String get email => 'כתובת מייל';

  @override
  String get password => 'סיסמה';

  @override
  String get confirmPassword => 'אימות סיסמה';

  @override
  String get enterEmail => 'נא להזין כתובת מייל';

  @override
  String get enterValidEmail => 'נא להזין כתובת מייל תקינה';

  @override
  String get enterPassword => 'נא להזין סיסמה';

  @override
  String get passwordMinLength => 'הסיסמה חייבת להיות לפחות 6 תווים';

  @override
  String get confirmPasswordMessage => 'נא לאמת את הסיסמה';

  @override
  String get passwordsDontMatch => 'הסיסמאות אינן זהות';

  @override
  String get haveAccount => 'יש לך כבר חשבון?';

  @override
  String get noAccount => 'אין לך חשבון?';

  @override
  String get signInToSystem => 'התחברות למערכת';

  @override
  String get signUpToSystem => 'הרשמה למערכת';

  @override
  String get accountCreated => 'חשבון נוצר בהצלחה!';

  @override
  String get errorOccurred => 'שגיאה התרחשה';

  @override
  String get userNotFound => 'לא נמצא משתמש עם כתובת מייל זו';

  @override
  String get wrongPassword => 'סיסמה שגויה';

  @override
  String get invalidEmail => 'כתובת מייל לא תקינה';

  @override
  String get userDisabled => 'חשבון המשתמש הושבת';

  @override
  String get tooManyRequests => 'יותר מדי ניסיונות. נסה שוב מאוחר יותר';

  @override
  String get weakPassword => 'הסיסמה חלשה מדי';

  @override
  String get emailInUse => 'כתובת המייל כבר בשימוש';

  @override
  String get operationNotAllowed => 'הרשמה אינה מופעלת';

  @override
  String get southernCities => 'ערים בדרום';

  @override
  String get searchCities => 'חיפוש ערים...';

  @override
  String get noCitiesFound => 'לא נמצאו ערים עבור';

  @override
  String get noCitiesInSystem => 'אין ערים במערכת';

  @override
  String get addSouthernCities => 'הוסף ערים בדרום ישראל';

  @override
  String get addSampleCities => 'הוסף ערים לדוגמא';

  @override
  String get addNewCity => 'הוסף עיר חדשה';

  @override
  String get clients => 'לקוחות';

  @override
  String get clientDetails => 'פרטי לקוח';

  @override
  String get searchClients => 'חיפוש לקוחות...';

  @override
  String get noClientsFound => 'לא נמצאו לקוחות עבור';

  @override
  String get noClientsInCity => 'אין לקוחות ב';

  @override
  String get addFirstClient => 'הוסף לקוח ראשון כדי להתחיל';

  @override
  String get addClient => 'הוסף לקוח';

  @override
  String get projectTasks => 'רשימת משימות פרויקט';

  @override
  String get exportPdf => 'יצוא PDF';

  @override
  String get projectSummary => 'סיכום פרויקט';

  @override
  String get created => 'נוצר';

  @override
  String get completed => 'הושלם';

  @override
  String get overallProgress => 'התקדמות כללית';

  @override
  String get stagesOf => 'שלבים מתוך';

  @override
  String get projectStages => 'שלבי הפרויקט';

  @override
  String get addTask => 'הוסף משימה';

  @override
  String get addNote => 'הוסף הערה';

  @override
  String get addCustomTask => 'הוסף משימה';

  @override
  String get addCustomNote => 'הוסף הערה';

  @override
  String get writeTask => 'כתוב שם משימה...';

  @override
  String get writeNote => 'כתוב הערה...';

  @override
  String get add => 'הוסף';

  @override
  String get cancel => 'ביטול';

  @override
  String get addNotes => 'הוסף הערות...';

  @override
  String get idNumber => 'ת.ז';

  @override
  String get committee => 'ועדה';

  @override
  String get errorLoadingClient => 'שגיאה בטעינת פרטי ועדה';

  @override
  String get errorExportingPdf => 'שגיאה ביצוא PDF';

  @override
  String get clientName => 'שם';

  @override
  String get clientId => 'ת.ז';

  @override
  String get propertyAddress => 'כתובת הנכס';

  @override
  String get handlingCommittee => 'ועדה מטפלת';

  @override
  String get errorLoadingProject => 'שגיאה בטעינת פרויקט';

  @override
  String get projectNotFound => 'לא נמצא פרויקט';

  @override
  String get error => 'שגיאה';

  @override
  String get addNew => 'הוסף חדש';

  @override
  String get addNewClientProject => 'הוסף לקוח/פרויקט חדש';

  @override
  String get manageClients => 'ניהול לקוחות';

  @override
  String get committees => 'ועדות';

  @override
  String get searchClientsByCommittee => 'חיפוש לקוחות לפי ערים';

  @override
  String get globalClientSearch => 'חיפוש לקוחות לפי ערים';

  @override
  String get enterCommitteeOrCity => 'הכנס שם לקוח או עיר...';

  @override
  String get searchResultsFor => 'תוצאות חיפוש עבור';

  @override
  String get enterSearchTerm => 'הכנס מילת חיפוש כדי לחפש לקוחות';

  @override
  String get pendingTasks => 'משימות ממתינות';

  @override
  String get activeProjests => 'פרויקטים פעילים';

  @override
  String get clientProjectManagementSystem => 'מערכת ניהול פרויקטים ללקוחות';

  @override
  String get clientsFound => 'לקוחות נמצאו';

  @override
  String get toggleLanguage => 'החלפת שפה';

  @override
  String get signOut => 'התנתקות';

  @override
  String get tryAgain => 'נסה שוב';

  @override
  String get addingCities => 'מוסיף ערים...';

  @override
  String get citiesAdded => 'ערים נוספו בהצלחה';

  @override
  String get errorAddingCities => 'שגיאה בהוספת ערים';

  @override
  String get darkMode => 'מצב לילה';

  @override
  String get lightMode => 'מצב יום';

  @override
  String get systemMode => 'מצב מערכת';

  @override
  String get fileManagement => 'ניהול קבצים';

  @override
  String get uploadNewFiles => 'העלאת קבצים חדשים';

  @override
  String get uploadOneOrMoreFiles => 'העלה קובץ אחד או מספר קבצים למשימה זו';

  @override
  String get chooseFilesToUpload => 'בחר קבצים להעלאה';

  @override
  String get storageNotAvailable => 'Storage לא זמין';

  @override
  String get existingFiles => 'קבצים קיימים';

  @override
  String get attachedFiles => 'קבצים מצורפים';

  @override
  String get downloadAll => 'הורד הכל';

  @override
  String get loadingFiles => 'טוען קבצים...';

  @override
  String get firebaseStorageNotConfigured => 'Firebase Storage לא מוגדר';

  @override
  String get needToConfigureStorageRules => 'יש צורך להגדיר Firebase Storage rules\nכדי להשתמש בתכונת ניהול הקבצים';

  @override
  String get noFilesAttached => 'אין קבצים מצורפים';

  @override
  String get uploadFilesUsingButtonAbove => 'העלה קבצים באמצעות כפתור ההעלאה למעלה';

  @override
  String get fileAttachedToTask => 'קובץ מצורף למשימה';

  @override
  String get downloadFile => 'הורד קובץ';

  @override
  String get deleteFile => 'מחק קובץ';

  @override
  String get userNotLoggedIn => 'משתמש לא מחובר';

  @override
  String get errorLoadingFiles => 'שגיאה בטעינת קבצים';

  @override
  String get uploaded => 'הועלה';

  @override
  String get filesOf => 'מתוך';

  @override
  String get fileUploadedSuccessfully => 'הקובץ הועלה בהצלחה';

  @override
  String get filesUploadedSuccessfully => 'קבצים בהצלחה';

  @override
  String get errorUploadingFiles => 'שגיאה בהעלאת קבצים';

  @override
  String get downloadingFile => 'הורדת קובץ';

  @override
  String get file => 'קובץ';

  @override
  String get copyLinkOrClickToDownload => 'העתק את הקישור או לחץ עליו להורדה';

  @override
  String get close => 'סגור';

  @override
  String get download => 'הורד';

  @override
  String get errorDownloadingFile => 'שגיאה בהורדת קובץ';

  @override
  String get noFilesToDownload => 'אין קבצים להורדה';

  @override
  String get preparingDownload => 'מכין הורדה';

  @override
  String get filesReady => 'קבצים מוכנים להורדה';

  @override
  String get cannotDownloadFiles => 'לא ניתן להוריד קבצים';

  @override
  String get downloadAllFiles => 'הורדת כל הקבצים';

  @override
  String get downloading => 'מוריד';

  @override
  String get deletingFile => 'מחיקת קובץ';

  @override
  String get confirmDeleteFile => 'האם אתה בטוח שברצונך למחוק את הקובץ';

  @override
  String get delete => 'מחק';

  @override
  String get fileDeletedSuccessfully => 'הקובץ נמחק בהצלחה';

  @override
  String get errorDeletingFile => 'שגיאה במחיקת קובץ';

  @override
  String get mainMenu => 'תפריט ראשי';

  @override
  String get statistics => 'סטטיסטיקה';

  @override
  String get settings => 'הגדרות';

  @override
  String get user => 'משתמש';

  @override
  String get unknown => 'לא ידוע';

  @override
  String get verified => 'מאומת';

  @override
  String get notVerified => 'לא מאומת';

  @override
  String get registered => 'רשום';

  @override
  String get appSettings => 'הגדרות אפליקציה';

  @override
  String get darkModeToggle => 'מצב לילה';

  @override
  String get enabled => 'מופעל';

  @override
  String get disabled => 'מושבת';

  @override
  String get language => 'שפה';

  @override
  String get hebrew => 'עברית';

  @override
  String get english => 'אנגלית';

  @override
  String get manageCommittees => 'ניהול ועדות';

  @override
  String get addEditDeleteCommittees => 'הוסף, ערוך ומחק ועדות';

  @override
  String get exportData => 'יצוא נתונים';

  @override
  String get exportAllYourData => 'יצא את כל הנתונים שלך';

  @override
  String get aboutApp => 'אודות האפליקציה';

  @override
  String get version => 'גרסה';

  @override
  String get clientManagementSystem => 'מערכת ניהול לקוחות';

  @override
  String get technicalSupport => 'תמיכה טכנית';

  @override
  String get disconnect => 'התנתקות';

  @override
  String get signOutTitle => 'התנתקות';

  @override
  String get confirmSignOut => 'האם אתה בטוח שברצונך להתנתק?';

  @override
  String get exportDataTitle => 'יצוא נתונים';

  @override
  String get exportDataConfirm => 'האם ברצונך לייצא את כל הנתונים שלך כקובץ PDF?\n\nהקובץ יכלול:\n• את כל הערים והועדות\n• את כל הלקוחות\n• את כל הפרויקטים\n• סטטיסטיקה כללית';

  @override
  String get exportDataButton => 'יצא נתונים';

  @override
  String get exportingData => 'מייצא נתונים...';

  @override
  String get dataExportedSuccessfully => 'הנתונים יוצאו בהצלחה';

  @override
  String get errorExportingData => 'שגיאה ביצוא נתונים';

  @override
  String get backupAndRestore => 'גיבוי ושחזור נתונים';

  @override
  String get backupAllData => 'גבה את כל הנתונים שלך (ערים, לקוחות, פרויקטים) לקובץ JSON ושחזר בעת הצורך';

  @override
  String get exportAllDataBackup => 'יצא את כל הנתונים (גיבוי)';

  @override
  String get restoreDataFromBackup => 'שחזר נתונים מגיבוי';

  @override
  String get cityAddedSuccessfully => 'העיר נוספה בהצלחה';

  @override
  String get pleaseSelectHandlingCommittee => 'נא לבחור ועדה מטפלת';

  @override
  String get clientDetailsUpdatedSuccessfully => 'פרטי הלקוח עודכנו בהצלחה';

  @override
  String get pleaseEnterIdNumber => 'נא להזין מספר תעודת זהות';

  @override
  String get idMustBe9Digits => 'תעודת זהות חייבת להיות בת 9 ספרות';

  @override
  String get idMustContainOnlyDigits => 'תעודת זהות חייבת להכיל ספרות בלבד';

  @override
  String get editClientDetails => 'עריכת פרטי לקוח -';

  @override
  String get clientNameLabel => 'שם לקוח *';

  @override
  String get fullName => 'שם מלא';

  @override
  String get pleaseEnterClientName => 'נא להזין שם לקוח';

  @override
  String get clientNameMin2Chars => 'שם לקוח חייב להיות לפחות 2 תווים';

  @override
  String get propertyAddressLabel => 'כתובת הנכס *';

  @override
  String get streetNumberCity => 'רחוב, מספר, עיר';

  @override
  String get pleaseEnterPropertyAddress => 'נא להזין כתובת נכס';

  @override
  String get propertyAddressMin5Chars => 'כתובת נכס חייבת להיות לפחות 5 תווים';

  @override
  String get idNumberLabel => 'מספר תעודת זהות *';

  @override
  String get handlingCommitteeLabel => 'ועדה מטפלת *';

  @override
  String get searchOrSelectCommittee => 'חפש או בחר ועדה...';

  @override
  String get noCommitteesFound => 'לא נמצאו ועדות - הוסף ועדה על ידי לחיצה על כפתור ועדות';

  @override
  String get errorLoadingCommittees => 'שגיאה בטעינת ועדות';

  @override
  String get requiredFields => '* שדות חובה';

  @override
  String get updateDetails => 'עדכן פרטים';

  @override
  String get clientAddedSuccessfully => 'הלקוח נוסף בהצלחה';

  @override
  String get addNewClient => 'הוסף לקוח חדש';

  @override
  String get addClientButton => 'הוסף לקוח';

  @override
  String get committeeAddedSuccessfully => 'הועדה נוספה בהצלחה';

  @override
  String get addCommittee => 'הוסף ועדה';

  @override
  String get committeeName => 'שם ועדה';

  @override
  String get pleaseEnterCommitteeName => 'נא להזין שם ועדה';

  @override
  String get save => 'שמור';

  @override
  String get committeeUpdatedSuccessfully => 'הועדה עודכנה בהצלחה';

  @override
  String get editCommittee => 'ערוך ועדה';

  @override
  String get searchCommittees => 'חיפוש ועדות...';

  @override
  String get noCommitteesInSystem => 'אין ועדות במערכת';

  @override
  String get noCommitteesFoundSearch => 'לא נמצאו ועדות';

  @override
  String get addFirstCommittee => 'הוסף ועדה ראשונה כדי להתחיל';

  @override
  String get errorLoadingCommitteesList => 'שגיאה בטעינת הועדות';

  @override
  String get deleteCommitteeTitle => 'מחק ועדה';

  @override
  String confirmDeleteCommittee(Object name) {
    return 'האם אתה בטוח שברצונך למחוק את \"$name\"?';
  }

  @override
  String get committeeDeletedSuccessfully => 'הוועדה נמחקה בהצלחה';

  @override
  String get clientsIn => 'לקוחות -';

  @override
  String get searchClientsPlaceholder => 'חיפוש לקוחות...';

  @override
  String get noClientsFoundFor => 'לא נמצאו לקוחות עבור';

  @override
  String get loadingClients => 'טוען לקוחות...';

  @override
  String get noPermissionToAccessData => 'אין הרשאה לגשת לנתונים\nאנא התחבר מחדש';

  @override
  String get dataServiceUnavailable => 'שירות הנתונים אינו זמין\nבדוק את החיבור לאינטרנט';

  @override
  String get dataNotFound => 'הנתונים לא נמצאו\nייתכן שהעיר לא קיימת';

  @override
  String get errorLoadingData => 'שגיאה בטעינת הנתונים\nנסה שוב או פנה לתמיכה';

  @override
  String get addFirstClientToStart => 'הוסף לקוח ראשון כדי להתחיל';

  @override
  String get errorLoadingClientDetails => 'שגיאה בטעינת פרטי לקוח';

  @override
  String get back => 'חזור';

  @override
  String get clientNotFound => 'לקוח לא נמצא';

  @override
  String get clientDetailsTitle => 'פרטי לקוח';

  @override
  String get idNumberInfo => 'מספר ת.ז';

  @override
  String get propertyAddressInfo => 'כתובת הנכס';

  @override
  String get handlingCommitteeInfo => 'ועדה מטפלת';

  @override
  String get viewProject => 'צפה בפרויקט';

  @override
  String get edit => 'ערוך';

  @override
  String get exportDetails => 'יצא פרטים';

  @override
  String get deleteClient => 'מחק לקוח';

  @override
  String get deleteClientTitle => 'מחק לקוח';

  @override
  String confirmDeleteClient(Object name) {
    return 'האם אתה בטוח שברצונך למחוק את $name?\nפעולה זו אינה הפיכה.';
  }

  @override
  String get clientDeletedSuccessfully => 'הלקוח נמחק בהצלחה';

  @override
  String get errorDeletingClient => 'שגיאה במחיקת לקוח';

  @override
  String get committeeAlreadyExists => 'הועדה כבר קיימת';

  @override
  String get errorAddingCommittee => 'שגיאה בהוספת ועדה';

  @override
  String get clientWithIdAlreadyExists => 'לקוח עם תעודת זהות זו כבר קיים במערכת';

  @override
  String get noPermissionForAction => 'אין הרשאה לבצע פעולה זו - אנא התחבר מחדש';

  @override
  String get firebaseServiceUnavailable => 'שירות Firebase אינו זמין - בדוק את החיבור לאינטרנט';

  @override
  String get firebaseError => 'שגיאת Firebase';

  @override
  String get errorAddingClient => 'שגיאה בהוספת לקוח';

  @override
  String get errorGeneral => 'שגיאה';

  @override
  String get accountPendingApproval => 'חשבונך ממתין לאישור. אנא המתן עד שמנהל המערכת יאשר את החשבון שלך.';

  @override
  String get pendingUsers => 'משתמשים ממתינים';

  @override
  String get userManagement => 'ניהול משתמשים';

  @override
  String get refreshData => 'רענן נתונים...';

  @override
  String get approve => 'אשר';

  @override
  String get reject => 'דחה';

  @override
  String userApprovedSuccessfully(Object email) {
    return 'משתמש $email אושר בהצלחה';
  }

  @override
  String get errorApprovingUser => 'שגיאה באישור משתמש';

  @override
  String userRejected(Object email) {
    return 'משתמש $email נדחה';
  }

  @override
  String get errorRejectingUser => 'שגיאה בדחיית משתמש';

  @override
  String get noAdminPermissions => 'אין לך הרשאות מנהל';

  @override
  String get noPendingUsers => 'אין משתמשים ממתינים לאישור';

  @override
  String get noUsersInSystem => 'אין משתמשים במערכת';

  @override
  String get errorSigningOut => 'שגיאה בהתנתקות';

  @override
  String get cityName => 'שם העיר';

  @override
  String get enterCityName => 'נא להזין שם עיר';

  @override
  String get cityNameMin2Chars => 'שם העיר חייב להיות לפחות 2 תווים';

  @override
  String get description => 'תיאור';

  @override
  String get descriptionOptional => 'תיאור (אופציונלי)';

  @override
  String get errorAddingCity => 'שגיאה בהוספת עיר';

  @override
  String get lightModeTooltip => 'מצב יום';

  @override
  String get darkModeTooltip => 'מצב לילה';

  @override
  String get pendingApprovalTitle => 'ממתין לאישור';

  @override
  String get accountCreatedAwaitingApproval => 'חשבונך נוצר בהצלחה וממתין לאישור מנהל המערכת.';

  @override
  String get pleaseWaitForApproval => 'אנא המתן לאישור המנהל. לחץ על \'בדוק סטטוס שוב\' כדי לנסות להתחבר מחדש.';

  @override
  String get checkStatusAgain => 'בדוק סטטוס שוב';

  @override
  String get adminPanel => 'פאנל ניהול';

  @override
  String get systemAdminLogin => 'כניסה למנהלי מערכת';

  @override
  String get emailAddress => 'כתובת מייל';

  @override
  String get enterEmailAddress => 'נא להזין כתובת מייל';

  @override
  String get loginToPanel => 'כניסה לפאנל';

  @override
  String get backToMainApp => 'חזרה לאפליקציה הראשית';

  @override
  String get refreshingData => 'רענון נתונים...';

  @override
  String get pendingApproval => 'ממתינים לאישור';

  @override
  String get allUsers => 'כל המשתמשים';

  @override
  String get registrationDate => 'תאריך הרשמה';

  @override
  String get approvalDate => 'תאריך אישור';

  @override
  String get approvedBy => 'אושר על ידי';

  @override
  String get rejectionDate => 'תאריך דחייה';

  @override
  String get rejectedBy => 'נדחה על ידי';

  @override
  String get errorLoggingOut => 'שגיאה בהתנתקות';

  @override
  String get notLoggedIn => 'לא מחובר למערכת';

  @override
  String get invalidCredentials => 'פרטי התחברות שגויים - אימייל או סיסמה לא נכונים';

  @override
  String get generalError => 'שגיאה כללית';

  @override
  String get accountPendingApprovalMessage => 'חשבונך ממתין לאישור מנהל. נא להמתין לאישור.';

  @override
  String get accountRejectedMessage => 'חשבונך נדחה. נא לפנות למנהל המערכת.';

  @override
  String get accountNotApprovedMessage => 'חשבונך טרם אושר. נא לפנות למנהל המערכת.';

  @override
  String get unknownError => 'שגיאה לא ידועה';

  @override
  String get loginError => 'שגיאה בהתחברות';

  @override
  String get accountCreatedSuccessfully => 'חשבון נוצר בהצלחה!';

  @override
  String get accountAwaitingApproval => 'החשבון שלך ממתין לאישור מנהל. אנא המתן עד שהמנהל יאשר את החשבון.';

  @override
  String get approvalTime => 'זמן אישור: 24-48 שעות בדרך כלל.';

  @override
  String get addStage => 'הוסף שלב';

  @override
  String get deleteStage => 'מחק שלב';

  @override
  String get stageTitle => 'שם השלב';

  @override
  String get enterStageName => 'הזן שם שלב...';

  @override
  String get editStageTitle => 'ערוך שם שלב';

  @override
  String confirmDeleteStage(Object name) {
    return 'האם אתה בטוח שברצונך למחוק את השלב \"$name\"? פעולה זו תמחק את כל המשימות בשלב זה.';
  }
}
