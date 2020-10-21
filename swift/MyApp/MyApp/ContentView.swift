//
//  ContentView.swift
//  MyApp
//
//  Created by Demis Bellot on 10/7/20.
//

import SwiftUI
import AuthenticationServices
import Combine
import ServiceStack

struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
         VStack{
            if !vm.hasInit {
                Text("Loading...")
            } else {
                Text(vm.result)
                Button("Go!") {
                    vm.doSecureRequest()
                }
                if let auth = vm.auth {
                    VStack {
                        Text("Hi \(auth.displayName ?? "")")
                        if vm.authState != "" {
                            Text("authState: \(vm.authState)")
                                .foregroundColor(vm.authState == "authorized" ? .green : .primary)
                        }
                        Button("Sign Out") { vm.signOut() }
                    }
                } else {
                    AppleSignInButton()
                        .frame(width: 200, height: 50)
                        .onTapGesture {
                            self.vm.getRequest()
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct User: Codable {
    let idToken, authorizationCode : Data?
    let givenName, familyName, email, authState : String?
}

struct AppleSignInButton: UIViewRepresentable {
 func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
  return ASAuthorizationAppleIDButton(
    authorizationButtonType: .signUp,
    authorizationButtonStyle: .white)
 }
 func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context:Context) {}
}

final class SignInWithAppleCoordinator : NSObject {
    let vm: ViewModel
    init(vm:ViewModel) {
        self.vm = vm
    }
    
    func getAppleRequest() {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.performRequests()
    }
    
    private func setUserInfo(for credential: ASAuthorizationAppleIDCredential) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: credential.user, completion: { credentialState, error in
            var authState: String?
            switch credentialState {
            case .authorized: authState = "authorized"
            case .notFound: authState = "notFound"
            case .revoked: authState = "revoked"
            case .transferred: authState = "transferred"
            @unknown default: fatalError()
            }
            self.vm.setUser(credential:credential, authState:authState!)
        })
    }
}

extension SignInWithAppleCoordinator : ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            setUserInfo(for: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign In with Apple Error: \(error.localizedDescription)")
    }
}

class ViewModel: ObservableObject {
    private lazy var signInWithApple = SignInWithAppleCoordinator(vm:self)
    private lazy var client = createClient()
    
    func createClient() -> JsonServiceClient {
        let client = JsonServiceClient(baseUrl: "https://dev.servicestack.com:5001")
        client.ignoreCert = true
        return client
    }
    
    @Published var auth: AuthenticateResponse?
    var isAuthenticated:Bool { auth != nil }
    @Published var hasInit:Bool = false
    @Published var result:String = ""
    @Published var authState:String = ""

    init() {
        load()
    }
    
    func getRequest() {
        signInWithApple.getAppleRequest()
    }
    
    func doSecureRequest() {
        self.result = ""
        DispatchQueue.main.async {
            let request = HelloSecure()
            request.name = "SwiftUI"
            _ = self.client.getAsync(request)
                .done { r in
                    self.result = r.result ?? ""
                }
                .catch { error in
                    let status:ResponseStatus = error.convertUserInfo()!
                    self.result = "\(status.errorCode ?? ""): \(status.message ?? "")"
                }
        }
    }
    
    func signOut() {
        DispatchQueue.main.async {
            self.auth = nil
            HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
            self.client = self.createClient()
        }
        UserDefaults.standard.removeObject(forKey: "auth")
    }
    
    func setUser(credential: ASAuthorizationAppleIDCredential, authState: String) {
        
        
        DispatchQueue.main.async {
            self.authState = authState

            if authState == "authorized" {
                let request = Authenticate()
                request.provider = "apple"
                request.accessToken = String(decoding:credential.identityToken!, as: UTF8.self)
                request.meta = [
                    "authorizationCode": String(decoding:credential.authorizationCode!, as: UTF8.self),
                    "givenName": credential.fullName?.givenName ?? "",
                    "familyName": credential.fullName?.familyName ?? "",
                ]
                _ = self.client.postAsync(request)
                    .done { r in
                        self.auth = r
                        UserDefaults.standard.set(r.toJson(), forKey: "auth")
                        self.client.bearerToken = r.bearerToken
                        self.client.refreshToken = r.refreshToken
                    }
                    .catch { error in
                        let status:ResponseStatus = error.convertUserInfo()!
                        self.result = "\(status.errorCode ?? ""): \(status.message ?? "")"
                    }
            }
        }
    }
    
    func load() {
        if let authJson = UserDefaults.standard.string(forKey: "auth"),
           let auth = AuthenticateResponse.fromJson(authJson) {
            client.bearerToken = auth.bearerToken
            client.refreshToken = auth.refreshToken
            client.postAsync(Authenticate())
                .done { r in
                    self.auth = auth
                }
                .catch { error in
                    self.client.bearerToken = nil
                    self.client.refreshToken = nil
                    UserDefaults.standard.removeObject(forKey: "auth")
                }
                .finally {
                    self.hasInit = true
                }
        } else {
            self.hasInit = true
        }
    }
}
