import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:servicestack/client.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:servicestack/web_client.dart' if (dart.library.io) 'package:servicestack/client.dart';

import 'dtos.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(
        client: ClientFactory.createWith(ClientOptions(baseUrl: 'https://dev.servicestack.com:5001', ignoreCert: kDebugMode))),
    child: MyApp(),
  ));
}

//https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple
class AppState extends ChangeNotifier {
  SharedPreferences prefs;
  IServiceClient client;
  AuthenticateResponse auth;
  bool hasInit = false;

  bool get isAuthenticated => auth != null;

  AppState({this.client});

  Future<AppState> init() async {
    prefs = await SharedPreferences.getInstance();
    var json = prefs.getString('auth');
    auth = json != null ? AuthenticateResponse.fromJson(jsonDecode(json)) : null;

    initClientAuth(client, auth);

    if (auth != null && !await checkIsAuthenticated(client)) {
      auth = client.bearerToken = client.refreshToken = null;
      prefs.remove('auth');
    }
    hasInit = true;
    return this;
  }

  void signOut() => saveAuth(null);

  void saveAuth(AuthenticateResponse response) {
    auth = response;
    if (auth != null) {
      var json = jsonEncode(auth.toJson());
      prefs.setString('auth', json);
    } else {
      prefs.remove('auth');
    }
    initClientAuth(client, auth);
    notifyListeners();
  }
}

void initClientAuth(IServiceClient client, AuthenticateResponse auth) {
  client.bearerToken = auth?.bearerToken;
  client.refreshToken = auth?.refreshToken;
  if (auth == null) {
    (client as JsonServiceClient)?.cookies?.clear();
  }
}

Future<bool> checkIsAuthenticated(IServiceClient client) async {
  try {
    var response = await client.post(Authenticate());
    return true;
  } catch (e) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AppState>(context, listen: false).init(),
      builder: (context, state) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = '';

  Future<void> _callService() async {
    try {
      var client = Provider.of<AppState>(context, listen: false).client;
      var response = await client.get(HelloSecure()..name = "Flutter");
      setState(() {
        result = response.result;
      });
    } on WebServiceException catch (e) {
      setState(() {
        result = "${e.statusCode}: ${e.message}";
      });
    }
  }

  handleSignIn(AppState state) async {
    result = '';
    try {
      var clientID = "net.servicestack.myappid";
      var redirectURL = "https://dev.servicestack.com:5001/auth/apple?ReturnUrl=android:com.servicestack.auth";
      var scopes = [ AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName ];
      final credentials = Platform.isAndroid
        ? await SignInWithApple.getAppleIDCredential(scopes: scopes,
            webAuthenticationOptions: WebAuthenticationOptions(clientId:clientID, redirectUri:Uri.parse(redirectURL)))
        : await SignInWithApple.getAppleIDCredential(scopes: scopes);

      // Sign In with Apple success!
      print(credentials);
      var idToken = credentials.identityToken;

      // Authenticate with server using idToken & convert into stateless JWT Cookie + persistent auth token
      var response = await state.client.post(Authenticate()
        ..provider = 'apple'
        ..accessToken = idToken, args: {
          'authorizationCode': credentials.authorizationCode,
          'givenName': credentials.givenName,
          'familyName': credentials.familyName,
        }); // JwtAuthProvider.UseTokenCookie returns JWT in ss-tok

      state.saveAuth(response);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    //var auth = context.select<AppState,bool>((state) => state.isAuthenticated);

    return Consumer<AppState>(builder: (context, state, child) {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('HTTP API Example'),
              Text('$result', style: Theme.of(context).textTheme.headline4),
              if (state.hasInit)
                state.isAuthenticated
                    ? FlatButton(onPressed: state.signOut, child: Text('Sign Out'))
                    : SignInWithAppleButton(onPressed: () async {
                  await handleSignIn(state);
                })
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _callService,
          tooltip: 'HTTP API Example',
          child: Icon(Icons.play_arrow),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }
}
