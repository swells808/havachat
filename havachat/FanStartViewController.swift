//
//  FanStartViewController.swift
//  havachat
//
//  Created by Sean Wells on 4/30/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class FanStartViewController: UIViewController, FUIAuthDelegate {
    
    @IBOutlet weak var videoLayer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if Auth.auth().currentUser != nil {
          //
            performSegue(withIdentifier: "FanLoggedInSegue", sender: self)
        }
        
    }
    
  
    
    @IBAction func fanLoginClick(_ sender: UIButton) {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [FUIFacebookAuth(), FUIOAuth.appleAuthProvider()]

        authUI?.providers = providers
        
        let kFirebaseTermsOfService = URL(string: "https://havachat.live/privacy-policy")!
        authUI?.tosurl = kFirebaseTermsOfService
        
        let kFirebasePrivacyPolicy = URL(string: "https://havachat.live/terms-%26-conditions")!
        authUI?.privacyPolicyURL = kFirebasePrivacyPolicy
        
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func whoopsButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "FanBackToStartSegue", sender: self)
    }
    
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
          let loginViewController = FUIAuthPickerViewController(authUI: authUI)
            
    //        loginViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(userBackToStart))
            
            let marginInsets: CGFloat = 16
            let imageHeight: CGFloat = 180
            let imageY = self.view.center.y - imageHeight
            
            let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
            
            let logoImageView = UIImageView(frame: logoFrame)
            logoImageView.image = UIImage(named: "Havachat-Blue")
            logoImageView.contentMode = .scaleAspectFit
            loginViewController.view.addSubview(logoImageView)
        
            loginViewController.view.backgroundColor = UIColor.white
            
            return loginViewController
        }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
            if let error = error {
                assertionFailure("Error signing in: \(error.localizedDescription)")
                return
            }

            guard let user = authDataResult?.user
                else { return }
            let userRef = Database.database().reference().child("users").child(user.uid)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let userDict = snapshot.value as? [String : Any] {
                    self.performSegue(withIdentifier: "FanLoggedInSegue", sender: self)
                } else {
                    self.performSegue(withIdentifier: "FanFirstLoginSegue", sender: self)
                }
            })
        }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
