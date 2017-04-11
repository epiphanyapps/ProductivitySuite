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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let gifController = segue.destination as? GIFsViewController {
            gifController.managedObjectContext = SharedDataManager.managedObjectContext
            gifController.fetchedResultsController = GIF.fetchedResultsController(context: SharedDataManager.managedObjectContext)
        }
        
    }


}
