import 'package:get/get.dart';

import '../modules/account/views/account_view.dart';
import '../modules/add_contacts/bindings/add_contacts_binding.dart';
import '../modules/add_contacts/views/add_contacts_view.dart';
import '../modules/auth/generatePrivateKeys/bindings/generate_private_keys_binding.dart';
import '../modules/auth/generatePrivateKeys/views/generate_private_keys_view.dart';
import '../modules/auth/pinCode/bindings/pin_code_binding.dart';
import '../modules/auth/pinCode/views/pin_code_view.dart';
import '../modules/auth/sing-up/bindings/sing_up_binding.dart';
import '../modules/auth/sing-up/views/sing_up_view.dart';
import '../modules/calls/home/views/calls_view.dart';
import '../modules/calls/incoming_call/bindings/incoming_call_binding.dart';
import '../modules/calls/incoming_call/views/incoming_call_view.dart';
import '../modules/calls/main/bindings/call_binding.dart';
import '../modules/calls/main/views/call_view.dart';
import '../modules/calls/user_call_history/bindings/user_call_history_binding.dart';
import '../modules/calls/user_call_history/views/user_call_history_view.dart';
import '../modules/contacts/bindings/contacts_binding.dart';
import '../modules/contacts/views/contacts_view.dart';
import '../modules/forward_massages/bindings/forward_massages_binding.dart';
import '../modules/forward_massages/views/forward_massages_view.dart';
import '../modules/gallery_picker/bindings/gallery_picker_binding.dart';
import '../modules/gallery_picker/views/gallery_picker_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/information/shareable_qr_binding.dart';
import '../modules/information/shareable_qr_view.dart';
import '../modules/intro/bindings/intro_binding.dart';
import '../modules/intro/views/intro_view.dart';
import '../modules/media_view/bindings/media_view_binding.dart';
import '../modules/media_view/views/media_view.dart';
import '../modules/messages/bindings/messages_binding.dart';
import '../modules/messages/views/messages_view.dart';
import '../modules/new_call/bindings/new_call_binding.dart';
import '../modules/new_call/views/new_call_view.dart';
import '../modules/new_chat/bindings/new_chat_binding.dart';
import '../modules/new_chat/views/new_chat_view.dart';
import '../modules/search_nearby/bindings/search_nearby_binding.dart';
import '../modules/search_nearby/views/search_nearby_view.dart';
import '../modules/share_files/bindings/share_files_binding.dart';
import '../modules/share_files/views/share_files_view.dart';
import '../modules/share_location/bindings/share_location_binding.dart';
import '../modules/share_location/views/share_location_view.dart';
import '../modules/shared/utils/constants/transitions_constant.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // Todo :
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.INTRO,
      page: () => IntroView(),
      binding: IntroBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.SING_UP,
      page: () => SingUpView(),
      binding: SingUpBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.PIN_CODE,
      page: () => PinCodeView(),
      binding: PinCodeBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.GENERATE_PRIVATE_KEYS,
      page: () => GeneratePrivateKeysView(),
      binding: GeneratePrivateKeysBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.CALLS,
      page: () => CallsView(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => WalletView(),
      binding: WalletBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.SEARCH_NEARBY,
      page: () => SearchNearbyView(),
      binding: SearchNearbyBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => AccountView(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.NEW_CHAT,
      page: () => NewChatView(),
      binding: NewChatBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.MESSAGES,
      page: () => MessagesView(),
      binding: MessagesBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.ADD_CONTACTS,
      page: () => AddContactsView(),
      binding: AddContactsBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.FORWARD_MASSAGES,
      page: () => ForwardMassagesView(),
      binding: ForwardMassagesBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.GALLERY_PICKER,
      page: () => GalleryPickerView(),
      binding: GalleryPickerBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.SHARE_LOCATION,
      page: () => ShareLocationView(),
      binding: ShareLocationBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.SHREABLE_QR,
      page: () => ShareableQrView(),
      binding: ShareableQRBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.USER_CALL_HISTORY,
      page: () => UserCallHistoryView(),
      binding: UserCallHistoryBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.CALL,
      page: () => CallView(),
      binding: CallBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.INCOMING_CALL,
      page: () => IncomingCallView(),
      binding: IncomingCallBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.SHARE_FILES,
      page: () => const ShareFilesView(),
      binding: ShareFilesBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.MEDIA_VIEW,
      page: () => const MediaView(),
      binding: MediaViewBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.CONTACTS,
      page: () => const ContactsView(),
      binding: ContactsBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
    GetPage(
      name: _Paths.NEW_CALL,
      page: () => const NewCallView(),
      binding: NewCallBinding(),
      transition: TRANSITIONS.navigation_generalPageTransition,
      transitionDuration: TRANSITIONS.navigation_generalPageTransitionDurtion,
      curve: TRANSITIONS.navigation_generalPageTransitionCurve,
    ),
  ];
}
