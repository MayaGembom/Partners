//
//  MyDataManager.swift
//  Partners
//
//  Created by Maya on 25/06/2022.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class MyDataManager {
    var currentUserUID: String?
    var currentUser:MyUser?
    var currentPhoneNumber:String?
    var currentGroup:Group?
    var grouplistdelegate:Delegate_AddedExpence?
    let storage = Storage.storage()
    var storageRef: StorageReference!
    
    var ref:DatabaseReference!
    
    
    func setCurrentUserUID(uid:String){
        self.currentUserUID = uid
    }
    
    func setCurrentUser(user:MyUser){
        self.currentUser = user
    }
    
    func setCurrentGroup(group:Group) {
        self.currentGroup = group
    }
    
    func setCurrentUserPhone(phone:String){
        self.currentPhoneNumber = phone
    }
    
    func setGroupListDelegate(delegate:Delegate_AddedExpence){
        grouplistdelegate = delegate
    }
    
    
    // --------------------------------------------------------------------------
    func userSnaptoUser(uuid:String, userSnap:Dictionary<String, AnyObject>) -> MyUser {
        let user = MyUser(uuid: uuid, name: userSnap["name"] as! String)
        user.imgUrl = userSnap["imgUrl"] as! String
        let arr = userSnap["groups"] as! NSArray
        user.groups = arr.compactMap({$0 as? String})
        
        return user
    }
    
    func userToDict(user:MyUser) -> [String:Any] {
        let userDic = ["uuid": user.uuid,
                       "name":user.name,
                       "imgUrl": user.imgUrl,
                       "groups":user.groups] as [String:Any]
        return userDic
    }
    
    func groupToDict(group:Group) -> [String:Any] {
        let groupDict = ["uuid":group.uuid,
                         "name":group.name,
                         "imgUrl":group.imgUrl,
                         "expences":group.expences] as [String:Any]
        return groupDict
    }
    
    func expenceToDict(expence:Expence) -> [String:Any] {
        let expenceDict = ["uuid":expence.uuid,
                           "title":expence.title,
                           "paidby":expence.paidby,
                           "date":expence.date,
                           "expence":expence.expence] as [String:Any]
        return expenceDict
    }
    
    func addGroupToDB(group:Group, delegate:Delegate_Stored_In_DB) {
        ref = Database.database().reference()
        
        let groupInfoDict = groupToDict(group:group)
        
        self.ref.child("Groups").child(group.uuid).setValue(groupInfoDict, withCompletionBlock: {err, ref in
            if let error = err {
                print("group was not saved: \(error.localizedDescription)")
            } else {
                print("group saved!")
                delegate.storedSuccessfuly(storedUUid: group.uuid)
            }
        })
    }
    
    func addExpenceToDB(expence:Expence, delegate:Delegate_Stored_In_DB){
        
        ref = Database.database().reference()
        
        let expenceInfoDict = expenceToDict(expence:expence)
        
        ref.child("Expences").child(expence.uuid).setValue(expenceInfoDict, withCompletionBlock: {err, ref in
            if let error = err {
                print("expence was not saved: \(error.localizedDescription)")
            } else {
                print("expence saved!")
                delegate.storedSuccessfuly(storedUUid: expence.uuid)
            }
        })
    }
    
    func updateUserGroupList(delegate:Delegate_Updated_Group_List) {
        ref = Database.database().reference()
        ref.child("users").child(currentUserUID!).updateChildValues(["groups":currentUser?.groups as Any], withCompletionBlock: {(error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be update: \(error).")
            } else {
                print("Data updated Successfully!")
                delegate.updatedSuccessfully()
            }
        })
    }
    
    func updateGroupExpencesList(delegate:Delegate_Updated_Group_List) {
        ref = Database.database().reference()
        ref.child("Groups").child(currentGroup!.uuid).updateChildValues(["expences":currentGroup?.expences as Any], withCompletionBlock: {(error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be update: \(error).")
            } else {
                print("Data updated Successfully!")
                delegate.updatedSuccessfully()

            }
        })
    }
    
    func findUserbyPhone(phoneNumber:String, delegate:Delegate_recieved_Data) {
        
        var userUUID = "nil"
        let rootRef = Database.database().reference()
        
        rootRef.child("phoneToUser").child(phoneNumber).getData(completion: {error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            
            userUUID = snapshot?.value as? String ?? "Unknown"
            
            delegate.dataRecieved(data: userUUID)
        })
        
    }
    
    func uploadImagePic(img1 :UIImage, uuid:String, file:String, delegate: Delegate_Image_Uploaded){
            var data = NSData()
        data = img1.jpegData(compressionQuality: 0.8)! as NSData
            // set upload path
        let filePath = "\(uuid )" // path where you wanted to store img in storage
        let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"

            self.storageRef = storage.reference()
        let userref = self.storageRef.child(file).child(filePath)
        let uploadTask = userref.putData(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                            print(error.localizedDescription)

                            return
                        }
        }
        
        uploadTask.observe(.success) { snapshot in
            userref.downloadURL(completion: {(url:URL?, error:Error?) in
                
                delegate.imageUploaded(imageUrl: url!.absoluteString)
                
            })
        }
 
            
        
        }
    
    
}

protocol Delegate_Stored_In_DB {
    func storedSuccessfuly(storedUUid:String)
}

protocol Delegate_Updated_Group_List{
    func updatedSuccessfully()
}

protocol Delegate_recieved_Data{
    func dataRecieved(data:String)
}

protocol Delegate_AddedExpence{
    func expencesAdded()
}

protocol Delegate_Image_Uploaded {
    func imageUploaded(imageUrl:String?)
}
