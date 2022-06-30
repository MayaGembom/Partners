import UIKit
import FirebaseStorage
import FirebaseDatabase
import YPImagePicker


class SignUpController: UIViewController{
    
    var dataManager:MyDataManager!
    let storage = Storage.storage()
    let ref = Database.database().reference()
    
    var myDownloadURL = "https://firebasestorage.googleapis.com/v0/b/superme-e69d5.appspot.com/o/images%2Fimg_profile_pic.JPG?alt=media&token=5970cec0-9663-4ddd-9395-ef2791ad938d"
    
    @IBOutlet weak var signUp_IMG_profile: UIImageView!
    @IBOutlet weak var signUp_TXT_name: UITextField!
    @IBOutlet weak var sugnUp_BTN_signup: UIButton!
    
    override func viewDidLoad() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.data
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpController.imageTapped(gesture:)))
        signUp_IMG_profile.addGestureRecognizer(tapGesture)
        signUp_IMG_profile.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gesture:UIGestureRecognizer){
        
        if (gesture.view as? UIImageView) != nil {
            sugnUp_BTN_signup.isEnabled = false
            var config = YPImagePickerConfiguration()
            config.showsCrop = .circle
            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { [unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    self.signUp_IMG_profile.image = photo.image
                    self.dataManager.uploadImagePic(img1: self.signUp_IMG_profile.image!, uuid: self.dataManager.currentUserUID!, file: "users", delegate: self)
                }
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        guard let username = signUp_TXT_name.text, !username.isEmpty else {
            
            return
        }
        
        let tempUser = MyUser(uuid: dataManager.currentUserUID!, name: username)
        
        tempUser.imgUrl = myDownloadURL

        let userDic = dataManager.userToDict(user: tempUser)
        

        
        ref.child("users").child("\(dataManager.currentUserUID ?? "error")").setValue(userDic, withCompletionBlock: {
            err, ref in
            if let error = err {
                print("user was not saved: \(error.localizedDescription)")
            } else {
                print("user saved")
                self.dataManager.setCurrentUser(user: tempUser)
                self.storeUserNumber()

            }
        })
        
        
    }
    
    func storeUserNumber(){
        ref.child("phoneToUser").child("\(dataManager.currentPhoneNumber! as String)").setValue(dataManager.currentUserUID, withCompletionBlock: {
            err, ref in
            if let error = err {
                print("hone number was not saved: \(error.localizedDescription)")
            } else {
                print("phone number saved")
                let main = self.storyboard?.instantiateViewController(identifier: "main") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = main
                main.modalPresentationStyle = .fullScreen
                self.present(main, animated: true)
            }
        })
    }
    
}



extension SignUpController: Delegate_Image_Uploaded{
    func imageUploaded(imageUrl: String?) {
        sugnUp_BTN_signup.isEnabled = true
        myDownloadURL = imageUrl!
        
    }
    
    
}
