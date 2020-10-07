/* Options:
Date: 2020-10-08 01:39:36
SwiftVersion: 4.0
Version: 5.9
Tip: To override a DTO option, remove "//" prefix before updating
BaseUrl: https://dev.servicestack.com:5001

//BaseClass: 
//AddModelExtensions: True
//AddServiceStackTypes: True
IncludeTypes: Hello.*,HelloSecure.*,Authenticate.*
//ExcludeTypes: 
//ExcludeGenericBaseTypes: False
//AddResponseStatus: False
//AddImplicitVersion: 
//AddDescriptionAsComments: True
//InitializeCollections: True
//TreatTypesAsStrings: 
//DefaultImports: Foundation,ServiceStack
*/

import Foundation
import ServiceStack

// @Route("/hello")
// @Route("/hello/{Name}")
// @DataContract
public class Hello : IReturn
{
    public typealias Return = HelloResponse

    required public init(){}
    // @DataMember(Order=1)
    public var name:String?
}

// @Route("/hello/secure")
// @Route("/hello/secure/{Name}")
// @ValidateRequest(Validator="IsAuthenticated")
public class HelloSecure : IReturn
{
    public typealias Return = HelloResponse

    required public init(){}
    public var name:String?
}

// @Route("/auth")
// @Route("/auth/{provider}")
// @DataContract
public class Authenticate : IReturn, IPost
{
    public typealias Return = AuthenticateResponse

    required public init(){}
    // @DataMember(Order=1)
    public var provider:String?

    // @DataMember(Order=2)
    public var state:String?

    // @DataMember(Order=3)
    public var oauth_token:String?

    // @DataMember(Order=4)
    public var oauth_verifier:String?

    // @DataMember(Order=5)
    public var userName:String?

    // @DataMember(Order=6)
    public var password:String?

    // @DataMember(Order=7)
    public var rememberMe:Bool?

    // @DataMember(Order=9)
    public var errorView:String?

    // @DataMember(Order=10)
    public var nonce:String?

    // @DataMember(Order=11)
    public var uri:String?

    // @DataMember(Order=12)
    public var response:String?

    // @DataMember(Order=13)
    public var qop:String?

    // @DataMember(Order=14)
    public var nc:String?

    // @DataMember(Order=15)
    public var cnonce:String?

    // @DataMember(Order=16)
    public var useTokenCookie:Bool?

    // @DataMember(Order=17)
    public var accessToken:String?

    // @DataMember(Order=18)
    public var accessTokenSecret:String?

    // @DataMember(Order=19)
    public var scope:String?

    // @DataMember(Order=20)
    public var meta:[String:String] = [:]
}

// @DataContract
public class HelloResponse
{
    required public init(){}
    // @DataMember(Order=1)
    public var result:String?
}

// @DataContract
public class AuthenticateResponse : IHasSessionId, IHasBearerToken
{
    required public init(){}
    // @DataMember(Order=1)
    public var userId:String?

    // @DataMember(Order=2)
    public var sessionId:String?

    // @DataMember(Order=3)
    public var userName:String?

    // @DataMember(Order=4)
    public var displayName:String?

    // @DataMember(Order=5)
    public var referrerUrl:String?

    // @DataMember(Order=6)
    public var bearerToken:String?

    // @DataMember(Order=7)
    public var refreshToken:String?

    // @DataMember(Order=8)
    public var profileUrl:String?

    // @DataMember(Order=9)
    public var roles:[String] = []

    // @DataMember(Order=10)
    public var permissions:[String] = []

    // @DataMember(Order=11)
    public var responseStatus:ResponseStatus?

    // @DataMember(Order=12)
    public var meta:[String:String] = [:]
}


extension Hello : JsonSerializable
{
    public static var typeName:String { return "Hello" }
    public static var metadata = Metadata.create([
            Type<Hello>.optionalProperty("name", get: { $0.name }, set: { $0.name = $1 }),
        ])
}

extension HelloSecure : JsonSerializable
{
    public static var typeName:String { return "HelloSecure" }
    public static var metadata = Metadata.create([
            Type<HelloSecure>.optionalProperty("name", get: { $0.name }, set: { $0.name = $1 }),
        ])
}

