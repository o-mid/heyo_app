//import 'package:get/get.dart';
//import 'package:heyo/app/modules/add_participate/controllers/add_participate_controller.dart';
//import 'package:heyo/app/modules/add_participate/usecase/get_contact_user_use_case.dart';
//import 'package:heyo/app/modules/add_participate/usecase/search_contact_user_use_case.dart';
//import 'package:heyo/app/modules/calls/data/web_rtc_call_repository.dart';
//import 'package:heyo/app/modules/shared/data/providers/database/app_database.dart';
//import 'package:heyo/app/modules/shared/data/providers/database/dao/user_provider.dart';
//import 'package:heyo/app/modules/shared/data/repository/contact_repository.dart';
//import 'package:heyo/app/modules/shared/data/repository/db/cache_repository.dart';

//class AddParticipateBinding extends Bindings {
//  @override
//  void dependencies() {
//    Get.lazyPut<AddParticipateController>(
//      () => AddParticipateController(
//        callRepository: WebRTCCallRepository(
//          callConnectionsHandler: Get.find(),
//        ),
//        getContactUserUseCase: GetContactUserUseCase(
//          contactRepository: ContactRepository(
//            cacheContractor: CacheRepository(
//              userProvider: UserProvider(
//                appDatabaseProvider: Get.find<AppDatabaseProvider>(),
//              ),
//            ),
//          ),
//        ),
//        searchContactUserUseCase: SearchContactUserUseCase(
//          accountInfoRepo: Get.find(),
//          contactRepository: ContactRepository(
//            cacheContractor: CacheRepository(
//              userProvider: UserProvider(
//                appDatabaseProvider: Get.find<AppDatabaseProvider>(),
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
