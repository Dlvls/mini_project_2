import 'package:flutter_test/flutter_test.dart';
import 'package:mini_project_2/data/models/profile/profile_model.dart';
import 'package:mini_project_2/data/services/profile/profile_repository.dart';

void main() {
  group('ProfileRepository Integration Test', () {
    final profileRepository = ProfileRepository();

    test('fetches profile from the network', () async {
      try {
        final profile = await profileRepository.getProfile(1);
        expect(profile, isA<ProfileModel>());
        expect(profile.id, 1);
        expect(profile.email, isNotNull);
        expect(profile.username, isNotNull);
        print(
            'Profile fetched successfully: ${profile.email}, ${profile.username}');
      } catch (e) {
        fail('Failed to fetch profile: $e');
      }
    });
  });
}
