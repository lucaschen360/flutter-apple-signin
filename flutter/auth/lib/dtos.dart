/* Options:
Date: 2020-10-05 15:05:44
Version: 5.93
Tip: To override a DTO option, remove "//" prefix before updating
BaseUrl: https://dev.servicestack.com:5001

//GlobalNamespace: 
//AddServiceStackTypes: True
//AddResponseStatus: False
//AddImplicitVersion: 
//AddDescriptionAsComments: True
//IncludeTypes: 
//ExcludeTypes: 
//DefaultImports: package:servicestack/servicestack.dart
*/

import 'package:servicestack/servicestack.dart';

abstract class IAuthTokens
{
    String provider;
    String userId;
    String accessToken;
    String accessTokenSecret;
    String refreshToken;
    DateTime refreshTokenExpiry;
    String requestToken;
    String requestTokenSecret;
    Map<String,String> items;
}

// @DataContract
class AuthUserSession implements IConvertible
{
    // @DataMember(Order=1)
    String referrerUrl;

    // @DataMember(Order=2)
    String id;

    // @DataMember(Order=3)
    String userAuthId;

    // @DataMember(Order=4)
    String userAuthName;

    // @DataMember(Order=5)
    String userName;

    // @DataMember(Order=6)
    String twitterUserId;

    // @DataMember(Order=7)
    String twitterScreenName;

    // @DataMember(Order=8)
    String facebookUserId;

    // @DataMember(Order=9)
    String facebookUserName;

    // @DataMember(Order=10)
    String firstName;

    // @DataMember(Order=11)
    String lastName;

    // @DataMember(Order=12)
    String displayName;

    // @DataMember(Order=13)
    String company;

    // @DataMember(Order=14)
    String email;

    // @DataMember(Order=15)
    String primaryEmail;

    // @DataMember(Order=16)
    String phoneNumber;

    // @DataMember(Order=17)
    DateTime birthDate;

    // @DataMember(Order=18)
    String birthDateRaw;

    // @DataMember(Order=19)
    String address;

    // @DataMember(Order=20)
    String address2;

    // @DataMember(Order=21)
    String city;

    // @DataMember(Order=22)
    String state;

    // @DataMember(Order=23)
    String country;

    // @DataMember(Order=24)
    String culture;

    // @DataMember(Order=25)
    String fullName;

    // @DataMember(Order=26)
    String gender;

    // @DataMember(Order=27)
    String language;

    // @DataMember(Order=28)
    String mailAddress;

    // @DataMember(Order=29)
    String nickname;

    // @DataMember(Order=30)
    String postalCode;

    // @DataMember(Order=31)
    String timeZone;

    // @DataMember(Order=32)
    String requestTokenSecret;

    // @DataMember(Order=33)
    DateTime createdAt;

    // @DataMember(Order=34)
    DateTime lastModified;

    // @DataMember(Order=35)
    List<String> roles;

    // @DataMember(Order=36)
    List<String> permissions;

    // @DataMember(Order=37)
    bool isAuthenticated;

    // @DataMember(Order=38)
    bool fromToken;

    // @DataMember(Order=39)
    String profileUrl;

    // @DataMember(Order=40)
    String sequence;

    // @DataMember(Order=41)
    int tag;

    // @DataMember(Order=42)
    String authProvider;

    // @DataMember(Order=43)
    List<IAuthTokens> providerOAuthAccess;

    // @DataMember(Order=44)
    Map<String,String> meta;

    // @DataMember(Order=45)
    List<String> audiences;

    // @DataMember(Order=46)
    List<String> scopes;

    // @DataMember(Order=47)
    String dns;

    // @DataMember(Order=48)
    String rsa;

    // @DataMember(Order=49)
    String sid;

    // @DataMember(Order=50)
    String hash;

    // @DataMember(Order=51)
    String homePhone;

    // @DataMember(Order=52)
    String mobilePhone;

    // @DataMember(Order=53)
    String webpage;

    // @DataMember(Order=54)
    bool emailConfirmed;

    // @DataMember(Order=55)
    bool phoneNumberConfirmed;

    // @DataMember(Order=56)
    bool twoFactorEnabled;

