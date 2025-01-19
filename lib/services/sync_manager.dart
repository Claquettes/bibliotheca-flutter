import 'dart:async';
import 'sync_service.dart';

class SyncManager {
  static Timer? syncTimer;
  static final SyncService syncService = SyncService();

  static void startAutoSync() {
    syncTimer = Timer.periodic(Duration(minutes: 15), (timer) {
      syncService.syncCategoriesWithAPI();
      syncService.pushCategoriesToAPI();
    });
  }

  static void stopAutoSync() {
    syncTimer?.cancel();
  }
}
