class PaymentMethodCustom {
  String id;
  String object;
  String allowRedisplay;
  BillingDetailsCustom billingDetails;
  Card card;
  int created;
  String customer;
  bool livemode;
  Map<String, dynamic> metadata;
  String type;

  PaymentMethodCustom({
    required this.id,
    required this.object,
    required this.allowRedisplay,
    required this.billingDetails,
    required this.card,
    required this.created,
    required this.customer,
    required this.livemode,
    required this.metadata,
    required this.type,
  });

  factory PaymentMethodCustom.fromJson(Map<String, dynamic> json) {
    return PaymentMethodCustom(
      id: json['id'],
      object: json['object'],
      allowRedisplay: json['allow_redisplay'],
      billingDetails: BillingDetailsCustom.fromJson(json['billing_details']),
      card: Card.fromJson(json['card']),
      created: json['created'],
      customer: json['customer'],
      livemode: json['livemode'],
      metadata: json['metadata'],
      type: json['type'],
    );
  }
}

class BillingDetailsCustom {
  Address address;
  String? email;
  String? name;
  String? phone;

  BillingDetailsCustom({
    required this.address,
    required this.email,
    required this.name,
    required this.phone,
  });

  factory BillingDetailsCustom.fromJson(Map<String, dynamic> json) {
    return BillingDetailsCustom(
      address: Address.fromJson(json['address']),
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}

class Address {
  String? city;
  String country;
  String? line1;
  String? line2;
  String? postalCode;
  String? state;

  Address({
    required this.city,
    required this.country,
    required this.line1,
    required this.line2,
    required this.postalCode,
    required this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      country: json['country'],
      line1: json['line1'],
      line2: json['line2'],
      postalCode: json['postal_code'],
      state: json['state'],
    );
  }
}

class Card {
  String brand;
  Checks checks;
  String country;
  String displayBrand;
  int expMonth;
  int expYear;
  String fingerprint;
  String funding;
  String? generatedFrom;
  String last4;
  Networks networks;
  ThreeDSecureUsage threeDSecureUsage;
  String? wallet;

  Card({
    required this.brand,
    required this.checks,
    required this.country,
    required this.displayBrand,
    required this.expMonth,
    required this.expYear,
    required this.fingerprint,
    required this.funding,
    required this.generatedFrom,
    required this.last4,
    required this.networks,
    required this.threeDSecureUsage,
    required this.wallet,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      brand: json['brand'],
      checks: Checks.fromJson(json['checks']),
      country: json['country'],
      displayBrand: json['display_brand'],
      expMonth: json['exp_month'],
      expYear: json['exp_year'],
      fingerprint: json['fingerprint'],
      funding: json['funding'],
      generatedFrom: json['generated_from'],
      last4: json['last4'],
      networks: Networks.fromJson(json['networks']),
      threeDSecureUsage:
          ThreeDSecureUsage.fromJson(json['three_d_secure_usage']),
      wallet: json['wallet'],
    );
  }
}

class Checks {
  String? addressLine1Check;
  String? addressPostalCodeCheck;
  String cvcCheck;

  Checks({
    required this.addressLine1Check,
    required this.addressPostalCodeCheck,
    required this.cvcCheck,
  });

  factory Checks.fromJson(Map<String, dynamic> json) {
    return Checks(
      addressLine1Check: json['address_line1_check'],
      addressPostalCodeCheck: json['address_postal_code_check'],
      cvcCheck: json['cvc_check'],
    );
  }
}

class Networks {
  List<String> available;
  String? preferred;

  Networks({
    required this.available,
    required this.preferred,
  });

  factory Networks.fromJson(Map<String, dynamic> json) {
    return Networks(
      available: List<String>.from(json['available']),
      preferred: json['preferred'],
    );
  }
}

class ThreeDSecureUsage {
  bool supported;

  ThreeDSecureUsage({
    required this.supported,
  });

  factory ThreeDSecureUsage.fromJson(Map<String, dynamic> json) {
    return ThreeDSecureUsage(
      supported: json['supported'],
    );
  }
}
