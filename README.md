# Sign In with Apple

ServiceStack Sign In with Apple Integration Examples

![](https://raw.githubusercontent.com/ServiceStack/docs/master/docs/images/dev/web-signin-with-apple-login.png)

### Sign In with Apple Requirements

 - Membership **Team ID** from https://developer.apple.com/account/#/membership/
 - Create & configure **App ID** from https://developer.apple.com/account/resources/identifiers/list
 - Use **App ID** to create & configure **Service ID** from https://developer.apple.com/account/resources/identifiers/list/serviceId
 - Use **App ID** to create & configure **Private Key** from https://developer.apple.com/account/resources/authkeys/list

#### App Requirements Walkthrough

Okta has a [good walkthrough explaining Sign In with Apple](https://developer.okta.com/blog/2019/06/04/what-the-heck-is-sign-in-with-apple) and steps required to create the above resources.

Note: Service ID must be configured with non-localhost trusted domain and HTTPS callback URL, for development you can use:
 - Domain: `dev.servicestack.com`
 - Callback URL: `https://dev.servicestack.com:5001/auth/apple` 

See docs on [Configure localhost development dev certificate](https://docs.servicestack.net/netcore-localhost-cert) for instructions & info for being able to use a single `local.servicestack.com` or `dev.servicestack.com` local DNS names to support local development of all platforms.

#### Apple Services ID configuration

If you also need to support Android you'll also need to register the `https://dev.servicestack.com:5001/auth/apple?ReturnUrl=android:com.servicestack.auth` URL will as a valid Callback URL in your Apple **Services ID** configuration.

## Getting Started

As the elliptic curve algorithms required to integrate with Sign In with Apple requires .NET Core 3 APIs the `AppleAuthProvider` is implemented in the **ServiceStack.Extensions** NuGet Package.

### Create project with preferred Auth Configuration

A quick way to can create a working project from scratch with your preferred configuration using the [mix tool](https://docs.servicestack.net/mix-tool), e.g: 

    $ md web && cd web
    $ x mix init auth-ext auth-db sqlite

This creates an empty project, with Auth Enabled, adds the **ServiceStack.Extensions** NuGet package, registers OrmLite, SQLite and the `OrmLiteAuthRepository`.

Copy your Apple **Private Key** to your Apps **Content Folder** then configure your OAuth providers in **appsettings.json**:

```json
{
  "oauth.apple.RedirectUrl": "https://dev.servicestack.com:5001/",
  "oauth.apple.CallbackUrl": "https://dev.servicestack.com:5001/auth/apple",
  "oauth.apple.TeamId": "{Team ID}",
  "oauth.apple.ClientId": "{Service ID}",
  "oauth.apple.BundleId": "{Bundle ID}",
  "oauth.apple.KeyId": "{Private KeyId}",
  "oauth.apple.KeyPath": "AuthKey_{Private KeyId}.p8",
  "jwt.AuthKeyBase64": "{Base64 JWT Auth Key}"
}
```

> See JWT docs for how to [Generate a new Auth Key](https://docs.servicestack.net/jwt-authprovider#generate-new-auth-key)

When needing to support Mobile or Desktop Apps using OAuth Providers like Sign In with Apple, we recommend using it in combination with the [JWT Auth Provider](https://docs.servicestack.net/jwt-authprovider) with `UseTokenCookie` enabled so the Authorization is returned in a stateless JWT Token that can be persisted for optimal Authentication across App restarts, e.g:

```csharp
Plugins.Add(new AuthFeature(() => new CustomUserSession(),
    new IAuthProvider[] {
        new JwtAuthProvider(AppSettings) {
            UseTokenCookie = true,
        },
        new AppleAuthProvider(AppSettings)
            .Use(AppleAuthFeature.FlutterSignInWithApple), 
    }));
```

### Clone working Client & Server Project 

For a working example you can **clone** or **fork** this repo or alternatively download the latest master `.zip` with:

    $ x download NetCoreApps/AppleSignIn

Then after updating **appsettings.json** with your iOS App's configuration, copying your Private Key into the `web` Content Folder you're all set to run your App:

    $ dotnet run

#### Android Support

To support Android we recommend using `dev.servicestack.com` which resolves to the `10.0.2.2` special IP in the Android Emulator that maps to `127.0.0.1` on your Host OS. To also be able to use it during development you'll need to add an entry in your OS's `hosts` file
(e.g. `%SystemRoot%\System32\drivers\etc\hosts` for Windows or `/system/etc/hosts` on macOS/Linux):

    127.0.0.1       dev.servicestack.com

If you don't need to support android you can use `local.servicestack.com` instead which resolves to `127.0.0.1`, please see [configuring localhost development dev certificate](https://docs.servicestack.net/netcore-localhost-cert) for more info.

Then you can view your App using the non-localhost domain name:

    https://dev.servicestack.com:5001/

You can then use the [Embedded Login Page](https://docs.servicestack.net/authentication-and-authorization#embedded-login-page-fallback) which renders the Sign In button for each of the registered OAuth providers in your `AuthFeature`:

 - https://dev.servicestack.com:5001/login

Clicking on **Sign in with Apple** button should let you Sign In with Apple. After successfully signing in you can view the `AllUsersInfo` Service to view a dump of all User Sessions & User Auth Info stored in the registered RDBMS:

 - https://dev.servicestack.com:5001/users

## Flutter iOS & Android App

A reference client Flutter iOS & Android App showcasing integration with Sign In with Apple is available at [/flutter/auth](https://github.com/NetCoreApps/AppleSignIn/tree/master/flutter/auth).

![](https://raw.githubusercontent.com/ServiceStack/docs/master/docs/images/dev/android-flutter-auth.png)

The first task the App does is to create an instance of the `IServiceClient` it should use using the recommended `ClientFactory` API which in combination with the conditional import below returns the appropriate configured Service Client implementation for the platform it's running on, for iOS & Android it uses the native `JsonServiceClient`:

```dart
import 'package:servicestack/web_client.dart' if (dart.library.io) 'package:servicestack/client.dart';
//...

AppState(client: kDebugMode
  ? ClientFactory.createWith(ClientOptions(baseUrl:'https://dev.servicestack.com:5001', ignoreCert:true))
  : ClientFactory.create("https://prod.app"))
```

Using a constant like `kDebugMode` ensures that create Service Clients that ignore SSL Certificate errors are stripped from production builds. 

### sign_in_with_apple package

To support both iOS and Android we're utilizing the [sign_in_with_apple](https://pub.dev/packages/sign_in_with_apple) `SignInWithAppleButton` which takes care of invoking iOS's native Sign In with Apple behavior as well as enabling support for Android by wrapping an OAuth Web Flow in a WebView. Both approaches, if successful will result in an Authenticated IdentityToken which you can use to Authenticate with your ServiceStack instance to establish an Authenticated session.

The `SignInWithAppleButton` functions as a normal button which is placed in your Widgets `build()` method where you want the UI Button to appear, in this case it'll render the **Sign in with Apple** button if the user is not Authenticated otherwise it renders a **Sign Out** `FlatButton`:

```dart
state.isAuthenticated
  ? FlatButton(onPressed: state.signOut, child: Text('Sign Out'))
  : SignInWithAppleButton(onPressed: () async { await handleSignIn(state); })
```

When either is pressed it invokes its `onPressed` event where the Apple Sign in functionality is initiated,
within the `handleSignIn` implementation which reflects the behavior of the different platforms with Android 
using the OAuth Web Flow to authenticate with its ReturnUrl needing the Android's App Id that it should redirect to.

The native integration in iOS is more streamlined with iOS handling the Auth flow with Apple's servers:

```dart
var clientID = "net.servicestack.myappid";
var redirect = "https://dev.servicestack.com:5001/auth/apple?ReturnUrl=android:com.servicestack.auth";
var scopes = [ AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName ];
final credentials = Platform.isAndroid
  ? await SignInWithApple.getAppleIDCredential(scopes:scopes,
      webAuthenticationOptions:WebAuthenticationOptions(clientId:clientID,redirectUri:Uri.parse(redirect)))
  : await SignInWithApple.getAppleIDCredential(scopes:scopes);
```

### New User Registration

When a user signs into your App the first time they'll be presented with the option on what name they want to use and whether or not they want to provide their own email or use Apple's hidden email forwarding service:

![](https://raw.githubusercontent.com/ServiceStack/docs/master/docs/images/dev/ios-flutter-sign-in-with-apple-new-user.png)

Subsequent re-authentication attempts in iOS are more seamless & effortless for users whilst Android users will still need to go through the OAuth web flow:

![](https://raw.githubusercontent.com/ServiceStack/docs/master/docs/images/dev/android-flutter-auth-request.png)

If Sign in is successful it will return the identity token which we can use to Authenticate against our remote ServiceStack instance. Importantly Apple only returns the Users name on its initial sign in which we'll
need to include in our `Authenticate` request in order for it to be used when creating the new user account.
The same code can also be used to re-authenticate existing users:

```dart
// Sign in with Apple success!
var idToken = credentials.identityToken;

// Authenticate with server using idToken & convert into stateless JWT Cookie + persistent auth token
var response = await state.client.post(Authenticate()
    ..provider = 'apple'
    ..accessToken = idToken, args: {
        'authorizationCode': credentials.authorizationCode,
        'givenName': credentials.givenName,
        'familyName': credentials.familyName,
    }); // JwtAuthProvider.UseTokenCookie returns session as JWT

state.saveAuth(response);
```

### Persistent Authenticated Sessions

We recommend using JWT to store authenticated sessions as it allows using a single approach to support multiple OAuth providers, inc. Username/Password Credentials Auth if you want your App to support it, it's also the fastest & most resilient Auth Provider which requires no I/O to validate & no server state as it's all encapsulated within the stateless client JWT token.

As all DTOs are JSON Serializable, the easiest way to persist Authentication is to save the `AuthenticateResponse` 
(which contains both JWT Bearer & Refresh Tokens) in Flutter's `SharedPreferences` abstraction which has implementations 
available in all its supported platforms. 

Populating a Service Client with `bearerToken` and `refreshToken` enables it to make authenticated requests which is 
done on successful Sign in requests and when the App is initialized which is also what allows for persistent authentication across App restarts. 

```dart
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
    client.clearCookies();
  }
}

Future<bool> checkIsAuthenticated(IServiceClient client) async {
  try {
    await client.post(Authenticate());
    return true;
  } catch (e) {
    return false;
  }
}
```

When signing out we also want to remove its cookies to clear its `ss-tok` authenticated JWT Cookie inc. any other user identifying cookies.

The call to `notifyListeners()` is part of Flutter's `ChangeNotifier` 
[Simple app state management](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple) solution which notifies widgets using it of state changes, triggering re-rendering of its UI.

### Authenticated API Requests

To test Authentication the App makes a call to `HelloSecure` Secured C# ServiceStack Service that validates Auth only
access using the `[ValidateIsAuthenticated]` [declarative validation attribute](https://docs.servicestack.net/declarative-validation):

```csharp
[ValidateIsAuthenticated]
[Route("/hello/secure")]
[Route("/hello/secure/{Name}")]
public class HelloSecure : IReturn<HelloResponse>
{
    public string Name { get; set; }
}

public class HelloResponse
{
    public string Result { get; set; }
}

public class MyServices : Service
{
    public object Any(HelloSecure request) => 
        new HelloResponse { Result = $"Secure {request.Name}!" };
}
```

Which uses the Dart client DTOs generated using the [Dart ServiceStack Reference](https://docs.servicestack.net/dart-add-servicestack-reference) feature to perform its Typed API Request:

```dart
  floatingActionButton: FloatingActionButton(
    onPressed: _callService,
    tooltip: 'HTTP API Example',
    child: Icon(Icons.play_arrow),
  ), // This trailing comma makes auto-formatting nicer for build methods.

//...

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
```

Which if authenticated will update the UI with API Response for both iOS:

![](https://raw.githubusercontent.com/ServiceStack/docs/master/docs/images/dev/ios-flutter-auth-request.jpeg)

and Android:

![](https://raw.githubusercontent.com/ServiceStack/docs/master/docs/images/dev/android-flutter-secure.png)


Or fail with an `Unauthorized: Not Authenticated` error if the user is not Signed in.

### Resetting App Sign in

As the Sign in behavior is different for new & existing users you may need to find yourself needing to retest the new user workflow which you can do by removing your existing relationship to your App by signing into your Apple Id:

  - [appleid.apple.com](https://appleid.apple.com)

Then under **Security** click on **Manage apps & websites...**

![](https://raw.githubusercontent.com/ServiceStack/docs/master/docs/images/dev/appleid-manage-signin.png)

Which will let you delete your existing user id and relationship with existing Apps you've signed into:

![](https://raw.githubusercontent.com/ServiceStack/docs/master/docs/images/dev/appleid-reset-signin.png)

Now next time you Sign in to your App it will behave as an initial new User request complete with a new unique user id.

### Flutter Android sign_in_with_apple requirements

It's already configured in this project, but to be able to use [sign_in_with_apple](https://pub.dev/packages/sign_in_with_apple) in your own Flutter Android Apps you'll need to register this Android intent in your **AndroidManifest.xml**:

```xml
<application ...>

    <!-- Set up the Sign in with Apple activity, such that it's callable from the browser-redirect -->
    <activity
        android:name="com.aboutyou.dart_packages.sign_in_with_apple.SignInWithAppleCallback"
        android:exported="true"
        >
        <intent-filter>
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />

            <data android:scheme="signinwithapple" />
            <data android:path="callback" />
        </intent-filter>
    </activity>
    
    <!-- Don't delete the meta-data below.
            This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
    <meta-data
        android:name="flutterEmbedding"
        android:value="2" />

</application>
```

#### ServiceStack AppleAuthProvider configuration

This client App configuration works in combination with the Server's `AppleAuthProvider` to redirect to your Android's App intent which needs to be configured with:

```csharp
new AppleAuthProvider(AppSettings)
    .Use(AppleAuthFeature.FlutterSignInWithApple), 
```

Where it adds support for `?ReturnUrl=android:<android-package-id>` Callback URLs that your Flutter Android App needs to use.

### Advanced Configuration

The behavior of the `AppleAuthProvider` can be further customized with the following configuration:

```csharp
public class AppleAuthProvider
{
    // Apple Developer Membership Team ID
    // appsettings: oauth.apple.TeamId
    public string TeamId
    
    // Service ID
    // appsettings: oauth.apple.ClientId
    public string ClientId
        
    // Bundle ID
    // appsettings: oauth.apple.BundleId
    public string BundleId

    // The Private Key ID
    // appsettings: oauth.apple.KeyId
    public string KeyId
    
    // Path to .p8 Private Key 
    // appsettings: oauth.apple.KeyPath
    public string KeyPath

    // Base64 of .p8 Private Key bytes 
    // appsettings: oauth.apple.KeyBase64
    public string KeyBase64
    
    // .p8 Private Key bytes 
    public byte[] KeyBytes
    
    // Customize ClientSecret JWT
    public Func<AppleAuthProvider, string> ClientSecretFactory
    
    // When JWT Client Secret expires, defaults to Apple Max 6 Month Expiry 
    // default: 6 months in secs 
    // appsettings: oauth.apple.ClientSecretExpiry
    public TimeSpan ClientSecretExpiry
    
    // JSON list of Apple's public keys, defaults to fetching from https://appleid.apple.com/auth/keys
    // appsettings: oauth.apple.IssuerSigningKeysJson
    public string IssuerSigningKeysJson

    // Whether to cache private Key if loading from KeyPath, 
    // default: true
    // appsettings: oauth.apple.CacheKey
    public bool CacheKey

    // Whether to cache Apple's public keys
    // default: true
    // appsettings: oauth.apple.CacheKey
    public bool CacheIssuerSigningKeys

    // Provide custom DisplayName resolver function when not allowed by User and sent by Apple
    public Func<IAuthSession,IAuthTokens, string> ResolveUnknownDisplayName
}
```