    // @DataMember(Order=57)
    String securityStamp;

    // @DataMember(Order=58)
    String type;

    AuthUserSession({this.referrerUrl,this.id,this.userAuthId,this.userAuthName,this.userName,this.twitterUserId,this.twitterScreenName,this.facebookUserId,this.facebookUserName,this.firstName,this.lastName,this.displayName,this.company,this.email,this.primaryEmail,this.phoneNumber,this.birthDate,this.birthDateRaw,this.address,this.address2,this.city,this.state,this.country,this.culture,this.fullName,this.gender,this.language,this.mailAddress,this.nickname,this.postalCode,this.timeZone,this.requestTokenSecret,this.createdAt,this.lastModified,this.roles,this.permissions,this.isAuthenticated,this.fromToken,this.profileUrl,this.sequence,this.tag,this.authProvider,this.providerOAuthAccess,this.meta,this.audiences,this.scopes,this.dns,this.rsa,this.sid,this.hash,this.homePhone,this.mobilePhone,this.webpage,this.emailConfirmed,this.phoneNumberConfirmed,this.twoFactorEnabled,this.securityStamp,this.type});
    AuthUserSession.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        referrerUrl = json['referrerUrl'];
        id = json['id'];
        userAuthId = json['userAuthId'];
        userAuthName = json['userAuthName'];
        userName = json['userName'];
        twitterUserId = json['twitterUserId'];
        twitterScreenName = json['twitterScreenName'];
        facebookUserId = json['facebookUserId'];
        facebookUserName = json['facebookUserName'];
        firstName = json['firstName'];
        lastName = json['lastName'];
        displayName = json['displayName'];
        company = json['company'];
        email = json['email'];
        primaryEmail = json['primaryEmail'];
        phoneNumber = json['phoneNumber'];
        birthDate = JsonConverters.fromJson(json['birthDate'],'DateTime',context);
        birthDateRaw = json['birthDateRaw'];
        address = json['address'];
        address2 = json['address2'];
        city = json['city'];
        state = json['state'];
        country = json['country'];
        culture = json['culture'];
        fullName = json['fullName'];
        gender = json['gender'];
        language = json['language'];
        mailAddress = json['mailAddress'];
        nickname = json['nickname'];
        postalCode = json['postalCode'];
        timeZone = json['timeZone'];
        requestTokenSecret = json['requestTokenSecret'];
        createdAt = JsonConverters.fromJson(json['createdAt'],'DateTime',context);
        lastModified = JsonConverters.fromJson(json['lastModified'],'DateTime',context);
        roles = JsonConverters.fromJson(json['roles'],'List<String>',context);
        permissions = JsonConverters.fromJson(json['permissions'],'List<String>',context);
        isAuthenticated = json['isAuthenticated'];
        fromToken = json['fromToken'];
        profileUrl = json['profileUrl'];
        sequence = json['sequence'];
        tag = json['tag'];
        authProvider = json['authProvider'];
        providerOAuthAccess = JsonConverters.fromJson(json['providerOAuthAccess'],'List<IAuthTokens>',context);
        meta = JsonConverters.toStringMap(json['meta']);
        audiences = JsonConverters.fromJson(json['audiences'],'List<String>',context);
        scopes = JsonConverters.fromJson(json['scopes'],'List<String>',context);
        dns = json['dns'];
        rsa = json['rsa'];
        sid = json['sid'];
        hash = json['hash'];
        homePhone = json['homePhone'];
        mobilePhone = json['mobilePhone'];
        webpage = json['webpage'];
        emailConfirmed = json['emailConfirmed'];
        phoneNumberConfirmed = json['phoneNumberConfirmed'];
        twoFactorEnabled = json['twoFactorEnabled'];
        securityStamp = json['securityStamp'];
        type = json['type'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'referrerUrl': referrerUrl,
        'id': id,
        'userAuthId': userAuthId,
        'userAuthName': userAuthName,
        'userName': userName,
        'twitterUserId': twitterUserId,
        'twitterScreenName': twitterScreenName,
        'facebookUserId': facebookUserId,
        'facebookUserName': facebookUserName,
        'firstName': firstName,
        'lastName': lastName,
        'displayName': displayName,
        'company': company,
        'email': email,
        'primaryEmail': primaryEmail,
        'phoneNumber': phoneNumber,
        'birthDate': JsonConverters.toJson(birthDate,'DateTime',context),
        'birthDateRaw': birthDateRaw,
        'address': address,
        'address2': address2,
        'city': city,
        'state': state,
        'country': country,
        'culture': culture,
        'fullName': fullName,
        'gender': gender,
        'language': language,
        'mailAddress': mailAddress,
        'nickname': nickname,
        'postalCode': postalCode,
        'timeZone': timeZone,
        'requestTokenSecret': requestTokenSecret,
        'createdAt': JsonConverters.toJson(createdAt,'DateTime',context),
        'lastModified': JsonConverters.toJson(lastModified,'DateTime',context),
        'roles': JsonConverters.toJson(roles,'List<String>',context),
        'permissions': JsonConverters.toJson(permissions,'List<String>',context),
        'isAuthenticated': isAuthenticated,
        'fromToken': fromToken,
        'profileUrl': profileUrl,
        'sequence': sequence,
        'tag': tag,
        'authProvider': authProvider,
        'providerOAuthAccess': JsonConverters.toJson(providerOAuthAccess,'List<IAuthTokens>',context),
        'meta': meta,
        'audiences': JsonConverters.toJson(audiences,'List<String>',context),
        'scopes': JsonConverters.toJson(scopes,'List<String>',context),
        'dns': dns,
        'rsa': rsa,
        'sid': sid,
        'hash': hash,
        'homePhone': homePhone,
        'mobilePhone': mobilePhone,
        'webpage': webpage,
        'emailConfirmed': emailConfirmed,
        'phoneNumberConfirmed': phoneNumberConfirmed,
        'twoFactorEnabled': twoFactorEnabled,
        'securityStamp': securityStamp,
        'type': type
    };

