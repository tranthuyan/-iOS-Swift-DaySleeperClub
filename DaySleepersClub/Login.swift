//
//  Login.swift
//  DaySleepersClub
//
//  Created by lydia on 6/4/18.
//  Copyright © 2018 lydia. All rights reserved.
//

import UIKit
//import Alamofire

struct Country:Decodable {
    let name:String
    let capital:String
}

class Login: UIViewController {
    // alamofire
    var countries = [Country]()
    
    @IBOutlet weak var alert: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
    }
        
        // MARK: Alamofire Test
     /*   guard let url = URL(string: "https://restcountries.eu/rest/v2/all") else {return}
        Alamofire.request(url).responseJSON { (response) in
            let dataresult = response.data
            
            switch response.result{
            case .success:
                guard let result = dataresult else {return}
                do {
                    self.countries = try JSONDecoder().decode([Country].self, from: result)
                    for country in self.countries {
                        print(country.name)
                    }
                } catch {
                    print("Error")
                }
            case .failure:
                break;
            }
            
        }*/
    

    @IBAction func loginButton(_ sender: UIButton) {
        if username.text == "admin", password.text == "123" {
            let tableview = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberTableViewNav")
            self.present(tableview, animated: true, completion: nil)
        } else {
            alert.text = "Wrong username or password !"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
