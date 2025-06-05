import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

final supabaseClientProvider = Provider((ref) => Supabase.instance.client);
final supabaseAuthProvider = Provider((ref) => Supabase.instance.client.auth);
final supabaseStorageProvider =
    Provider((ref) => Supabase.instance.client.storage);
final googleSignInProvider = Provider((ref) => GoogleSignIn());
final facebookSignInProvider = Provider((ref) => FacebookAuth.instance);
