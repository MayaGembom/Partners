//
//  MainController.swift
//  Partners
//
//  Created by Maya on 25/06/2022.
//

import UIKit
import FirebaseDatabase


class MainController: UIViewController, Delegate_AddedExpence {

    
    
    var dataManager:MyDataManager!
    var groups: [Group]!
    @IBOutlet weak var main_TBL_tableview: UITableView!
    
    
    override func viewDidLoad() {
        self.title = "Main"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.data
        
        
        var g = Group(uuid: "2355232353", name: "Maya and Gal")
        
        groups = []
        
        groups.append(g)
        
        tableViewSetup()
        
        dataManager.setGroupListDelegate(delegate: self)
        
        //fetchData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    
    func expencesAdded() {
        print("adsaklfjajf")
        fetchData()
    }
    
    func tableViewSetup(){
        main_TBL_tableview.register(GroupCell.nib(), forCellReuseIdentifier: GroupCell.identifier)
        main_TBL_tableview.delegate = self
        main_TBL_tableview.dataSource = self
    }
    
    func fetchData() {
        groups.removeAll()
        let rootRef = Database.database().reference()
        let ref = rootRef.child("Groups")
        
        if let groups_UID = dataManager.currentUser?.groups{
            
            for groupUid in groups_UID{
                ref.child(groupUid).observe(DataEventType.value, with: { snapshot in
                    if snapshot.exists() {
                        guard let theGroup = snapshot.value as? Dictionary<String, AnyObject> else {return}
                        let g = Group(uuid: snapshot.key, name: theGroup["name"] as! String)
                        let arr = theGroup["expences"] as! NSArray
                        g.expences = arr.compactMap({$0 as? String})
                        g.imgUrl = theGroup["imgUrl"] as! String
                        self.groups.append(g)
                    }
                    self.main_TBL_tableview.reloadData()
                })
            }
            
        }
    }
    
    @IBAction func addGroupClicked(_ sender: Any) {
        
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "Add_Group") as! AddNewGroupController
        
        self.navigationController?.pushViewController(addVC, animated: true)
        
    }
}

extension MainController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = main_TBL_tableview.dequeueReusableCell(withIdentifier: GroupCell.identifier) as! GroupCell
        
        cell.configure(with: groups[indexPath.row].name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataManager.setCurrentGroup(group: groups[indexPath.row])
        
        let groupPage = self.storyboard?.instantiateViewController(withIdentifier: "Expences") as! ExpencesController
        
        self.navigationController?.pushViewController(groupPage, animated: true)
    }
    
    
    
}
