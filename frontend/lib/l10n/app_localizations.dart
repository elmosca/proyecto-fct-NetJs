// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

abstract class AppLocalizations {
  AppLocalizations(this.localeName);

  final String localeName;

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(_current != null,
        'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  static Future<AppLocalizations> load(Locale locale) async {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = name;

    AppLocalizations instance;
    switch (localeName) {
      case 'en':
        instance = AppLocalizationsEn();
        break;
      case 'es':
        instance = AppLocalizationsEs();
        break;
      default:
        instance = AppLocalizationsEn(); // Default to English
    }

    AppLocalizations._current = instance;
    return instance;
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Abstract getters for all the strings
  String get appTitle;
  String get dashboard;
  String get projects;
  String get tasks;
  String get milestones;
  String get profile;
  String get settings;
  String get login;
  String get register;
  String get logout;
  String get email;
  String get password;
  String get firstName;
  String get lastName;
  String get create;
  String get edit;
  String get delete;
  String get save;
  String get cancel;
  String get submit;
  String get taskDetails;
  String get basicInformation;
  String get metadata;
  String get actions;
  String get changeStatus;
  String get createdAt;
  String get updatedAt;
  String get createdBy;
  String get project;
  String get createMilestone;
  String get editMilestone;
  String get deleteMilestone;
  String get deleteMilestoneConfirmation;
  String get milestoneDetails;
  String get milestoneNumber;
  String get plannedDate;
  String get completedDate;
  String get milestoneType;
  String get expectedDeliverables;
  String get reviewComments;
  String get isFromAnteproject;
  String get noMilestones;
  String get noMilestonesMessage;
  String get createFirstMilestone;
  String get milestoneNumberRequired;
  String get plannedDateRequired;
  String get completeMilestone;
  String get milestoneCompleted;
  String get milestoneDelayed;
  String get milestoneInProgress;
  String get milestonePending;
  String get assignUsers;
  String get assignUserToTask;
  String get unassignUser;
  String get assignedUsers;
  String get availableUsers;
  String get selectUsers;
  String get searchUsers;
  String get noUsersAssigned;
  String get noUsersAvailable;
  String get userAssignedSuccessfully;
  String get userUnassignedSuccessfully;
  String get errorAssigningUser;
  String get errorUnassigningUser;
  String get assignUser;
  String get unassignUserButton;
  String get userManagement;
  String get filterByRole;
  String get allRoles;
  String get student;
  String get tutor;
  String get admin;
  String get clear;
  String get apply;
  String get add;
  String get search;
  String get filter;
  String get filters;
  String get all;
  String get status;
  String get priority;
  String get complexity;
  String get title;
  String get description;
  String get dueDate;
  String get estimatedHours;
  String get tags;
  String get assignees;
  String get createTask;
  String get deleteTask;
  String get listView;
  String get kanbanView;
  String get searchTasksHint;
  String get selectDateRange;
  String get loading;
  String get error;
  String get info;
  String get noData;
  String get noDataMessage;
  String get noTasks;
  String get noTasksMessage;
  String get createFirstTask;
  String get editTask;
  String get deleteTaskConfirmation;
  String get descriptionRequired;
  String get titleRequired;
  String get language;
  String get dark;
  String get light;

  // Additional strings used in the codebase
  String get users;
  String get anteprojectDetails;
  String get anteprojectNotFound;
  String get anteprojectsTitle;
  String get noAnteprojectsTitle;
  String get noAnteprojectsMessage;
  String get createAnteproject;
  String get deleteAnteprojectTitle;
  String get deleteAnteprojectMessage;
  String get submitAnteprojectTitle;
  String get submitAnteprojectMessage;
  String get searchAnteprojects;
  String get allStatuses;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
