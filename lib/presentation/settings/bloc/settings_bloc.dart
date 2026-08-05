import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/presentation/settings/bloc/settings_event.dart';
import 'package:trucky/presentation/settings/bloc/settings_models.dart';
import 'package:trucky/presentation/settings/bloc/settings_state.dart';

/// Holds settings UI state and exposes mutations for the settings screens.
///
/// UI-only port: language & currency selection are kept in-memory and no auth
/// or persistence is wired yet.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<LoadCountriesEvent>(_onLoadCountries);
    on<SelectLanguageEvent>(_onSelectLanguage);
    on<SearchCurrencyEvent>(_onSearchCurrency);
    on<SelectCurrencyEvent>(_onSelectCurrency);
    on<SelectCountryDataEvent>(_onSelectCountryData);
    on<UpdateUserEvent>(_onUpdateUser);
    on<CheckBackupStatusEvent>(_onCheckBackupStatus);
    on<RunBackupEvent>(_onRunBackup);
  }

  static const List<String> _languages = ['English', 'French', 'Arabic'];

  Future<void> _onLoadCountries(
    LoadCountriesEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state.allCountries.isNotEmpty) {
      return;
    }

    emit(state.copyWith(status: SettingsStatus.loading, isLoading: true));
    try {
      final jsonString = await rootBundle
          .loadString('assets/country_codes_currency.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);
      final countries = jsonResponse
          .map((item) => CountryCodeAndCurrencyModel.fromJson(item))
          .toList();

      emit(
        state.copyWith(
          status: SettingsStatus.loaded,
          allCountries: countries,
          searchedCountries: countries,
          languagesList: _languages,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          isLoading: false,
          errorMessage: 'Failed to load countries: $e',
        ),
      );
    }
  }

  void _onSelectLanguage(
    SelectLanguageEvent event,
    Emitter<SettingsState> emit,
  ) {
    if (event.index < 0 ||
        event.index >= _languages.length ||
        event.index == state.selectedLanguageIndex) {
      return;
    }
    final preferred = switch (event.index) {
      0 => PreferredLanguage.english,
      1 => PreferredLanguage.french,
      _ => PreferredLanguage.arabic,
    };
    emit(
      state.copyWith(
        selectedLanguageIndex: event.index,
        preferredLanguage: preferred,
        status: SettingsStatus.languageSaved,
      ),
    );
  }

  void _onSearchCurrency(
    SearchCurrencyEvent event,
    Emitter<SettingsState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? List.of(state.allCountries)
        : state.allCountries.where((value) {
            final countryName = value.country?.en?.toLowerCase() ?? '';
            final currencyName = value.currency?.en?.toLowerCase() ?? '';
            return countryName.contains(query) ||
                currencyName.contains(query);
          }).toList();
    emit(state.copyWith(searchedCountries: filtered));
  }

  void _onSelectCurrency(
    SelectCurrencyEvent event,
    Emitter<SettingsState> emit,
  ) {
    if (event.index < 0 || event.index >= state.searchedCountries.length) {
      return;
    }
    final selected = state.searchedCountries[event.index];
    final newSelected = CountryCodeAndCurrencyModel(
      currency: selected.currency,
      country: selected.country,
      dialCode: selected.dialCode,
    );
    emit(
      state.copyWith(
        status: SettingsStatus.currencySaved,
        selectedCurrency: selected.currency?.en ?? '',
        selectedCountryData: newSelected,
        searchedCountries: List.of(state.allCountries),
      ),
    );
  }

  void _onSelectCountryData(
    SelectCountryDataEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(selectedCountryData: event.country));
  }

  void _onUpdateUser(UpdateUserEvent event, Emitter<SettingsState> emit) {
    emit(
      state.copyWith(
        user: state.user.copyWith(
          fullName: event.fullName,
          businessName: event.businessName,
          phoneNumber: event.phoneNumber,
          countryCode: event.countryCode,
          address: event.address,
          profilePicture: event.profilePicture,
        ),
      ),
    );
  }

  void _onCheckBackupStatus(
    CheckBackupStatusEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(status: SettingsStatus.loaded));
  }

  Future<void> _onRunBackup(
    RunBackupEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.backingUp));
    await Future<void>.delayed(const Duration(seconds: 2));
    emit(
      state.copyWith(
        status: SettingsStatus.backedUp,
        isBackedUp: true,
        lastBackupAt: DateTime.now(),
      ),
    );
  }
}