    TypeContext context = _ctx;
}

class CustomUserSession extends AuthUserSession implements IConvertible
{
    CustomUserSession();
    CustomUserSession.fromJson(Map<String, dynamic> json) : super.fromJson(json);
    fromMap(Map<String, dynamic> json) {
        super.fromMap(json);
        return this;
    }

    Map<String, dynamic> toJson() => super.toJson();
    TypeContext context = _ctx;
}

class UserAuth implements IConvertible
{
    int id;
    String userName;
    String email;
    String primaryEmail;
    String phoneNumber;
    String firstName;
    String lastName;
    String displayName;
    String company;
    DateTime birthDate;
    String birthDateRaw;
    String address;
    String address2;
    String city;
    String state;
    String country;
    String culture;
    String fullName;
    String gender;
    String language;
    String mailAddress;
    String nickname;
    String postalCode;
    String timeZone;
    String salt;
    String passwordHash;
    String digestHa1Hash;
    List<String> roles;
    List<String> permissions;
    DateTime createdDate;
    DateTime modifiedDate;
    int invalidLoginAttempts;
    DateTime lastLoginAttempt;
    DateTime lockedDate;
    String recoveryToken;
    int refId;
    String refIdStr;
    Map<String,String> meta;

    UserAuth({this.id,this.userName,this.email,this.primaryEmail,this.phoneNumber,this.firstName,this.lastName,this.displayName,this.company,this.birthDate,this.birthDateRaw,this.address,this.address2,this.city,this.state,this.country,this.culture,this.fullName,this.gender,this.language,this.mailAddress,this.nickname,this.postalCode,this.timeZone,this.salt,this.passwordHash,this.digestHa1Hash,this.roles,this.permissions,this.createdDate,this.modifiedDate,this.invalidLoginAttempts,this.lastLoginAttempt,this.lockedDate,this.recoveryToken,this.refId,this.refIdStr,this.meta});
    UserAuth.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        id = json['id'];
        userName = json['userName'];
        email = json['email'];
        primaryEmail = json['primaryEmail'];
        phoneNumber = json['phoneNumber'];
        firstName = json['firstName'];
        lastName = json['lastName'];
        displayName = json['displayName'];
        company = json['company'];
        birthDate = JsonConverters.fromJson(json['birthDate'],'DateTime',context);
        birthDateRaw = json['birthDateRaw'];
        address = json['address'];
        address2 = json['address2'];
        city = json['city'];
        state = json['state'];
        country = json['country'];
        culture = json['culture'];
        fullName = json['fullName'];
        gender = json['gender'];
        language = json['language'];
        mailAddress = json['mailAddress'];
        nickname = json['nickname'];
        postalCode = json['postalCode'];
        timeZone = json['timeZone'];
        salt = json['salt'];
        passwordHash = json['passwordHash'];
        digestHa1Hash = json['digestHa1Hash'];
        roles = JsonConverters.fromJson(json['roles'],'List<String>',context);
        permissions = JsonConverters.fromJson(json['permissions'],'List<String>',context);
        createdDate = JsonConverters.fromJson(json['createdDate'],'DateTime',context);
        modifiedDate = JsonConverters.fromJson(json['modifiedDate'],'DateTime',context);
        invalidLoginAttempts = json['invalidLoginAttempts'];
        lastLoginAttempt = JsonConverters.fromJson(json['lastLoginAttempt'],'DateTime',context);
        lockedDate = JsonConverters.fromJson(json['lockedDate'],'DateTime',context);
        recoveryToken = json['recoveryToken'];
        refId = json['refId'];
        refIdStr = json['refIdStr'];
        meta = JsonConverters.toStringMap(json['meta']);
        return this;
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'email': email,
        'primaryEmail': primaryEmail,
        'phoneNumber': phoneNumber,
        'firstName': firstName,
        'lastName': lastName,
        'displayName': displayName,
        'company': company,
        'birthDate': JsonConverters.toJson(birthDate,'DateTime',context),
        'birthDateRaw': birthDateRaw,
        'address': address,
        'address2': address2,
        'city': city,
        'state': state,
        'country': country,
        'culture': culture,
        'fullName': fullName,
        'gender': gender,
        'language': language,
        'mailAddress': mailAddress,
        'nickname': nickname,
        'postalCode': postalCode,
        'timeZone': timeZone,
        'salt': salt,
        'passwordHash': passwordHash,
        'digestHa1Hash': digestHa1Hash,
        'roles': JsonConverters.toJson(roles,'List<String>',context),
        'permissions': JsonConverters.toJson(permissions,'List<String>',context),
        'createdDate': JsonConverters.toJson(createdDate,'DateTime',context),
        'modifiedDate': JsonConverters.toJson(modifiedDate,'DateTime',context),
        'invalidLoginAttempts': invalidLoginAttempts,
        'lastLoginAttempt': JsonConverters.toJson(lastLoginAttempt,'DateTime',context),
        'lockedDate': JsonConverters.toJson(lockedDate,'DateTime',context),
        'recoveryToken': recoveryToken,
        'refId': refId,
        'refIdStr': refIdStr,
        'meta': meta
    };

    TypeContext context = _ctx;
}

