import UIKit

class AuthViewController: UIViewController {

    private let authService = AuthService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func authButtonClick(_ sender: Any) {
        authService.wakeUpSession()
    }
}

