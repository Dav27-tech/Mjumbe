import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mjumbe/features/auth/domain/repositories/auth_repository_impl.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late AuthRepositoryImpl repository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    repository = AuthRepositoryImpl(firebaseAuth: mockFirebaseAuth);
  });

  group('AuthRepositoryImpl', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    test('signIn should return a UserEntity when successful', () async {
      // arrange
      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn(tEmail);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => mockUserCredential);

      // act
      final result =
          await repository.signIn(email: tEmail, password: tPassword);

      // assert
      expect(result.user?.email, tEmail);
      expect(result.failure, isNull);
    });

    test('signUp should return a UserEntity when successful', () async {
      // arrange
      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn(tEmail);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => mockUserCredential);

      // act
      final result =
          await repository.signUp(email: tEmail, password: tPassword);

      // assert
      expect(result.user?.uid, '123');
      expect(result.failure, isNull);
    });

    test('signOut should call firebaseAuth.signOut', () async {
      // arrange
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

      // act
      final result = await repository.signOut();

      // assert
      verify(() => mockFirebaseAuth.signOut()).called(1);
      expect(result.failure, isNull);
    });

    test('getOAuth2AccessToken should return token from currentUser', () async {
      // arrange
      when(() => mockUser.getIdToken(any()))
          .thenAnswer((_) async => 'fake-token');
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      // act
      final result = await repository.getOAuth2AccessToken();

      // assert
      expect(result, 'fake-token');
      verify(() => mockUser.getIdToken(false)).called(1);
    });

    test('getOAuth2AccessToken with forceRefresh should request fresh token',
        () async {
      when(() => mockUser.getIdToken(true))
          .thenAnswer((_) async => 'fresh-token');
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final result = await repository.getOAuth2AccessToken(forceRefresh: true);

      expect(result, 'fresh-token');
      verify(() => mockUser.getIdToken(true)).called(1);
    });
  });
}
