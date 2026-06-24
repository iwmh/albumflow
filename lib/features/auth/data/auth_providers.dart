import 'package:albumflow/features/auth/data/auth_repository_impl.dart';
import 'package:albumflow/features/auth/data/secure_token_storage.dart';
import 'package:albumflow/features/auth/data/spotify_auth_service.dart';
import 'package:albumflow/features/auth/domain/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@riverpod
FlutterSecureStorage secureStorage(Ref ref) => const FlutterSecureStorage();

@riverpod
SecureTokenStorage secureTokenStorage(Ref ref) =>
    SecureTokenStorage(ref.watch(secureStorageProvider));

@riverpod
SpotifyAuthService spotifyAuthService(Ref ref) => SpotifyAuthService();

/// 認証リポジトリ。`tokenRepositoryProvider` の override 先でもある。
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
  ref.watch(spotifyAuthServiceProvider),
  ref.watch(secureTokenStorageProvider),
);
