import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('es')
  ];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @registerLink.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get registerLink;

  /// No description provided for @projectTitle.
  ///
  /// In en, this message translates to:
  /// **'Project Title'**
  String get projectTitle;

  /// No description provided for @projectDescription.
  ///
  /// In en, this message translates to:
  /// **'Project Description'**
  String get projectDescription;

  /// No description provided for @createProject.
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get createProject;

  /// No description provided for @editProject.
  ///
  /// In en, this message translates to:
  /// **'Edit Project'**
  String get editProject;

  /// No description provided for @deleteProject.
  ///
  /// In en, this message translates to:
  /// **'Delete Project'**
  String get deleteProject;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get confirmDelete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @createExport.
  ///
  /// In en, this message translates to:
  /// **'Create Export'**
  String get createExport;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Title'**
  String get exportTitle;

  /// No description provided for @exportDescription.
  ///
  /// In en, this message translates to:
  /// **'Export Description'**
  String get exportDescription;

  /// No description provided for @exportFormat.
  ///
  /// In en, this message translates to:
  /// **'Export Format'**
  String get exportFormat;

  /// No description provided for @exportFilters.
  ///
  /// In en, this message translates to:
  /// **'Export Filters'**
  String get exportFilters;

  /// No description provided for @projectId.
  ///
  /// In en, this message translates to:
  /// **'Project ID'**
  String get projectId;

  /// No description provided for @milestoneId.
  ///
  /// In en, this message translates to:
  /// **'Milestone ID'**
  String get milestoneId;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @taskStatus.
  ///
  /// In en, this message translates to:
  /// **'Task Status'**
  String get taskStatus;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Status'**
  String get selectStatus;

  /// No description provided for @exportColumns.
  ///
  /// In en, this message translates to:
  /// **'Export Columns'**
  String get exportColumns;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @selectAtLeastOneColumn.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one column'**
  String get selectAtLeastOneColumn;

  /// No description provided for @milestoneDetails.
  ///
  /// In en, this message translates to:
  /// **'Milestone Details'**
  String get milestoneDetails;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @milestoneType.
  ///
  /// In en, this message translates to:
  /// **'Milestone Type'**
  String get milestoneType;

  /// No description provided for @plannedDate.
  ///
  /// In en, this message translates to:
  /// **'Planned Date'**
  String get plannedDate;

  /// No description provided for @completedDate.
  ///
  /// In en, this message translates to:
  /// **'Completed Date'**
  String get completedDate;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get updatedAt;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @metadata.
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get metadata;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @isFromAnteproject.
  ///
  /// In en, this message translates to:
  /// **'From Anteproject'**
  String get isFromAnteproject;

  /// No description provided for @expectedDeliverables.
  ///
  /// In en, this message translates to:
  /// **'Expected Deliverables'**
  String get expectedDeliverables;

  /// No description provided for @reviewComments.
  ///
  /// In en, this message translates to:
  /// **'Review Comments'**
  String get reviewComments;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @changeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change Status'**
  String get changeStatus;

  /// No description provided for @deleteMilestone.
  ///
  /// In en, this message translates to:
  /// **'Delete Milestone'**
  String get deleteMilestone;

  /// No description provided for @deleteMilestoneConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this milestone?'**
  String get deleteMilestoneConfirmation;

  /// No description provided for @editMilestone.
  ///
  /// In en, this message translates to:
  /// **'Edit Milestone'**
  String get editMilestone;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @milestoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Milestone Number'**
  String get milestoneNumber;

  /// No description provided for @milestoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Milestone number is required'**
  String get milestoneNumberRequired;

  /// No description provided for @plannedDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Planned date is required'**
  String get plannedDateRequired;

  /// No description provided for @milestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get milestones;

  /// No description provided for @noMilestones.
  ///
  /// In en, this message translates to:
  /// **'No Milestones'**
  String get noMilestones;

  /// No description provided for @noMilestonesMessage.
  ///
  /// In en, this message translates to:
  /// **'No milestones found. Create your first milestone to get started.'**
  String get noMilestonesMessage;

  /// No description provided for @progressReport.
  ///
  /// In en, this message translates to:
  /// **'Progress Report'**
  String get progressReport;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Data'**
  String get errorLoadingData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @filterReport.
  ///
  /// In en, this message translates to:
  /// **'Filter Report'**
  String get filterReport;

  /// No description provided for @allProjects.
  ///
  /// In en, this message translates to:
  /// **'All Projects'**
  String get allProjects;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @taskDetails.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get taskDetails;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @complexity.
  ///
  /// In en, this message translates to:
  /// **'Complexity'**
  String get complexity;

  /// No description provided for @estimatedHours.
  ///
  /// In en, this message translates to:
  /// **'Estimated Hours'**
  String get estimatedHours;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @assignees.
  ///
  /// In en, this message translates to:
  /// **'Assignees'**
  String get assignees;

  /// No description provided for @assignedUsers.
  ///
  /// In en, this message translates to:
  /// **'Assigned Users'**
  String get assignedUsers;

  /// No description provided for @assignUsers.
  ///
  /// In en, this message translates to:
  /// **'Assign Users'**
  String get assignUsers;

  /// No description provided for @noUsersAssigned.
  ///
  /// In en, this message translates to:
  /// **'No users assigned'**
  String get noUsersAssigned;

  /// No description provided for @deleteTask.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTask;

  /// No description provided for @deleteTaskConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task?'**
  String get deleteTaskConfirmation;

  /// No description provided for @taskExportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Exports'**
  String get taskExportsTitle;

  /// No description provided for @noExportsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Exports'**
  String get noExportsTitle;

  /// No description provided for @noExportsMessage.
  ///
  /// In en, this message translates to:
  /// **'No exports found. Create your first export to get started.'**
  String get noExportsMessage;

  /// No description provided for @errorLoadingExports.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Exports'**
  String get errorLoadingExports;

  /// No description provided for @exportDownloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Export download started'**
  String get exportDownloadStarted;

  /// No description provided for @deleteExport.
  ///
  /// In en, this message translates to:
  /// **'Delete Export'**
  String get deleteExport;

  /// No description provided for @deleteExportConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this export?'**
  String get deleteExportConfirmation;

  /// No description provided for @exportDeleted.
  ///
  /// In en, this message translates to:
  /// **'Export deleted successfully'**
  String get exportDeleted;

  /// No description provided for @cancelExport.
  ///
  /// In en, this message translates to:
  /// **'Cancel Export'**
  String get cancelExport;

  /// No description provided for @cancelExportConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this export?'**
  String get cancelExportConfirmation;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @exportCancelled.
  ///
  /// In en, this message translates to:
  /// **'Export cancelled successfully'**
  String get exportCancelled;

  /// No description provided for @filterExports.
  ///
  /// In en, this message translates to:
  /// **'Filter Exports'**
  String get filterExports;

  /// No description provided for @allFormats.
  ///
  /// In en, this message translates to:
  /// **'All Formats'**
  String get allFormats;

  /// No description provided for @exportStatus.
  ///
  /// In en, this message translates to:
  /// **'Export Status'**
  String get exportStatus;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get allStatuses;

  /// No description provided for @taskNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Notifications'**
  String get taskNotificationsTitle;

  /// No description provided for @noNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get noNotificationsTitle;

  /// No description provided for @noNotificationsMessage.
  ///
  /// In en, this message translates to:
  /// **'No notifications found. You\'re all caught up!'**
  String get noNotificationsMessage;

  /// No description provided for @errorLoadingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Notifications'**
  String get errorLoadingNotifications;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get markAllAsRead;

  /// No description provided for @notificationMarkedAsRead.
  ///
  /// In en, this message translates to:
  /// **'Notification marked as read'**
  String get notificationMarkedAsRead;

  /// No description provided for @deleteNotification.
  ///
  /// In en, this message translates to:
  /// **'Delete Notification'**
  String get deleteNotification;

  /// No description provided for @deleteNotificationConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this notification?'**
  String get deleteNotificationConfirmation;

  /// No description provided for @notificationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted successfully'**
  String get notificationDeleted;

  /// No description provided for @allNotificationsMarkedAsRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get allNotificationsMarkedAsRead;

  /// No description provided for @filterNotifications.
  ///
  /// In en, this message translates to:
  /// **'Filter Notifications'**
  String get filterNotifications;

  /// No description provided for @unreadOnly.
  ///
  /// In en, this message translates to:
  /// **'Unread Only'**
  String get unreadOnly;

  /// No description provided for @notificationType.
  ///
  /// In en, this message translates to:
  /// **'Notification Type'**
  String get notificationType;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypes;

  /// No description provided for @taskReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Reports'**
  String get taskReportsTitle;

  /// No description provided for @createReport.
  ///
  /// In en, this message translates to:
  /// **'Create Report'**
  String get createReport;

  /// No description provided for @noReportsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Reports Available'**
  String get noReportsAvailable;

  /// No description provided for @createFirstReport.
  ///
  /// In en, this message translates to:
  /// **'Create your first report to get started'**
  String get createFirstReport;

  /// No description provided for @errorLoadingReports.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Reports'**
  String get errorLoadingReports;

  /// No description provided for @deleteReport.
  ///
  /// In en, this message translates to:
  /// **'Delete Report'**
  String get deleteReport;

  /// No description provided for @deleteReportConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this report?'**
  String get deleteReportConfirmation;

  /// No description provided for @reportDeleted.
  ///
  /// In en, this message translates to:
  /// **'Report deleted successfully'**
  String get reportDeleted;

  /// No description provided for @reportExported.
  ///
  /// In en, this message translates to:
  /// **'Report exported successfully'**
  String get reportExported;

  /// No description provided for @errorExportingReport.
  ///
  /// In en, this message translates to:
  /// **'Error exporting report'**
  String get errorExportingReport;

  /// No description provided for @featureNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'This feature is not yet implemented'**
  String get featureNotImplemented;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get listView;

  /// No description provided for @kanbanView.
  ///
  /// In en, this message translates to:
  /// **'Kanban View'**
  String get kanbanView;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @createTask.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get createTask;

  /// No description provided for @noTasks.
  ///
  /// In en, this message translates to:
  /// **'No Tasks'**
  String get noTasks;

  /// No description provided for @noTasksMessage.
  ///
  /// In en, this message translates to:
  /// **'No tasks found. Create your first task to get started.'**
  String get noTasksMessage;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search Users'**
  String get searchUsers;

  /// No description provided for @filterByRole.
  ///
  /// In en, this message translates to:
  /// **'Filter by Role'**
  String get filterByRole;

  /// No description provided for @allRoles.
  ///
  /// In en, this message translates to:
  /// **'All Roles'**
  String get allRoles;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @tutor.
  ///
  /// In en, this message translates to:
  /// **'Tutor'**
  String get tutor;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @availableUsers.
  ///
  /// In en, this message translates to:
  /// **'Available Users'**
  String get availableUsers;

  /// No description provided for @noUsersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No users available'**
  String get noUsersAvailable;

  /// No description provided for @userAssignedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User assigned successfully'**
  String get userAssignedSuccessfully;

  /// No description provided for @errorAssigningUser.
  ///
  /// In en, this message translates to:
  /// **'Error assigning user'**
  String get errorAssigningUser;

  /// No description provided for @userUnassignedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User unassigned successfully'**
  String get userUnassignedSuccessfully;

  /// No description provided for @errorUnassigningUser.
  ///
  /// In en, this message translates to:
  /// **'Error unassigning user'**
  String get errorUnassigningUser;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @generating.
  ///
  /// In en, this message translates to:
  /// **'Generating'**
  String get generating;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @taskProgress.
  ///
  /// In en, this message translates to:
  /// **'Task Progress'**
  String get taskProgress;

  /// No description provided for @taskPriority.
  ///
  /// In en, this message translates to:
  /// **'Task Priority'**
  String get taskPriority;

  /// No description provided for @noMilestonesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No milestones available'**
  String get noMilestonesAvailable;

  /// No description provided for @milestoneProgress.
  ///
  /// In en, this message translates to:
  /// **'Milestone Progress'**
  String get milestoneProgress;

  /// No description provided for @milestoneStatus.
  ///
  /// In en, this message translates to:
  /// **'Milestone Status'**
  String get milestoneStatus;

  /// No description provided for @recentTasks.
  ///
  /// In en, this message translates to:
  /// **'Recent Tasks'**
  String get recentTasks;

  /// No description provided for @recentMilestones.
  ///
  /// In en, this message translates to:
  /// **'Recent Milestones'**
  String get recentMilestones;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @completedAt.
  ///
  /// In en, this message translates to:
  /// **'Completed At'**
  String get completedAt;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @task.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get task;

  /// No description provided for @milestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone'**
  String get milestone;

  /// No description provided for @performanceMetrics.
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get performanceMetrics;

  /// No description provided for @taskCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Task Completion Rate'**
  String get taskCompletionRate;

  /// No description provided for @milestoneCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Milestone Completion Rate'**
  String get milestoneCompletionRate;

  /// No description provided for @averageTaskDuration.
  ///
  /// In en, this message translates to:
  /// **'Average Task Duration'**
  String get averageTaskDuration;

  /// No description provided for @onTimeCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'On-Time Completion Rate'**
  String get onTimeCompletionRate;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @lowPriority.
  ///
  /// In en, this message translates to:
  /// **'Low Priority'**
  String get lowPriority;

  /// No description provided for @mediumPriority.
  ///
  /// In en, this message translates to:
  /// **'Medium Priority'**
  String get mediumPriority;

  /// No description provided for @highPriority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get highPriority;

  /// No description provided for @criticalPriority.
  ///
  /// In en, this message translates to:
  /// **'Critical Priority'**
  String get criticalPriority;

  /// No description provided for @totalTasks.
  ///
  /// In en, this message translates to:
  /// **'Total Tasks'**
  String get totalTasks;

  /// No description provided for @noTasksAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tasks available'**
  String get noTasksAvailable;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @completedTasks.
  ///
  /// In en, this message translates to:
  /// **'Completed Tasks'**
  String get completedTasks;

  /// No description provided for @inProgressTasks.
  ///
  /// In en, this message translates to:
  /// **'In Progress Tasks'**
  String get inProgressTasks;

  /// No description provided for @overdueTasks.
  ///
  /// In en, this message translates to:
  /// **'Overdue Tasks'**
  String get overdueTasks;

  /// No description provided for @totalMilestones.
  ///
  /// In en, this message translates to:
  /// **'Total Milestones'**
  String get totalMilestones;

  /// No description provided for @completedMilestones.
  ///
  /// In en, this message translates to:
  /// **'Completed Milestones'**
  String get completedMilestones;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// No description provided for @assignUserToTask.
  ///
  /// In en, this message translates to:
  /// **'Assign User to Task'**
  String get assignUserToTask;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createMilestone.
  ///
  /// In en, this message translates to:
  /// **'Create Milestone'**
  String get createMilestone;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// No description provided for @searchTasksHint.
  ///
  /// In en, this message translates to:
  /// **'Search tasks...'**
  String get searchTasksHint;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @unassignUser.
  ///
  /// In en, this message translates to:
  /// **'Unassign User'**
  String get unassignUser;

  /// No description provided for @assignUser.
  ///
  /// In en, this message translates to:
  /// **'Assign User'**
  String get assignUser;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
