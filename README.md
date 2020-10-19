# Sign In with Apple

ServiceStack Sign In with Apple Integration Examples

![](https://i.imgur.com/cP0cFbX_d.png?maxwidth=900)

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

### Flutter iOS & Apple App

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

To get the `AppleAuthProvider` to redirect to your Android's App intent you'll need to configure it with `.Use(AppleAuthFeature.FlutterSignInWithApple)`, e.g:

#### ServiceStack AppleAuthProvider configuration

```csharp
new AppleAuthProvider(AppSettings)
    .Use(AppleAuthFeature.FlutterSignInWithApple), 
```

Where it adds support for `?ReturnUrl=android:<android-package-id>` Callback URLs that your Flutter Android App needs to use, e.g:

#### Flutter App

```dart
var redirectURL = "https://dev.servicestack.com:5001/auth/apple?ReturnUrl=android:com.servicestack.auth";
final appleIdCredential = await SignInWithApple.getAppleIDCredential(scopes: [
    AppleIDAuthorizationScopes.email,
    AppleIDAuthorizationScopes.fullName], 
webAuthenticationOptions: WebAuthenticationOptions(clientId:clientID, redirectUri:Uri.parse(redirectURL)));
```

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