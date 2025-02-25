// ignore_for_file: non_constant_identifier_names

class SubBankAccountModal {
  String business_name;
  String account_number;
  double percentage_charge;
  String settlement_bank;
  String currency;
  int bank;
  int integration;
  String domain;
  String subaccount_code;
  bool is_verified;
  String settlement_schedule;
  bool active;
  bool migrate;
  int id;
  String createdAt;
  String updatedAt;

  SubBankAccountModal({
    required this.business_name,
    required this.account_number,
    required this.percentage_charge,
    required this.settlement_bank,
    required this.currency,
    required this.bank,
    required this.integration,
    required this.domain,
    required this.subaccount_code,
    required this.is_verified,
    required this.settlement_schedule,
    required this.active,
    required this.migrate,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubBankAccountModal.fromJson(Map data) {
    return SubBankAccountModal(
      business_name: data['business_name'],
      account_number: data['account_number'],
      percentage_charge: double.parse('${data['percentage_charge']}'),
      settlement_bank: data['settlement_bank'],
      currency: data['currency'],
      bank: data['bank'],
      integration: data['integration'],
      domain: data['domain'],
      subaccount_code: data['subaccount_code'],
      is_verified: data['is_verified'],
      settlement_schedule: data['settlement_schedule'],
      active: data['active'],
      migrate: data['migrate'],
      id: data['id'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
}
