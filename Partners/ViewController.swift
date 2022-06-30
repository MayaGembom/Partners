//
//  ViewController.swift
//  Partners
//
//  Created by Maya on 25/06/2022.
//

import UIKit
import FirebaseAuthUI
import FirebasePhoneAuthUI
import FirebaseDatabase


class ViewController: UIViewController, FUIAuthDelegate {
    
    var dataManager:MyDataManager!
    let authUI = FUIAuth.defaultAuthUI()
    var ref = Database.database().reference()

    @IBOutlet weak var login_BTN_login: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.data
        checkLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    
    func checkLogin(){
        Auth.auth().addStateDidChangeListener{ [self] (auth, user) in
            if let user = user {
                print("Logged in with: \(user.uid)")
                dataManager.setCurrentUserUID(uid: user.uid)
                dataManager.setCurrentUserPhone(phone: user.phoneNumber!)
                checkUserInDB(user.uid)
                
                
            } else {
                let providers: [FUIAuthProvider] = [FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!)]
                self.authUI?.providers = providers
                self.authUI?.delegate = self
            }
            
        }
    }

    @IBAction func loginPressed(_ sender: Any) {
        let phoneProvider = FUIAuth.defaultAuthUI()!.providers.first as! FUIPhoneAuth
        phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        print("Success")
    }
    
    func checkUserInDB(_ uid:String){
        
        
        ref.child("users").observe(DataEventType.value, with: { (snapshot) in
            if snapshot.hasChild(uid) {
                self.dataManager.setCurrentUserUID(uid: uid)
                
                guard let userSnap = snapshot.childSnapshot(forPath: uid).value as? Dictionary<String,AnyObject> else {return}
                
                let user = self.dataManager.userSnaptoUser(uuid: uid, userSnap:userSnap)
                
                self.dataManager.setCurrentUser(user: user)
                
                let main = self.storyboard?.instantiateViewController(identifier: "main") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = main
                main.modalPresentationStyle = .fullScreen
                self.present(main, animated: true)
                
            } else {
                let signUp = self.storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpController
                self.present(signUp, animated: true)
            }
        }
        )
    }
}

