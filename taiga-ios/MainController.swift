//
//  MainController.swift
//  taiga-ios
//
//  Created by Rhonan Carneiro on 21/10/15.
//  Copyright © 2015 Taiga. All rights reserved.
//

import UIKit
import Alamofire

class MainController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    var hostname: String!
    var projects = [Project]()
    
    override func viewDidLoad() {
        let LIST_PROJECTS_URL = hostname + "/api/v1/projects"
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        print("Listing projects using this auth token: \(user.authToken!) 😎")
        let headers = ["Authorization": "Bearer \(user.authToken!)"]
        Alamofire.request(.GET, LIST_PROJECTS_URL + "?member=\(user.id!)", headers: headers, encoding: .JSON).responseCollection { (response: Response<[Project], NSError>) in
            let projects: [Project] = response.result.value! as [Project]
            if !projects.isEmpty {
                print("There are some projects to show")
                self.projects.appendContentsOf(projects)
                self.tableView.reloadData()
            } else {
                print("No projects to show")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func setUser(user: User){
        self.user = user
    }
    
    func setServerHost(hostname: String){
        self.hostname = hostname
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath)
        cell.textLabel!.text = projects[indexPath.row].name
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Project name: " + projects[indexPath.row].name!)
        print("Project description: " + projects[indexPath.row].description!)
    }
}
    