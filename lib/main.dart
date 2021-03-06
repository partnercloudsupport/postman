import 'package:caramel/services.dart';
import 'package:caramel/usecases.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:cloud_functions/cloud_functions.dart' show CloudFunctions;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:flutter/material.dart';
import './src/app.dart';

void main() {
  final analytics = FirebaseAnalytics();
  final auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
  final functions = CloudFunctions.instance;

  final authenticator = FirebaseAuthenticator(
    auth: auth,
    firestore: firestore,
    functions: functions,
  );
  final chatRepository = FirestoreChatRepository(firestore);
  final deviceService = DeviceService();
  final friendCodeRepository = FirestoreFriendCodeRepository(firestore);
  final friendCodeScanner = FriendCodeScanner();
  final notificationManager = DummyNotificationManager();
  final userRepository = FirebaseUserRepository(
    firestore: firestore,
    functions: functions,
  );

  final authenticate = AuthenticateUsecase(
    authenticator: authenticator,
    userRepository: userRepository,
  );
  final listChat = ChatListUsecase(chatRepository: chatRepository);
  final participateChat = ChatParticipateUsecase(
    chatRepository: chatRepository,
  );
  final getFriendCode = FriendCodeGetUsecase(
    friendCodeRepository: friendCodeRepository,
  );
  final createFriendship = FriendshipCreateUsecase(
    friendCodeScanner: friendCodeScanner,
    userRepository: userRepository,
  );
  final listFriend = FriendListUsecase(userRepository: userRepository);

  runApp(
    App(
      analytics: analytics,
      deviceService: deviceService,
      notificationManager: notificationManager,
      userRepository: userRepository,
      authenticate: authenticate,
      listChat: listChat,
      participateChat: participateChat,
      getFriendCode: getFriendCode,
      createFriendship: createFriendship,
      listFriend: listFriend,
    ),
  );
}
