//
//  ShellViewController.swift
//  ProductivitySuite
//
//  Created by Walter Vargas-Pena on 3/26/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ProductivitySuite

class ShellViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showUsers("")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var showUsers: UIButton!
    
    @IBAction func showUsers(_ sender: Any) {
        let userVC = UsersViewController()
        navigationController?.pushViewController(userVC, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let todoController = segue.destination as? TodoTableViewController {
            todoController.managedObjectContext = SharedDataManager.managedObjectContext
        }
        
    }


}
