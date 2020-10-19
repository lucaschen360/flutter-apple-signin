using Microsoft.Extensions.DependencyInjection;
using ServiceStack;
using ServiceStack.Auth;
using ServiceStack.FluentValidation;

namespace web
{
    // Add any additional metadata properties you want to store in the Users Typed Session
    public class CustomUserSession : AuthUserSession 
    {
    }
    
    // Custom Validator to add custom validators to built-in /register Service requiring DisplayName and ConfirmPassword
    public class CustomRegistrationValidator : RegistrationValidator
    {
        public CustomRegistrationValidator()
        {
            RuleSet(ApplyTo.Post, () =>
            {
                RuleFor(x => x.DisplayName).NotEmpty();
                RuleFor(x => x.ConfirmPassword).NotEmpty();
            });
        }
    }

    public class ConfigureAuth : IConfigureAppHost, IConfigureServices
    {
        public void Configure(IServiceCollection services)
        {
            //services.AddSingleton<ICacheClient>(new MemoryCacheClient()); //Store User Sessions in Memory Cache (default)
        }

        public void Configure(IAppHost appHost)
        {
            var AppSettings = appHost.AppSettings;
            appHost.Plugins.Add(new AuthFeature(() => new CustomUserSession(),
                new IAuthProvider[] {
                    new CredentialsAuthProvider(AppSettings),     /* Sign In with Username / Password credentials */
                    new JwtAuthProvider(AppSettings) {
                        UseTokenCookie = true
                    },
                    new AppleAuthProvider(AppSettings)           /* Configure: https://developer.okta.com/blog/2019/06/04/what-the-heck-is-sign-in-with-apple */
                        .Use(AppleAuthFeature.FlutterSignInWithApple), 
                }));

            appHost.Plugins.Add(new RegistrationFeature()); //Enable /register Service

            //override the default registration validation with your own custom implementation
            appHost.RegisterAs<CustomRegistrationValidator, IValidator<Register>>();
        }
    }
}