extension Authenticate : JsonSerializable
{
    public static var typeName:String { return "Authenticate" }
    public static var metadata = Metadata.create([
            Type<Authenticate>.optionalProperty("provider", get: { $0.provider }, set: { $0.provider = $1 }),
            Type<Authenticate>.optionalProperty("state", get: { $0.state }, set: { $0.state = $1 }),
            Type<Authenticate>.optionalProperty("oauth_token", get: { $0.oauth_token }, set: { $0.oauth_token = $1 }),
            Type<Authenticate>.optionalProperty("oauth_verifier", get: { $0.oauth_verifier }, set: { $0.oauth_verifier = $1 }),
            Type<Authenticate>.optionalProperty("userName", get: { $0.userName }, set: { $0.userName = $1 }),
            Type<Authenticate>.optionalProperty("password", get: { $0.password }, set: { $0.password = $1 }),
            Type<Authenticate>.optionalProperty("rememberMe", get: { $0.rememberMe }, set: { $0.rememberMe = $1 }),
            Type<Authenticate>.optionalProperty("errorView", get: { $0.errorView }, set: { $0.errorView = $1 }),
            Type<Authenticate>.optionalProperty("nonce", get: { $0.nonce }, set: { $0.nonce = $1 }),
            Type<Authenticate>.optionalProperty("uri", get: { $0.uri }, set: { $0.uri = $1 }),
            Type<Authenticate>.optionalProperty("response", get: { $0.response }, set: { $0.response = $1 }),
            Type<Authenticate>.optionalProperty("qop", get: { $0.qop }, set: { $0.qop = $1 }),
            Type<Authenticate>.optionalProperty("nc", get: { $0.nc }, set: { $0.nc = $1 }),
            Type<Authenticate>.optionalProperty("cnonce", get: { $0.cnonce }, set: { $0.cnonce = $1 }),
            Type<Authenticate>.optionalProperty("useTokenCookie", get: { $0.useTokenCookie }, set: { $0.useTokenCookie = $1 }),
            Type<Authenticate>.optionalProperty("accessToken", get: { $0.accessToken }, set: { $0.accessToken = $1 }),
            Type<Authenticate>.optionalProperty("accessTokenSecret", get: { $0.accessTokenSecret }, set: { $0.accessTokenSecret = $1 }),
            Type<Authenticate>.optionalProperty("scope", get: { $0.scope }, set: { $0.scope = $1 }),
            Type<Authenticate>.objectProperty("meta", get: { $0.meta }, set: { $0.meta = $1 }),
        ])
}

extension HelloResponse : JsonSerializable
{
    public static var typeName:String { return "HelloResponse" }
    public static var metadata = Metadata.create([
            Type<HelloResponse>.optionalProperty("result", get: { $0.result }, set: { $0.result = $1 }),
        ])
}

extension AuthenticateResponse : JsonSerializable
{
    public static var typeName:String { return "AuthenticateResponse" }
    public static var metadata = Metadata.create([
            Type<AuthenticateResponse>.optionalProperty("userId", get: { $0.userId }, set: { $0.userId = $1 }),
            Type<AuthenticateResponse>.optionalProperty("sessionId", get: { $0.sessionId }, set: { $0.sessionId = $1 }),
            Type<AuthenticateResponse>.optionalProperty("userName", get: { $0.userName }, set: { $0.userName = $1 }),
            Type<AuthenticateResponse>.optionalProperty("displayName", get: { $0.displayName }, set: { $0.displayName = $1 }),
            Type<AuthenticateResponse>.optionalProperty("referrerUrl", get: { $0.referrerUrl }, set: { $0.referrerUrl = $1 }),
            Type<AuthenticateResponse>.optionalProperty("bearerToken", get: { $0.bearerToken }, set: { $0.bearerToken = $1 }),
            Type<AuthenticateResponse>.optionalProperty("refreshToken", get: { $0.refreshToken }, set: { $0.refreshToken = $1 }),
            Type<AuthenticateResponse>.optionalProperty("profileUrl", get: { $0.profileUrl }, set: { $0.profileUrl = $1 }),
            Type<AuthenticateResponse>.arrayProperty("roles", get: { $0.roles }, set: { $0.roles = $1 }),
            Type<AuthenticateResponse>.arrayProperty("permissions", get: { $0.permissions }, set: { $0.permissions = $1 }),
            Type<AuthenticateResponse>.optionalProperty("responseStatus", get: { $0.responseStatus }, set: { $0.responseStatus = $1 }),
            Type<AuthenticateResponse>.objectProperty("meta", get: { $0.meta }, set: { $0.meta = $1 }),
        ])
}

