import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone_riverpod/state/posts/typedefs/user_id.dart';

import 'auth_result.dart';

@immutable
class AuthState {
  final AuthResult? result;
  final bool isLoading;
  final UserId? userId;

  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
  });

  const AuthState.unknown()
      : result = null,
        isLoading = false,
        userId = null;

  AuthState copiedWithIsLoading(bool isLoading) => AuthState(
        result: result,
        isLoading: isLoading,
        userId: userId,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          result == other.result &&
          isLoading == other.isLoading &&
          userId == other.userId;

  @override
  int get hashCode => Object.hash(result, isLoading, userId);
}
