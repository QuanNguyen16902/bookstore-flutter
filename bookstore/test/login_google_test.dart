// import 'package:flutter_test/flutter_test.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:mockito/mockito.dart';
// import 'package:bookstore/services/auth_service.dart';

// class MockGoogleSignIn extends Mock implements GoogleSignIn {}

// class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// void main() {
//   group('Google Sign-In', () {
//     MockGoogleSignIn mockGoogleSignIn;
//     MockFirebaseAuth mockFirebaseAuth;
//     AuthService authService;

//     setUp(() {
//       mockGoogleSignIn = MockGoogleSignIn();
//       mockFirebaseAuth = MockFirebaseAuth();
//       authService = AuthService(
//         firebaseAuth: mockFirebaseAuth,
//         googleSignIn: mockGoogleSignIn,
//       );
//     });

//     test('successful sign-in', () async {
//       // Mock the GoogleSignInAccount and GoogleSignInAuthentication
//       final googleSignInAccount = MockGoogleSignInAccount();
//       final googleSignInAuthentication = MockGoogleSignInAuthentication();

//       when(mockGoogleSignIn.signIn()).thenAnswer((_) async => googleSignInAccount);
//       when(googleSignInAccount.authentication).thenAnswer((_) async => googleSignInAuthentication);

//       when(googleSignInAuthentication.idToken).thenReturn('mock_id_token');
//       when(googleSignInAuthentication.accessToken).thenReturn('mock_access_token');

//       final userCredential = MockUserCredential();
//       when(mockFirebaseAuth.signInWithCredential(any)).thenAnswer((_) async => userCredential);

//       final result = await authService.signInWithGoogle();

//       expect(result, userCredential);
//       verify(mockGoogleSignIn.signIn()).called(1);
//       verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
//     });

//     test('failed sign-in', () async {
//       when(mockGoogleSignIn.signIn()).thenThrow(Exception('Google sign-in failed'));

//       final result = await authService.signInWithGoogle();

//       expect(result, isNull);
//       verify(mockGoogleSignIn.signIn()).called(1);
//       verifyNever(mockFirebaseAuth.signInWithCredential(any));
//     });
//   });
// }
