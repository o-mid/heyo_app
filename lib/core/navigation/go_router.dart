// app_router.dart

import 'package:go_router/go_router.dart';
import 'package:heyo/app/modules/account/views/account_view.dart';
import 'package:heyo/app/modules/add_contacts/views/add_contacts_view.dart';
import 'package:heyo/app/modules/auth/generatePrivateKeys/views/generate_private_keys_view.dart';
import 'package:heyo/app/modules/auth/pinCode/views/pin_code_view.dart';
import 'package:heyo/app/modules/auth/sing-up/views/sing_up_view.dart';
import 'package:heyo/app/modules/calls/main/views/call_view.dart';
import 'package:heyo/app/modules/calls/new_call/views/new_call_view.dart';
import 'package:heyo/app/modules/contacts/views/contacts_view.dart';
import 'package:heyo/app/modules/forward_massages/views/forward_massages_view.dart';
import 'package:heyo/app/modules/gallery_picker/views/gallery_picker_view.dart';
import 'package:heyo/app/modules/home/views/home_view.dart';
import 'package:heyo/app/modules/information/shareable_qr_view.dart';
import 'package:heyo/app/modules/intro/views/intro_view.dart';
import 'package:heyo/app/modules/media_view/views/media_view.dart';
import 'package:heyo/app/modules/messages/views/messages_view.dart';
import 'package:heyo/app/modules/new_chat/views/new_chat_view.dart';
import 'package:heyo/app/modules/new_group_chat/views/new_group_chat_view.dart';
import 'package:heyo/app/modules/search_nearby/views/search_nearby_view.dart';
import 'package:heyo/app/modules/share_files/views/share_files_view.dart';
import 'package:heyo/app/modules/share_location/views/share_location_view.dart';
import 'package:heyo/app/modules/splash/views/splash_view.dart';
import 'package:heyo/app/modules/verified_user/views/verified_user_view.dart';
import 'package:heyo/app/modules/wallet/views/wallet_view.dart';
import 'package:heyo/app/modules/wifi_direct/views/wifi_direct_view.dart';
import 'package:heyo/app/modules/wifi_direct_connect/views/wifi_direct_connect_view.dart';
import 'package:heyo/modules/call/presentation/add_participate/add_participate_page.dart';
import 'package:heyo/modules/call/presentation/call_history/call_history_page.dart';
import 'package:heyo/modules/call/presentation/call_history_detail/call_history_detail_page.dart';
import 'package:heyo/modules/call/presentation/incoming_call/incoming_call_page.dart';

part 'route_paths.dart';

final appRouter = GoRouter(
  initialLocation: RoutePaths.SPLASH,
  routes: [
    GoRoute(
      path: RoutePaths.SPLASH,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: RoutePaths.INTRO,
      builder: (context, state) => const IntroView(),
    ),
    GoRoute(
      path: RoutePaths.SING_UP,
      builder: (context, state) => SingUpView(),
    ),
    GoRoute(
      path: RoutePaths.PIN_CODE,
      builder: (context, state) => PinCodeView(),
    ),
    GoRoute(
      path: RoutePaths.GENERATE_PRIVATE_KEYS,
      builder: (context, state) => GeneratePrivateKeysView(),
    ),
    GoRoute(
      path: RoutePaths.CALLS,
      builder: (context, state) => const CallHistoryPage(),
    ),
    GoRoute(
      path: RoutePaths.WALLET,
      builder: (context, state) => WalletView(),
    ),
    GoRoute(
      path: RoutePaths.SEARCH_NEARBY,
      builder: (context, state) => const SearchNearbyView(),
    ),
    GoRoute(
      path: RoutePaths.ACCOUNT,
      builder: (context, state) => const AccountView(),
    ),
    GoRoute(
      path: RoutePaths.HOME,
      builder: (context, state) => HomeView(),
    ),
    GoRoute(
      path: RoutePaths.NEW_CHAT,
      builder: (context, state) => const NewChatView(),
    ),
    GoRoute(
      path: RoutePaths.MESSAGES,
      builder: (context, state) => const MessagesView(),
    ),
    GoRoute(
      path: RoutePaths.ADD_CONTACTS,
      builder: (context, state) => const AddContactsView(),
    ),
    GoRoute(
      path: RoutePaths.FORWARD_MASSAGES,
      builder: (context, state) => ForwardMassagesView(),
    ),
    GoRoute(
      path: RoutePaths.GALLERY_PICKER,
      builder: (context, state) => const GalleryPickerView(),
    ),
    GoRoute(
      path: RoutePaths.SHARE_LOCATION,
      builder: (context, state) => const ShareLocationView(),
    ),
    GoRoute(
      path: RoutePaths.SHAREABLE_QR,
      builder: (context, state) => const ShareableQrView(),
    ),
    GoRoute(
      path: RoutePaths.USER_CALL_HISTORY,
      builder: (context, state) => const CallHistoryDetailPage(),
    ),
    GoRoute(
      path: RoutePaths.CALL,
      builder: (context, state) => const CallView(),
    ),
    GoRoute(
      path: RoutePaths.INCOMING_CALL,
      builder: (context, state) => const IncomingCallPage(),
    ),
    GoRoute(
      path: RoutePaths.SHARE_FILES,
      builder: (context, state) => const ShareFilesView(),
    ),
    GoRoute(
      path: RoutePaths.MEDIA_VIEW,
      builder: (context, state) => const MediaView(),
    ),
    GoRoute(
      path: RoutePaths.CONTACTS,
      builder: (context, state) => const ContactsView(),
    ),
    GoRoute(
      path: RoutePaths.NEW_CALL,
      builder: (context, state) => const NewCallView(),
    ),
    GoRoute(
      path: RoutePaths.WIFI_DIRECT,
      builder: (context, state) => const WifiDirectView(),
    ),
    GoRoute(
      path: RoutePaths.WIFI_DIRECT_CONNECT,
      builder: (context, state) => const WifiDirectConnectView(),
    ),
    GoRoute(
      path: RoutePaths.ADD_PARTICIPATE,
      builder: (context, state) => const AddParticipatePage(),
    ),
    GoRoute(
      path: RoutePaths.VERIFIED_USER,
      builder: (context, state) => const VerifiedUserView(),
    ),
    GoRoute(
      path: RoutePaths.NEW_GROUP_CHAT,
      builder: (context, state) => const NewGroupChatView(),
    ),
  ],
);
