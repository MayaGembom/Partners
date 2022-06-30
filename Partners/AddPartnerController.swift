//
//  AddPartner.swift
//  Partners
//
//  Created by Maya on 28/06/2022.
//

import UIKit
import FirebaseDatabase

class AddPartnerController: UIViewController {
    
    var dataManager:MyDataManager!

    @IBOutlet weak var partner_TXT_phoneNumber: UITextField!
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.data
    }
    
    
    @IBAction func AddPartnerClicked(_ sender: Any) {
        dataManager.findUserbyPhone(phoneNumber: partner_TXT_phoneNumber.text!, delegate: self)
    }
    
    
}

extension AddPartnerController: Delegate_recieved_Data{
    func dataRecieved(data: String) {
        print("found: \(data)")
        let ref = Database.database().reference()
        ref.child("users").child(data).observeSingleEvent(of: DataEventType.value, with: { snapshot in
            if snapshot.exists() {
            guard let g = snapshot.value as? Dictionary<String, AnyObject> else {return}
            
            let arr = g["groups"] as! NSArray
            let mmap = arr.compactMap({$0 as? String})
            
            
            let i = mmap.count

            
            print("counter : \(i)")
            self.updateGroup(data: data, key: "\(i+1)")
        
            }
            
        })
//        childByAutoId().setValue(dataManager.currentGroup?.uuid, withCompletionBlock: {(error:Error?, ref:DatabaseReference) in
//            if let error = error {
//                print("Data could not be update: \(error).")
//            } else {
//                print("Data updated Successfully!")
//                self.navigationController?.popViewController(animated: true)
//
//            }
//        })
    }
    
    func updateGroup(data:String, key:String){
        let ref = Database.database().reference()
        ref.child("users").child(data).child("groups").child(key).setValue(dataManager.currentGroup?.uuid, withCompletionBlock: {(error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            print("Data could not be update: \(error).")
                        } else {
                            print("Data updated Successfully!")
                            self.navigationController?.popViewController(animated: true)
            
                        }
                    })
    }
    
    
}
