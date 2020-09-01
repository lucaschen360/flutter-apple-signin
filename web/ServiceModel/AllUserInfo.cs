using System.Collections.Generic;
using ServiceStack;
using ServiceStack.Auth;

namespace web.ServiceModel
{
    [Route("/users")]
    public class AllUserInfo : IReturn<AllUserInfoResponse> { }

    public class AllUserInfoResponse
    {
        public ResponseStatus ResponseStatus { get; set; }
        public List<CustomUserSession> UserSessions { get; set; }
        public List<AppUser> AppUsers { get; set; }
        public List<UserAuthDetails> UserAuthDetails { get; set; }
    }
}
