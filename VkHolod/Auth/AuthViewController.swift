import UIKit

class AuthViewController: UIViewController {

    private let authService = AuthService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func authButtonClick(_ sender: Any) {
        authService.wakeUpSession()
    }
    
}

