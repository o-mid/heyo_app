class NewChatArgumentsModel {
  // pass true if we want to navigate to new chat screen and
  //search for users using QRCode,

  final bool openQrScanner;
  final bool openInviteBottomSheet;

  NewChatArgumentsModel({
    this.openQrScanner = false,
    this.openInviteBottomSheet = false,
  });
}
