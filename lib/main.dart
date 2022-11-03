import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:developer' as devtools show log;
import 'package:instagram_clone_riverpod/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_riverpod/state/auth/providers/is_logged_in_provider.dart';
import 'package:instagram_clone_riverpod/views/components/loading/loading_screen.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      home: Consumer(builder: (context, ref, child) {
        final isLoggedIn = ref.watch(isLoggedInProvider);
        if (isLoggedIn) {
          return const MainView();
        }
        return const LoginView();
      }),
    );
  }
}

// When you are already logged in
class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Main View"),
      ),
      body: Consumer(
        // GOOD POINT WITH CONTEXT'S WIDTH AND HEIGHT
        builder: (_, ref, child) {
          return TextButton(
            onPressed: ()  {
              // LoadingScreen.instance().show(context: context,text: "Hello World");
              ref.read(authStateProvider.notifier).logOut();

            },

            child: const Text("Log Out"),
          );
        },
      ),
    );
  }
}

class LoginView extends ConsumerWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login View"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: ()=>ref.read(authStateProvider.notifier).loginWithGoogle(),
            child: const Text(
              "Sign In with Google",
            ),
          ),
          TextButton(
            onPressed: () => ref.read(authStateProvider.notifier).loginWithFacebook(),
            child: const Text(
              "Sign In with Facebook",
            ),
          ),
        ],
      ),
    );

  }
}
