/// [NominatimAddress] represents the actual location address
/// with attributes as follows:
/// [houseNumber], [road], [neighbourhood],
/// [suburb], [city], [district], [state], [postalCode],
/// [country], [countryCode], [locale].
class NominatimAddress {
  /// [houseNumber] of the location.
  final String houseNumber;

  /// [road] name of the location.
  final String road;

  /// [neighbourhood] name of the location.
  final String neighbourhood;

  /// [suburb] name of the location.
  final String suburb;

  /// [city] name of the location.
  final String city;

  /// [district] of the location.
  final String district;

  /// [state] of the location.
  final String state;

  /// [postalCode] of the location.
  final int postalCode;

  /// [country] of the location.
  final String country;

  /// [countryCode] of the location.
  final String countryCode;

  const NominatimAddress({
    this.houseNumber = '',
    this.road = '',
    this.neighbourhood = '',
    this.suburb = '',
    required this.city,
    this.district = '',
    this.state = '',
    required this.postalCode,
    this.country = '',
    this.countryCode = '',
  });

  /// Create [NominatimAddress] from json [Map] object.
  factory NominatimAddress.fromJson(Map<String, dynamic> json) {
    return NominatimAddress(
      houseNumber: json.containsKey('house_number') ? json['house_number'] : '',
      road: json.containsKey('road') ? json['road'] : '',
      neighbourhood: json.containsKey('neighbourhood') ? json['neighbourhood'] : '',
      suburb: json.containsKey('suburb') ? json['suburb'] : '',
      city: json.containsKey('city') ? json['city'] : '',
      district: json.containsKey('state_district')
          ? json['state_district']
          : json.containsKey('city_district')
              ? json['city_district']
              : '',
      state: json.containsKey('state') ? json['state'] : '',
      postalCode: json.containsKey('postcode')
          ? int.parse(json['postcode'].toString().replaceAll('.', ''))
          : 0,
      country: json.containsKey('country') ? json['country'] : '',
      countryCode: json.containsKey('country_code') ? json['country_code'] : '',
    );
  }

  /// Json [Map] object of this [NominatimAddress].
  Map<String, dynamic> toJson() {
    return {
      'house_number': houseNumber,
      'road': road,
      'neighbourhood': neighbourhood,
      'suburb': suburb,
      'city': city,
      'district': district,
      'state': state,
      'postcode': postalCode,
      'country': country,
      'country_code': countryCode,
    };
  }

  @override
  String toString() {
    return 'Address(house_number: $houseNumber, road: $road, neighbourhood: $neighbourhood, suburb: $suburb, city: $city, district: $district, state: $state, postcode: $postalCode, country: $country, country_code: $countryCode})';
  }

  /// Get [String] request of the this instance
  String get requestStr {
    return '$houseNumber $road $neighbourhood $suburb $city, $district $state $postalCode $country'
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Check if any of the field of this instance other than city and postal code.
  bool get checkEmpty {
    return houseNumber.isEmpty ||
        road.isEmpty ||
        neighbourhood.isEmpty ||
        suburb.isEmpty ||
        district.isEmpty ||
        state.isEmpty ||
        country.isEmpty ||
        countryCode.isEmpty;
  }

  /// Copy this [NominatimAddress] with the given attributes if given not null.
  NominatimAddress copyWith({
    String? houseNumber,
    String? road,
    String? neighbourhood,
    String? suburb,
    String? city,
    String? district,
    String? state,
    int? postalCode,
    String? country,
    String? countryCode,
  }) {
    return NominatimAddress(
      houseNumber: houseNumber ?? this.houseNumber,
      road: road ?? this.road,
      neighbourhood: neighbourhood ?? this.neighbourhood,
      suburb: suburb ?? this.suburb,
      city: city ?? this.city,
      district: district ?? this.district,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
    );
  }
}
