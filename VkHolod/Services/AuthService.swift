import Foundation
import VK_ios_sdk

protocol AuthServiceDelegate: class {
    func authServiceShouldShow(_ viewController: UIViewController)
    func authServiceSignIn()
    func authServiceDidSignInFail()
}

final class AuthService: NSObject{
    
    // MARK: Properties
    
    private let appId = "7287443"
    private let vkSdk : VKSdk
    static var shared : AuthService = AuthService()
    weak var delegate: AuthServiceDelegate?
    var token : String?{
        return VKSdk.accessToken()?.accessToken!
    }
    
    // MARK: Methods
    
    private override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("vksdk init")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["wall","friends"]
        VKSdk.wakeUpSession(scope) { [delegate] (state, error) in
            switch (state) {
            case .initialized:
                print("VKAuthorizationState.initialized")
                VKSdk.authorize(scope)
            case .authorized:
                print("VKAuthorizationState.authorized")
                delegate?.authServiceSignIn()
            case .error:
                print("Something went wrong.. error: \(String(describing: error))")
                delegate?.authServiceDidSignInFail()
            default:
                break
            }
        }
    }
}

extension AuthService: VKSdkDelegate,VKSdkUIDelegate {
    
    // MARK: VkSdkDelegate
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
        delegate?.authServiceSignIn()
        }
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
    
    // MARK: VkSdkUIDelegate
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