class AppUser extends UserAuth implements IConvertible
{
    String profileUrl;
    String lastLoginIp;
    DateTime lastLoginDate;

    AppUser({this.profileUrl,this.lastLoginIp,this.lastLoginDate});
    AppUser.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        super.fromMap(json);
        profileUrl = json['profileUrl'];
        lastLoginIp = json['lastLoginIp'];
        lastLoginDate = JsonConverters.fromJson(json['lastLoginDate'],'DateTime',context);
        return this;
    }

    Map<String, dynamic> toJson() => super.toJson()..addAll({
        'profileUrl': profileUrl,
        'lastLoginIp': lastLoginIp,
        'lastLoginDate': JsonConverters.toJson(lastLoginDate,'DateTime',context)
    });

    TypeContext context = _ctx;
}

class UserAuthDetails implements IConvertible
{
    int id;
    int userAuthId;
    String provider;
    String userId;
    String userName;
    String fullName;
    String displayName;
    String firstName;
    String lastName;
    String company;
    String email;
    String phoneNumber;
    DateTime birthDate;
    String birthDateRaw;
    String address;
    String address2;
    String city;
    String state;
    String country;
    String culture;
    String gender;
    String language;
    String mailAddress;
    String nickname;
    String postalCode;
    String timeZone;
    String refreshToken;
    DateTime refreshTokenExpiry;
    String requestToken;
    String requestTokenSecret;
    Map<String,String> items;
    String accessToken;
    String accessTokenSecret;
    DateTime createdDate;
    DateTime modifiedDate;
    int refId;
    String refIdStr;
    Map<String,String> meta;

