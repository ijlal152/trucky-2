import 'package:trucky/presentation/settings/bloc/settings_models.dart';

/// Events accepted by [SettingsBloc].
sealed class SettingsEvent {
  const SettingsEvent();
}

/// Loads the queryable country / currency list from the bundled JSON asset.
class LoadCountriesEvent extends SettingsEvent {
  const LoadCountriesEvent();
}

/// Selects one of the bundled app languages by its list index.
class SelectLanguageEvent extends SettingsEvent {
  const SelectLanguageEvent({required this.index});

  final int index;
}

/// Filters [SettingsState.searchedCountries] by the given query.
class SearchCurrencyEvent extends SettingsEvent {
  const SearchCurrencyEvent({required this.query});

  final String query;
}

/// Persists the selected currency (in-memory for now) by list index.
class SelectCurrencyEvent extends SettingsEvent {
  const SelectCurrencyEvent({required this.index});

  final int index;
}

/// Picks a country/currency from the dial-code bottom sheet.
class SelectCountryDataEvent extends SettingsEvent {
  const SelectCountryDataEvent({required this.country});

  final CountryCodeAndCurrencyModel country;
}

/// Updates the stub user profile used by the personal-info screens.
class UpdateUserEvent extends SettingsEvent {
  const UpdateUserEvent({
    this.fullName,
    this.businessName,
    this.phoneNumber,
    this.countryCode,
    this.address,
    this.profilePicture,
  });

  final String? fullName;
  final String? businessName;
  final String? phoneNumber;
  final String? countryCode;
  final String? address;
  final String? profilePicture;
}

/// Re-checks the (stubbed) backup status.
class CheckBackupStatusEvent extends SettingsEvent {
  const CheckBackupStatusEvent();
}

/// Runs a simulated backup operation.
class RunBackupEvent extends SettingsEvent {
  const RunBackupEvent();
}