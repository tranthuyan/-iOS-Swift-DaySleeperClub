//
//  MemberTable.swift
//  DaySleepersClub
//
//  Created by lydia on 6/4/18.
//  Copyright © 2018 lydia. All rights reserved.
//

import UIKit
import os.log

enum KindOfPush:String {
    case addItem = "AddItem"
    case showDetail = "ShowDetail"
    case def = ""
}

class MemberTable: UITableViewController {
    
    //MARK: Properties
    var members = [MemberClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Member List"
        
        if let savedMember = loadMembers() {
            members += savedMember
        }
        else {
            // Load the sample data.
            loadSampleMember()
        }
        
        if members.count == 0 {
            loadSampleMember()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return members.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cellIdentifier = "MemberTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MemberCell  else {
            fatalError("The dequeued cell is not an instance of MemberCell.")
        }
        
        // Fetches the appropriate mem for the data source layout.
        let mem = members[indexPath.row]
        
        cell.nameLabel.text = mem.name
        cell.teamLabel.text = "Team: \(mem.team)"
        cell.descriptionLabel.text = mem.descriptions
        cell.photoImageView.image = mem.photo
        cell.ratingSleep.rating = mem.rating
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            members.remove(at: indexPath.row)
            saveMembers()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let kind = KindOfPush(rawValue: segue.identifier ?? "")!
        switch(kind) {
            
        case KindOfPush.addItem:
            os_log("Adding a new member.", log: OSLog.default, type: .debug)
            
        case KindOfPush.showDetail:
            guard let memberDetailViewController = segue.destination as? MemberViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMemberCell = sender as? MemberCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMemberCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMember = members[indexPath.row]
            memberDetailViewController.member = selectedMember
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        saveMembers()
        let startview = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
        self.present(startview, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMemberList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MemberViewController, let newmem = sourceViewController.member {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing member.
                members[selectedIndexPath.row] = newmem
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new member.
                let newIndexPath = IndexPath(row: members.count, section: 0)
                members.append(newmem)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            MemberClass.saveMembers(member: members)
        }
    }
    
    // MARK: Private Methods
    private func loadSampleMember() {
        let sample00 = MemberClass(photo: #imageLiteral(resourceName: "image"), name: "Kean", team: "IOS", descriptions: "Sleep all day - Party all night!", rating: 3)
        
        let sample01 = MemberClass(photo: #imageLiteral(resourceName: "image1"), name: "Layla", team: "Tester", descriptions: "Cool kids neva sleep!", rating: 2)
        members += [sample01!, sample00!]
    
    }
    // Archiving
    private func saveMembers() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(members, toFile: MemberClass.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Saved!", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save!", log: OSLog.default, type: .error)
        }
    }
    
   // Unarchiving
    private func loadMembers() -> [MemberClass]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: MemberClass.ArchiveURL.path) as? [MemberClass]
    }

}
