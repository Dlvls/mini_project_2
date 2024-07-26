import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/bloc/profile/profile_bloc.dart';
import '../data/bloc/profile/profile_event.dart';
import '../data/bloc/profile/profile_state.dart';
import '../data/services/profile/profile_repository.dart';
import '../resources/colors.dart';
import '../resources/styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(ProfileRepository())..add(LoadProfileEvent(1)),
      child: Scaffold(
        backgroundColor: secondaryColor, // Background color for Scaffold
        appBar: AppBar(
          backgroundColor: secondaryColor, // Background color for AppBar
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            color: primaryText,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Profile',
            style: Styles.appbarText,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Under development",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              icon: const Icon(Icons.edit),
              color: primaryText,
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoadedState) {
              final profile = state.user;
              return Container(
                color: secondaryColor, // Background color for the body content
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            "assets/images/profile_image.jpg",
                            fit: BoxFit
                                .cover, // Use BoxFit.cover to ensure the image fills the circle
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${profile.name.firstname} ${profile.name.lastname}",
                                style: Styles.title,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                profile.username,
                                style: Styles.subtitle
                                    .copyWith(color: secondaryText),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  const Icon(Icons.location_on),
                                  const SizedBox(width: 4.0),
                                  Text(profile.address.city,
                                      style: Styles.title.copyWith(
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    Row(
                      children: [
                        const Icon(Icons.email),
                        const SizedBox(width: 8.0),
                        Text(profile.email, style: Styles.subtitle),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const Divider(),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.phone),
                        const SizedBox(width: 8.0),
                        Text(
                          profile.phone,
                          style: Styles.subtitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const Divider(),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.home),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                              '${profile.address.street} ${profile.address.number}, ${profile.address.zipcode}',
                              style: Styles.subtitle),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              // Perform logout operation
                              final prefs = SharedPreferences.getInstance();
                              prefs.then((pref) {
                                pref.setBool('isLoggedIn', false);
                                context.go('/login'); // Navigate to login page
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              minimumSize: const Size(double.infinity, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Logout',
                              style: Styles.title.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileErrorState) {
              return Center(child: Text(state.error));
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }
}
