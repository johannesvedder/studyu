// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:sentry/sentry.dart';

class Analytics {
  static Logger logger = Logger('');

  static late StreamSubscription<LogRecord> onLog;

  static void init() {
    logger.level = Level.ALL;
    onLog = logger.onRecord.listen((record) {
      print(record);
    });
  }

  static void dispose() {
    onLog.cancel();
  }

  static Future<void> captureEvent(
    dynamic event, {
    StackTrace? stackTrace,
  }) async {
    SentryEvent sentryEvent;
    if (event is! SentryEvent) {
      sentryEvent = SentryEvent(throwable: event);
    } else {
      sentryEvent = event;
    }
    await Sentry.captureEvent(
      sentryEvent,
      stackTrace: stackTrace,
    );
  }

  static Future<void> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }

  static Future<void> captureMessage(String? message) async {
    await Sentry.captureMessage(message);
  }

  static void addBreadcrumb({required String message, required String category}) {
    print("[Breadcrumb] $category: $message");
    Sentry.addBreadcrumb(Breadcrumb(message: message, category: category));
  }
}