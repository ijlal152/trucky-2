import 'package:trucky/presentation/settings/bloc/settings_models.dart';

/// Operation status for the settings screens.
enum SettingsStatus {
  initial,
  loading,
  loaded,
  error,
  savingLanguage,
  languageSaved,
  savingCurrency,
  currencySaved,
  backingUp,
  backedUp,
}

/// Available app languages surfaced by the language screen.
enum PreferredLanguage { english, arabic, french }

/// State exposed by [SettingsBloc].
class SettingsState {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.languagesList = const [],
    this.selectedLanguageIndex = -1,
    this.preferredLanguage,
    this.allCountries = const [],
    this.searchedCountries = const [],
    this.selectedCountryData,
    this.selectedCurrency,
    this.selectedCountry,
    this.selectedDialCode,
    this.isBackedUp = false,
    this.lastBackupAt,
    this.isLoading = false,
    this.user = const SettingsUser(),
    this.errorMessage,
  });

  final SettingsStatus status;
  final List<String> languagesList;
  final int selectedLanguageIndex;
  final PreferredLanguage? preferredLanguage;
  final List<CountryCodeAndCurrencyModel> allCountries;
  final List<CountryCodeAndCurrencyModel> searchedCountries;
  final CountryCodeAndCurrencyModel? selectedCountryData;
  final String? selectedCurrency;
  final String? selectedCountry;
  final String? selectedDialCode;
  final bool isBackedUp;
  final DateTime? lastBackupAt;
  final bool isLoading;
  final SettingsUser user;
  final String? errorMessage;

  SettingsState copyWith({
    SettingsStatus? status,
    List<String>? languagesList,
    int? selectedLanguageIndex,
    PreferredLanguage? preferredLanguage,
    List<CountryCodeAndCurrencyModel>? allCountries,
    List<CountryCodeAndCurrencyModel>? searchedCountries,
    CountryCodeAndCurrencyModel? selectedCountryData,
    String? selectedCurrency,
    String? selectedCountry,
    String? selectedDialCode,
    bool? isBackedUp,
    DateTime? lastBackupAt,
    bool? isLoading,
    SettingsUser? user,
    String? errorMessage,
    bool clearSelectedCountry = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      languagesList: languagesList ?? this.languagesList,
      selectedLanguageIndex: selectedLanguageIndex ?? this.selectedLanguageIndex,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      allCountries: allCountries ?? this.allCountries,
      searchedCountries: searchedCountries ?? this.searchedCountries,
      selectedCountryData: clearSelectedCountry
          ? null
          : (selectedCountryData ?? this.selectedCountryData),
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedDialCode: selectedDialCode ?? this.selectedDialCode,
      isBackedUp: isBackedUp ?? this.isBackedUp,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}