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
    
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var dropMenuContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var details: [Details]?
    var accountType: AccountType?
    
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
        self.containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        self.backgroundView.layer.cornerRadius = 20
        self.backgroundView.clipsToBounds = true
        
        self.dropMenuContainerView.layoutIfNeeded()
        self.dropMenuContainerView.layer.cornerRadius = 17
        self.dropMenuContainerView.clipsToBounds = true
        
        self.buttonContainerView.layoutIfNeeded()
        self.buttonContainerView.layer.cornerRadius = 30
        self.buttonContainerView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.headerLabel.text = details?.first?.title
        self.tableView.reloadData()
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
        return 200
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
        cell.nameLabel.text = details?[indexPath.row].title
        cell.amountLabel.text = details?[indexPath.row].balance
        cell.spentAmount.text = (details?[indexPath.row].spentAmount ?? "") + " Spent"
        cell.incomeAmount.text = (details?[indexPath.row].incomeAmount ?? "") + " Income"
        if self.accountType == AccountType.allAccount{
            self.backgroundImageView.image = UIImage(named: "blueBG")
        }else{
            self.backgroundImageView.image = UIImage(named: "whiteBG")
        }
        if details?[indexPath.row].time == ""{
            cell.refreshImageView.isHidden = true
        }else{
            cell.refreshImageView.isHidden = false
        }
        cell.timeLabel.text = details?[indexPath.row].time
        if let type = self.accountType,let details = self.details?[indexPath.row]{
            cell.setupUI(aAccountType: type, aDetails: details)
        }
        
        if indexPath.row == 0{
            cell.balanceLabel.isHidden = false
        }else{
            cell.balanceLabel.isHidden = true
        }
        
        if indexPath.row == 2{
            cell.saperatorView.isHidden = true
        }else{
            cell.saperatorView.isHidden = false
        }
        
        return cell
    }
}

