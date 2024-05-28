class AddressModel {
  final String addressId;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  AddressModel({
    required this.addressId,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'addressId': addressId,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }
   factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      addressId: map['addressId'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      country: map['country'] ?? '',
    );
  }
}