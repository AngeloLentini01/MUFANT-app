import 'package:app/data/generic/people/phoneContact/phone_country_code_model.dart';
import 'package:app/data/generic/details_model.dart';
import 'package:ulid/ulid.dart';

/// Represents a phone contact with country code and number.
/// 
/// @property id Unique identifier
/// @property details Descriptive information about the contact
/// @property localPhoneNumber The phone number without country code
/// @property countryCode The country code associated with this phone number
class PhoneContactModel {
  final Ulid id;
  final DetailsModel details;
  final String localPhoneNumber;
  final PhoneCountryCodeModel countryCode;

  const PhoneContactModel({
    required this.id,
    required this.details,
    required this.localPhoneNumber,
    required this.countryCode,
  });

  /// Returns the complete phone number with country code
  String get fullPhoneNumber => '${countryCode.countryCode}$localPhoneNumber';
}
