import UIKit
import FirebaseDatabase
import Kingfisher


class ExpencesController: UIViewController {
    
    var dataManager:MyDataManager!
    var expences:[Expence]!
    @IBOutlet weak var expences_TBL_expences: UITableView!
    @IBOutlet weak var expences_IMG_groupImage: UIImageView!
    @IBOutlet weak var expences_LBL_groupTitle: UILabel!
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.data
        
        self.title = dataManager.currentGroup?.name
        
        expences_LBL_groupTitle.text = self.title
        
        if let group = dataManager.currentGroup{
        KF.url(URL(string: group.imgUrl))
            .fade(duration: 0.25)
            .cacheMemoryOnly()
            .set(to: expences_IMG_groupImage)
        }
        
        expences_IMG_groupImage.layer.cornerRadius = 75
        
        expences = []
        
        tableViewSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    func tableViewSetup(){
        expences_TBL_expences.register(ExpenceCell.nib(), forCellReuseIdentifier: ExpenceCell.identifier)
        expences_TBL_expences.delegate = self
        expences_TBL_expences.dataSource = self
    }
    
    func fetchData(){
        expences.removeAll()
        let rootRef = Database.database().reference()
        let ref = rootRef.child("Expences")
        
        if let expences_UID = dataManager.currentGroup?.expences{
            for exp in expences_UID {
                ref.child(exp).observe(DataEventType.value, with: {
                    snapshot in
                    if snapshot.exists() {
                        guard let theExp = snapshot.value as? Dictionary<String, AnyObject> else {return}
                        let e = Expence(uuid: snapshot.key, title: theExp["title"] as! String, paidby: theExp["paidby"] as! String, date: theExp["date"] as! String, expence: theExp["expence"] as! Double)
                        
                        self.expences.append(e)
                    }
                    self.expences_TBL_expences.reloadData()
                })
            }
        }   
    }
    
    @IBAction func addExpenceClicked(_ sender: Any) {
        let addExpenceVC = self.storyboard?.instantiateViewController(withIdentifier: "Add_Expence") as! AddNewExpenceController
        
        self.navigationController?.pushViewController(addExpenceVC, animated: true)
    }
    
    @IBAction func addPartnerClicked(_ sender: Any) {
        let addPartnerVC = self.storyboard?.instantiateViewController(withIdentifier: "Add_Partner") as! AddPartnerController
        
        self.navigationController?.pushViewController(addPartnerVC, animated: true)
    }
}

extension ExpencesController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expences_TBL_expences.dequeueReusableCell(withIdentifier: ExpenceCell.identifier) as! ExpenceCell
        
        let expence = expences[indexPath.row]
        
        cell.configure(with: expence.title, paidby: expence.paidby, date: expence.date, expence: "\(expence.expence)")
        
        return cell
        
    }
    
    
}
