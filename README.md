# AppleSignIn

Sign In with Apple Integration Examples

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


# web

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