    UserAuthDetails({this.id,this.userAuthId,this.provider,this.userId,this.userName,this.fullName,this.displayName,this.firstName,this.lastName,this.company,this.email,this.phoneNumber,this.birthDate,this.birthDateRaw,this.address,this.address2,this.city,this.state,this.country,this.culture,this.gender,this.language,this.mailAddress,this.nickname,this.postalCode,this.timeZone,this.refreshToken,this.refreshTokenExpiry,this.requestToken,this.requestTokenSecret,this.items,this.accessToken,this.accessTokenSecret,this.createdDate,this.modifiedDate,this.refId,this.refIdStr,this.meta});
    UserAuthDetails.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        id = json['id'];
        userAuthId = json['userAuthId'];
        provider = json['provider'];
        userId = json['userId'];
        userName = json['userName'];
        fullName = json['fullName'];
        displayName = json['displayName'];
        firstName = json['firstName'];
        lastName = json['lastName'];
        company = json['company'];
        email = json['email'];
        phoneNumber = json['phoneNumber'];
        birthDate = JsonConverters.fromJson(json['birthDate'],'DateTime',context);
        birthDateRaw = json['birthDateRaw'];
        address = json['address'];
        address2 = json['address2'];
        city = json['city'];
        state = json['state'];
        country = json['country'];
        culture = json['culture'];
        gender = json['gender'];
        language = json['language'];
        mailAddress = json['mailAddress'];
        nickname = json['nickname'];
        postalCode = json['postalCode'];
        timeZone = json['timeZone'];
        refreshToken = json['refreshToken'];
        refreshTokenExpiry = JsonConverters.fromJson(json['refreshTokenExpiry'],'DateTime',context);
        requestToken = json['requestToken'];
        requestTokenSecret = json['requestTokenSecret'];
        items = JsonConverters.toStringMap(json['items']);
        accessToken = json['accessToken'];
        accessTokenSecret = json['accessTokenSecret'];
        createdDate = JsonConverters.fromJson(json['createdDate'],'DateTime',context);
        modifiedDate = JsonConverters.fromJson(json['modifiedDate'],'DateTime',context);
        refId = json['refId'];
        refIdStr = json['refIdStr'];
        meta = JsonConverters.toStringMap(json['meta']);
        return this;
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'userAuthId': userAuthId,
        'provider': provider,
        'userId': userId,
        'userName': userName,
        'fullName': fullName,
        'displayName': displayName,
        'firstName': firstName,
        'lastName': lastName,
        'company': company,
        'email': email,
        'phoneNumber': phoneNumber,
        'birthDate': JsonConverters.toJson(birthDate,'DateTime',context),
        'birthDateRaw': birthDateRaw,
        'address': address,
        'address2': address2,
        'city': city,
        'state': state,
        'country': country,
        'culture': culture,
        'gender': gender,
        'language': language,
        'mailAddress': mailAddress,
        'nickname': nickname,
        'postalCode': postalCode,
        'timeZone': timeZone,
        'refreshToken': refreshToken,
        'refreshTokenExpiry': JsonConverters.toJson(refreshTokenExpiry,'DateTime',context),
        'requestToken': requestToken,
        'requestTokenSecret': requestTokenSecret,
        'items': items,
        'accessToken': accessToken,
        'accessTokenSecret': accessTokenSecret,
        'createdDate': JsonConverters.toJson(createdDate,'DateTime',context),
        'modifiedDate': JsonConverters.toJson(modifiedDate,'DateTime',context),
        'refId': refId,
        'refIdStr': refIdStr,
        'meta': meta
    };

    TypeContext context = _ctx;
}

class HelloResponse implements IConvertible
{
    String result;

    HelloResponse({this.result});
    HelloResponse.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        result = json['result'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'result': result
    };

    TypeContext context = _ctx;
}

