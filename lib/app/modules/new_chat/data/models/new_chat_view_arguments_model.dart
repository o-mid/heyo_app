class NewchatArgumentsModel {
  // pass true if we want to navigate to new chat screen and
  //serach for users using QRCode,

  final bool openQrScaner;
  final bool openInviteBottomSheet;

  NewchatArgumentsModel({
    this.openQrScaner = false,
    this.openInviteBottomSheet = false,
  });
}
