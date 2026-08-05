/// Localized country / currency entry parsed from
/// `assets/country_codes_currency.json`.
///
/// UI-only port: only the English localization is surfaced for now.
class CountryCodeAndCurrencyModel {
  Country? country;
  String? dialCode;
  Country? currency;

  CountryCodeAndCurrencyModel({this.country, this.dialCode, this.currency});

  CountryCodeAndCurrencyModel.fromJson(Map<String, dynamic> json) {
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    dialCode = json['dial_code'];
    currency =
        json['currency'] != null ? Country.fromJson(json['currency']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (country != null) {
      data['country'] = country!.toJson();
    }
    data['dial_code'] = dialCode;
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    return data;
  }
}

/// A single localization bundle (en / ar / fr).
class Country {
  String? en;
  String? ar;
  String? fr;

  /// English-first localized label used by the settings screens.
  String get localized => en ?? '';

  Country({this.en, this.ar, this.fr});

  Country.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
    fr = json['fr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    data['ar'] = ar;
    data['fr'] = fr;
    return data;
  }
}

/// Stub user model backing the personal-information screens until an auth
/// feature is wired up.
class SettingsUser {
  const SettingsUser({
    this.fullName = 'John Doe',
    this.businessName = 'My Business',
    this.phoneNumber = '5551234567',
    this.countryCode = '+1',
    this.address = '',
    this.email = 'user@example.com',
    this.profilePicture,
  });

  final String fullName;
  final String businessName;
  final String phoneNumber;
  final String countryCode;
  final String address;
  final String email;

  /// Base64-encoded profile image, if any.
  final String? profilePicture;

  SettingsUser copyWith({
    String? fullName,
    String? businessName,
    String? phoneNumber,
    String? countryCode,
    String? address,
    String? email,
    String? profilePicture,
  }) {
    return SettingsUser(
      fullName: fullName ?? this.fullName,
      businessName: businessName ?? this.businessName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      address: address ?? this.address,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}