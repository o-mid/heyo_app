import 'package:get/get.dart';
import 'package:heyo/app/modules/auth/pinCode/bindings/pin_code_binding.dart';
import 'package:heyo/modules/features/call_history/presentation/pages/call_history_detail_page.dart';
import 'package:heyo/modules/features/call_history/di/call_history_detail_binding.dart';
import 'package:heyo/modules/features/call_history/presentation/pages/call_history_page.dart';
import 'package:heyo/modules/features/contact/presentation/pages/contact_page.dart';

import '../modules/account/views/account_view.dart';
import '../../modules/features/contact/di/add_contact_binding.dart';
import '../../modules/features/contact/presentation/pages/add_contact_page.dart';
import '../modules/auth/generatePrivateKeys/bindings/generate_private_keys_binding.dart';
import '../modules/auth/generatePrivateKeys/views/generate_private_keys_view.dart';
import '../modules/auth/pinCode/views/pin_code_view.dart';
import '../modules/auth/sing-up/bindings/sing_up_binding.dart';
import '../modules/auth/sing-up/views/sing_up_view.dart';
import '../../modules/call/presentation/add_participate/di/add_participate_binding.dart';
import '../../modules/call/presentation/add_participate/add_participate_page.dart';
import '../../modules/call/presentation/incoming_call/di/incoming_call_binding.dart';
import '../../modules/call/presentation/incoming_call/incoming_call_page.dart';
import '../modules/calls/main/bindings/call_binding.dart';
import '../modules/calls/main/views/call_view.dart';
import '../modules/calls/new_call/bindings/new_call_binding.dart';
import '../modules/calls/new_call/views/new_call_view.dart';
import '../../modules/features/contact/di/contact_binding.dart';
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
import '../modules/new_chat/bindings/new_chat_binding.dart';
import '../modules/new_chat/views/new_chat_view.dart';
import '../modules/new_group_chat/bindings/new_group_chat_binding.dart';
import '../modules/new_group_chat/views/new_group_chat_view.dart';
import '../modules/search_nearby/bindings/search_nearby_binding.dart';
import '../modules/search_nearby/views/search_nearby_view.dart';
import '../modules/share_files/bindings/share_files_binding.dart';
import '../modules/share_files/views/share_files_view.dart';
import '../modules/share_location/bindings/share_location_binding.dart';
import '../modules/share_location/views/share_location_view.dart';
import '../modules/shared/utils/constants/transitions_constant.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/verified_user/binding/verified_user_binding.dart';
import '../modules/verified_user/views/verified_user_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';
import '../modules/wifi_direct/bindings/wifi_direct_binding.dart';
import '../modules/wifi_direct/views/wifi_direct_view.dart';
import '../modules/wifi_direct_connect/bindings/wifi_direct_connect_binding.dart';
import '../modules/wifi_direct_connect/views/wifi_direct_connect_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // Todo :
  static const INITIAL = Routes.SPLASH;

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
      page: () => CallHistoryPage(),
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
      page: () => AddContactsPage(),
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
      page: () => CallHistoryDetailPage(),
      binding: CallHistoryDetailBinding(),
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
      page: () => IncomingCallPage(),
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
      page: () => const ContactPage(),
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
    GetPage(
      name: _Paths.WIFI_DIRECT,
      page: () => const WifiDirectView(),
      binding: WifiDirectBinding(),
    ),
    GetPage(
      name: _Paths.WIFI_DIRECT_CONNECT,
      page: () => const WifiDirectConnectView(),
      binding: WifiDirectConnectBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PARTICIPATE,
      page: () => const AddParticipatePage(),
      binding: AddParticipateBinding(),
    ),
    GetPage(
      name: _Paths.VERIFIED_USER,
      page: () => const VerifiedUserView(),
      binding: VerifiedUserBinding(),
    ),
    GetPage(
      name: _Paths.NEW_GROUP_CHAT,
      page: () => const NewGroupChatView(),
      binding: NewGroupChatBinding(),
    ),
  ];
}
