import 'package:heyo/app/modules/shared/data/providers/events/send_event_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SendEventProviderImpl extends SendEventProvider {
  @override
  Future<void> sendErrorEvent(String name, Map<String,dynamic> data) async {
    await Sentry.captureEvent(
      SentryEvent(
        message: SentryMessage('$name : ${data}'),
        level: SentryLevel.error,
      ),
    );
  }

  @override
  Future<void> sendInfoEvent(String name, Map<String,dynamic> data) async {
    await Sentry.captureEvent(
      SentryEvent(
        message: SentryMessage('$name : ${data}'),
        level: SentryLevel.info,
      ),
    );
  }
}
