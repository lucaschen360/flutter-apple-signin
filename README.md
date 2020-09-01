# AppleSignIn

Sign In with Apple Integration Examples

![](https://forums.servicestack.net/uploads/default/original/2X/2/268a89d040b8e6e9ea22a7830f9e891b82c068d4.png)

### Sign In with Apple Requirements

 - Membership **Team ID** from https://developer.apple.com/account/#/membership/
 - Create & configure **App ID** from https://developer.apple.com/account/resources/identifiers/list
 - Use **App ID** to create & configure **Service ID** from https://developer.apple.com/account/resources/identifiers/list/serviceId
 - Use **App ID** to create & configure **Private Key** from https://developer.apple.com/account/resources/authkeys/list

Note: Service ID must be configured with non-localhost trusted domain and HTTPS callback URL, for development you can use:
 - Domain: `localtest.me`
 - Callback URL: `https://localtest.me:5001/auth/apple`

Okta has a [good walkthrough explaining Sign In with Apple](https://developer.okta.com/blog/2019/06/04/what-the-heck-is-sign-in-with-apple) and 
steps required to create the above resources.

As the elliptic curve algorithms required to integrate with Sign In with Apple requires .NET Core 3 APIs the `AppleAuthProvider` is implemented
in the **ServiceStack.Extensions** v5.9.3+ NuGet Package that's [now on MyGet](https://docs.servicestack.net/myget).

### Getting Started

You can either **clone** or **fork** this repo, alternatively you can download the latest master .zip with:

    $ x download NetCoreApps/AppleSignIn

To configure Sign In with Apple, create the above resources in your developer account and use it to populate the `oauth.apple.*` settings in
**appsettings.json**:

```json
{
  "oauth.apple.RedirectUrl": "https://localtest.me:5001/",
  "oauth.apple.CallbackUrl": "https://localtest.me:5001/auth/apple",
  "oauth.apple.TeamId": "{Team ID}",
  "oauth.apple.ClientId": "{Service ID}",
  "oauth.apple.KeyId": "{Private KeyId}",
  "oauth.apple.KeyPath": "AuthKey_{Private KeyId}.p8",
}
```

Then after copying your Private Key into the `web` Content Folder you're all set to run your App:

    $ dotnet run

Then view your App using the non-localhost domain name:

    https://localtest.me:5001/

You can then use the [Embedded Login Page](https://docs.servicestack.net/authentication-and-authorization#embedded-login-page-fallback) which
renders the Sign In button for each of the registered OAuth providers in your `AuthFeature`:

 - https://localtest.me:5001/login

Clicking on **Sign in with Apple** button should let you Sign In with Apple. After successfully signing in you can view the `AllUsersInfo` Service
to view a dump of all User Sessions & User Auth Info stored in the registered RDBMS:

 - https://localtest.me:5001/users


## Create project with preferred Auth Configuration

Alternatively you can create a working project from scratch with your preferred configuration using the [mix tool](https://docs.servicestack.net/mix-tool), e.g: 

    $ md web && cd web
    $ x mix init auth-ext auth-db sqlite

This creates an empty project, with Auth Enabled, adds the **ServiceStack.Extensions** NuGet package, registers OrmLite, SQLite and the `OrmLiteAuthRepository`.

Then configure your OAuth providers in **appsettings.json**:

```json
{
  "oauth.apple.RedirectUrl": "https://localtest.me:5001/",
  "oauth.apple.CallbackUrl": "https://localtest.me:5001/auth/apple",
  "oauth.apple.TeamId": "{Team ID}",
  "oauth.apple.ClientId": "{Service ID}",
  "oauth.apple.KeyId": "{Private KeyId}",
  "oauth.apple.KeyPath": "AuthKey_{Private KeyId}.p8",
}
```

Then copy your Apple Private Key to your Apps **Content Folder** before running your App then Signing In at https://localtest.me:5001/login

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