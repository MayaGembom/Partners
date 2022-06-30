//
//  AddNewGroupController.swift
//  Partners
//
//  Created by Maya on 28/06/2022.
//

import UIKit
import YPImagePicker

class AddNewGroupController: UIViewController, Delegate_Stored_In_DB, Delegate_Updated_Group_List{

    var dataManager:MyDataManager?
    var uuid:String?
    
    @IBOutlet weak var cGroup_TXT_gName: UITextField!
    @IBOutlet weak var cGroup_IMG_cover: UIImageView!
    @IBOutlet weak var cGroup_BTN_create: UIButton!
    
    var myDownloadURL = "https://firebasestorage.googleapis.com/v0/b/superme-e69d5.appspot.com/o/images%2Fimg_profile_pic.JPG?alt=media&token=5970cec0-9663-4ddd-9395-ef2791ad938d"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.data
        
        uuid = NSUUID().uuidString
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddNewGroupController.imageTapped(gesture:)))
        cGroup_IMG_cover.addGestureRecognizer(tapGesture)
        cGroup_IMG_cover.isUserInteractionEnabled = true
        
    }
    
    @objc func imageTapped(gesture:UIGestureRecognizer){
        
        if (gesture.view as? UIImageView) != nil {
            cGroup_BTN_create.isEnabled = false
            let picker = YPImagePicker()
            picker.didFinishPicking { [unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    self.cGroup_IMG_cover.image = photo.image
                    self.dataManager?.uploadImagePic(img1: self.cGroup_IMG_cover.image!, uuid: self.uuid!, file: "Groups", delegate: self)
                }
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func createGroupClicked(_ sender: Any) {
        
        guard let groupName = cGroup_TXT_gName.text, !groupName.isEmpty else {
            return
        }
        
        let group = Group(uuid: uuid!, name: groupName)
        
        group.imgUrl = myDownloadURL
        
        dataManager?.addGroupToDB(group: group, delegate: self)
    }
    
    func storedSuccessfuly(storedUUid: String) {
        
        dataManager?.currentUser?.groups.append(storedUUid)
        dataManager?.updateUserGroupList(delegate: self)
        
    }
    
    func updatedSuccessfully() {
        navigationController?.popViewController(animated: true)
  
    }
    
    
}

extension AddNewGroupController: Delegate_Image_Uploaded {
    func imageUploaded(imageUrl: String?) {
        cGroup_BTN_create.isEnabled = true
        myDownloadURL = imageUrl!

    }
    
}
