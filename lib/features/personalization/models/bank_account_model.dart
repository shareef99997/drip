class BankAccountModel {
  final String id;
  final String accountNumber;
  final String accountHolderName;
  final String bankName;
  final String branchName;
  final String ifscCode;

  BankAccountModel({
    required this.id,
    required this.accountNumber,
    required this.accountHolderName,
    required this.bankName,
    required this.branchName,
    required this.ifscCode,
  });

  @override
  String toString() {
    return '$accountHolderName - $bankName ($branchName)\nAccount: $accountNumber\nIFSC: $ifscCode';
  }
}
