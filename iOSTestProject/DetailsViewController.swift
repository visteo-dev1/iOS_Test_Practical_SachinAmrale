//
//  DetailsViewController.swift
//  iOSTestProject
//
//  Created by Sachin Amrale on 11/08/20.
//  Copyright © 2020 Sachin Amrale. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    //MARK: View Outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var details: [Details]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
    }
    
    @objc func backButtonClicked(){
        dismiss(animated: true)
    }
}

//MARK: Tableview delegate and datasource

extension DetailsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return details?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
        cell.nameLabel.text = details?[indexPath.row].title
        cell.amountLabel.text = details?[indexPath.row].balance
        cell.spentAmount.text = details?[indexPath.row].spentAmount
        cell.incomeAmount.text = details?[indexPath.row].incomeAmount

        if details?[indexPath.row].time == ""{
            cell.refreshImageView.isHidden = true
        }else{
            cell.refreshImageView.isHidden = false
        }
        cell.timeLabel.text = details?[indexPath.row].time
        return cell
    }
}

