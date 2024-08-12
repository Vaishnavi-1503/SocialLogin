//
//  LoginViewController.swift
//  SocialLogin
//
//  Created by vaishanavi.sasane on 06/08/24.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UITableViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnFacebook: FBLoginButton!
    
    //MARK: Life-Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /// button login action method
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        ValidationCode()
    }
    
    /// button signup action method
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        if let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: controllerNames.signUpViewController) as? SignUpViewController {
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    
    @IBAction func btnGoogleTapped(_ sender: UIButton) {
        // Use the configuration object to sign in
        guard let _ = (UIApplication.shared.delegate as? AppDelegate)?.googleSignInConfig else {
            print("Google Sign-In configuration is missing.")
            return
        }
        // Perform the sign-in
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard let res = result else { return }
            let userId = res.user.userID
            let idToken = res.user.idToken?.tokenString
            let fullName = res.user.profile?.name
            let email = res.user.profile?.email
            
            print("User ID: \(userId ?? "No ID")")
            print("ID Token: \(idToken ?? "No Token")")
            print("Full Name: \(fullName ?? "No Name")")
            print("Email: \(email ?? "No Email")")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
}

/// LoginButtonDelegate Methods
extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: (any Error)?) {
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture"], tokenString: token, version: nil, httpMethod: .get)
        
        request.start { connection, result, error in
            debugPrint("\(result ?? "")")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        debugPrint("logout")
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableViewHeight = self.tableView.frame.height
        let contentHeight = self.tableView.contentSize.height
        
        let centeringInset = (tableViewHeight - contentHeight) / 2.0
        let topInset = max(centeringInset, 0.0)
        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    /// Validation of fields
    fileprivate func ValidationCode() {
        if let email = txtEmail.text, let password = txtPassword.text{
            if !email.validateEmailId(){
                openAlert(title: AlertTitles.alertTitle, message: ValidationErrors.noEmailFound, alertStyle: .alert, actionTitles: [ActionTitles.okayTitle], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                }])
            }else if !password.validatePassword(){
                openAlert(title: AlertTitles.alertTitle, message: ValidationErrors.invalidPassword, alertStyle: .alert, actionTitles: [ActionTitles.okayTitle], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                }])
            }else{
                // Navigation - Home Screen
            }
        } else {
            openAlert(title: AlertTitles.alertTitle, message: ValidationErrors.pendingDetails, alertStyle: .alert, actionTitles: [ActionTitles.okayTitle], actionStyles: [.default], actions: [{ _ in
                print("Okay clicked!")
            }])
        }
    }
}
