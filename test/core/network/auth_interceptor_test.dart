import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mjumbe/core/network/auth_interceptor.dart';
import 'package:mjumbe/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthInterceptor interceptor;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    interceptor = AuthInterceptor(mockAuthRepository);
  });

  test('calls signOut when refresh token fails on 401', () async {
    // arrange: simulate refresh failing
    when(() => mockAuthRepository.getOAuth2AccessToken(forceRefresh: true))
        .thenAnswer((_) async => null);
    when(() => mockAuthRepository.signOut()).thenAnswer((_) async => (failure: null, data: null));

    final options = RequestOptions(path: '/test');
    final response = Response(requestOptions: options, statusCode: 401);
    final dioError = DioException(requestOptions: options, response: response);

    final handler = ErrorInterceptorHandler();

    // act
    await interceptor.onError(dioError, handler);

    // assert
    verify(() => mockAuthRepository.getOAuth2AccessToken(forceRefresh: true)).called(1);
    verify(() => mockAuthRepository.signOut()).called(1);
  });
}
