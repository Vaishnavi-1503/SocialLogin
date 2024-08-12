//
//  SignUpViewController.swift
//  SocialLogin
//
//  Created by vaishanavi.sasane on 06/08/24.
//

import UIKit

class SignUpViewController: UITableViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtConPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    
    //MARK: Life-Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgProfile.addGestureRecognizer(tapGesture)
    }
    
    /// Button login - Action
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Button Signup - Action
    @IBAction func btnSignUpTapped(_ sender: Any) {
        let imgSystem = UIImage(systemName: imageNames.imageBadge)
        
        if imgProfile.image?.pngData() != imgSystem?.pngData(){
            // profile image selected
            if let email = txtEmail.text, let password = txtPassword.text, let username = txtUserName.text, let conPassword = txtConPassword.text {
                if username == "" {
                    print("Please enter username")
                } else if !email.validateEmailId() {
                    openAlert(title: AlertTitles.alertTitle, message: ValidationErrors.invalidEmail, alertStyle: .alert, actionTitles: [ActionTitles.okayTitle], actionStyles: [.default], actions: [{_ in }])
                    print("email is not valid")
                } else if !password.validatePassword() {
                    print("Password is not valid")
                } else {
                    if conPassword == "" {
                        print("Please confirm password")
                    } else {
                        if password == conPassword {
                            // navigation code
                            print("Navigation code done")
                        }else{
                            print("password does not match")
                        }
                    }
                }
            } else {
                print("Please check your details")
            }
        } else {
            print("Please select profile picture")
            openAlert(title: AlertTitles.alertTitle, message: ValidationErrors.noProfile, alertStyle: .alert, actionTitles: [ActionTitles.okayTitle], actionStyles: [.default], actions: [{_ in }])
        }
    }
}

/// Delegate Methods
extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /// Open gallery
    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        openGallery()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableViewHeight = self.tableView.frame.height
        let contentHeight = self.tableView.contentSize.height
        
        let centeringInset = (tableViewHeight - contentHeight) / 2.0
        let topInset = max(centeringInset, 0.0)
        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage{
            imgProfile.image = img
        }
        dismiss(animated: true)
    }
}
