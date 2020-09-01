using System;
using System.Linq;
using System.Collections.Generic;
using ServiceStack;
using ServiceStack.Auth;
using ServiceStack.OrmLite;
using web.ServiceModel;

namespace web.ServiceInterface
{
    public class MyServices : Service
    {
        public object Any(Hello request)
        {
            return new HelloResponse { Result = $"Hello, {request.Name}!" };
        }

        public object Any(AllUserInfo request)
        {
            var sessionKeys = Cache.GetKeysStartingWith(IdUtils.CreateUrn<IAuthSession>("")).ToList();
            var allSessions = Cache.GetAll<IAuthSession>(sessionKeys);

            return new AllUserInfoResponse {
                UserSessions = allSessions.Values.Map(x => (CustomUserSession)x),
                AppUsers = Db.Select<AppUser>(),
                UserAuthDetails = Db.Select<UserAuthDetails>(),
            };
        }

    }
}