class AllUserInfoResponse implements IConvertible
{
    ResponseStatus responseStatus;
    List<CustomUserSession> userSessions;
    List<AppUser> appUsers;
    List<UserAuthDetails> userAuthDetails;

    AllUserInfoResponse({this.responseStatus,this.userSessions,this.appUsers,this.userAuthDetails});
    AllUserInfoResponse.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        responseStatus = JsonConverters.fromJson(json['responseStatus'],'ResponseStatus',context);
        userSessions = JsonConverters.fromJson(json['userSessions'],'List<CustomUserSession>',context);
        appUsers = JsonConverters.fromJson(json['appUsers'],'List<AppUser>',context);
        userAuthDetails = JsonConverters.fromJson(json['userAuthDetails'],'List<UserAuthDetails>',context);
        return this;
    }

    Map<String, dynamic> toJson() => {
        'responseStatus': JsonConverters.toJson(responseStatus,'ResponseStatus',context),
        'userSessions': JsonConverters.toJson(userSessions,'List<CustomUserSession>',context),
        'appUsers': JsonConverters.toJson(appUsers,'List<AppUser>',context),
        'userAuthDetails': JsonConverters.toJson(userAuthDetails,'List<UserAuthDetails>',context)
    };

    TypeContext context = _ctx;
}

// @Route("/hello")
// @Route("/hello/{Name}")
class Hello implements IReturn<HelloResponse>, IConvertible
{
    String name;

    Hello({this.name});
    Hello.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        name = json['name'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'name': name
    };

    createResponse() { return new HelloResponse(); }
    String getTypeName() { return "Hello"; }
    TypeContext context = _ctx;
}

// @Route("/hello/secure")
// @Route("/hello/secure/{Name}")
// @ValidateRequest(Validator="IsAuthenticated")
class HelloSecure implements IReturn<HelloResponse>, IConvertible
{
    String name;

    HelloSecure({this.name});
    HelloSecure.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        name = json['name'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'name': name
    };

    createResponse() { return new HelloResponse(); }
    String getTypeName() { return "HelloSecure"; }
    TypeContext context = _ctx;
}

// @Route("/users")
class AllUserInfo implements IReturn<AllUserInfoResponse>, IConvertible
{
    AllUserInfo();
    AllUserInfo.fromJson(Map<String, dynamic> json) : super();
    fromMap(Map<String, dynamic> json) {
        return this;
    }

    Map<String, dynamic> toJson() => {};
    createResponse() { return new AllUserInfoResponse(); }
    String getTypeName() { return "AllUserInfo"; }
    TypeContext context = _ctx;
}

TypeContext _ctx = new TypeContext(library: 'dev.servicestack.com', types: <String, TypeInfo> {
    'IAuthTokens': new TypeInfo(TypeOf.Interface),
    'AuthUserSession': new TypeInfo(TypeOf.Class, create:() => new AuthUserSession()),
    'List<IAuthTokens>': new TypeInfo(TypeOf.Class, create:() => new List<IAuthTokens>()),
    'CustomUserSession': new TypeInfo(TypeOf.Class, create:() => new CustomUserSession()),
    'UserAuth': new TypeInfo(TypeOf.Class, create:() => new UserAuth()),
    'AppUser': new TypeInfo(TypeOf.Class, create:() => new AppUser()),
    'UserAuthDetails': new TypeInfo(TypeOf.Class, create:() => new UserAuthDetails()),
    'HelloResponse': new TypeInfo(TypeOf.Class, create:() => new HelloResponse()),
    'AllUserInfoResponse': new TypeInfo(TypeOf.Class, create:() => new AllUserInfoResponse()),
    'List<CustomUserSession>': new TypeInfo(TypeOf.Class, create:() => new List<CustomUserSession>()),
    'List<AppUser>': new TypeInfo(TypeOf.Class, create:() => new List<AppUser>()),
    'List<UserAuthDetails>': new TypeInfo(TypeOf.Class, create:() => new List<UserAuthDetails>()),
    'Hello': new TypeInfo(TypeOf.Class, create:() => new Hello()),
    'HelloSecure': new TypeInfo(TypeOf.Class, create:() => new HelloSecure()),
    'AllUserInfo': new TypeInfo(TypeOf.Class, create:() => new AllUserInfo()),
});

