class Bank {
  final int id;
  final String name;
  final int acctLength;
  final int code;

  const Bank({
    required this.id,
    required this.name,
    required this.acctLength,
    required this.code,
  });
}

const List<Bank> banks = [
  Bank(id: 130, name: 'Abay Bank', acctLength: 16, code: 130),
  Bank(id: 772, name: 'Addis International Bank', acctLength: 15, code: 772),
  Bank(id: 207, name: 'Ahadu Bank', acctLength: 10, code: 207),
  Bank(id: 656, name: 'Awash Bank', acctLength: 14, code: 656),
  Bank(id: 347, name: 'Bank of Abyssinia', acctLength: 8, code: 347),
  Bank(id: 571, name: 'Berhan Bank', acctLength: 13, code: 571),
  Bank(id: 128, name: 'CBEBirr', acctLength: 10, code: 128),
  Bank(id: 946, name: 'Commercial Bank of Ethiopia (CBE)', acctLength: 13, code: 946),
  Bank(id: 880, name: 'Dashen Bank', acctLength: 13, code: 880),
  Bank(id: 1, name: 'Enat Bank', acctLength: 8, code: 1),
  Bank(id: 301, name: 'Global Bank Ethiopia', acctLength: 13, code: 301),
  Bank(id: 534, name: 'Hibret Bank', acctLength: 16, code: 534),
  Bank(id: 315, name: 'Lion International Bank', acctLength: 9, code: 315),
  Bank(id: 266, name: 'M-Pesa', acctLength: 10, code: 266),
  Bank(id: 979, name: 'Nib International Bank', acctLength: 13, code: 979),
  Bank(id: 855, name: 'telebirr', acctLength: 10, code: 855),
  Bank(id: 472, name: 'Wegagen Bank', acctLength: 13, code: 472),
];