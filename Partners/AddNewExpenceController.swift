//
//  AddNewExpenceController.swift
//  Partners
//
//  Created by Maya on 28/06/2022.
//

import UIKit

class AddNewExpenceController: UIViewController {
    
    var dataManager:MyDataManager?
    
    @IBOutlet weak var expence_TXT_description: UITextField!
    @IBOutlet weak var expence_TXT_amount: UITextField!
    @IBOutlet weak var expence_TXT_percent: UITextField!
    @IBOutlet weak var expence_TXT_date: UIDatePicker!
    
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.data
    }
    
    @IBAction func addExpenceClicked(_ sender: Any) {
        
        guard let title = expence_TXT_description.text, !title.isEmpty else {
            return
        }
        
        guard let amount = expence_TXT_amount.text, !amount.isEmpty else {
            return
        }
        
        guard let percent = expence_TXT_percent.text, !percent.isEmpty else {
            return
        }
        
        let amountDouble = Double(amount)!
        let percentInt = Double(percent)!
        let calc = (amountDouble * percentInt)/100
        
        let theDate = expence_TXT_date.date.formatted()
        
        
        let expence = Expence(uuid: NSUUID().uuidString, title: title, paidby: dataManager?.currentUser?.name ?? "nil", date: theDate, expence: calc)
        
        dataManager!.addExpenceToDB(expence: expence, delegate:self)
        
    }
    
}

extension AddNewExpenceController: Delegate_Stored_In_DB, Delegate_Updated_Group_List {
    
    func storedSuccessfuly(storedUUid: String) {
        dataManager?.currentGroup?.expences.append(storedUUid)
        dataManager?.updateGroupExpencesList(delegate:self)
    }
    
    func updatedSuccessfully() {
        navigationController?.popViewController(animated: true)
    }
    
}
