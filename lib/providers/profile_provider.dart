import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class ProfileNotifier extends StateNotifier<AppUser?> {
  ProfileNotifier() : super(null);

  void setUser(AppUser user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  void updatePhoto(String url) {
    if (state == null) return;

    state = AppUser(
      uid: state!.uid,
      email: state!.email,
      displayName: state!.displayName,
      photoUrl: url,
      relationshipId: state!.relationshipId,
      partnerId: state!.partnerId,
      liveWindowEnabled: state!.liveWindowEnabled,
      lastSeen: state!.lastSeen,
    );
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AppUser?>(
  (ref) => ProfileNotifier(),
);
