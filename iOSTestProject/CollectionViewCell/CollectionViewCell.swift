//
//  CollectionViewCell.swift
//  iOSTestProject
//
//  Created by Sachin Amrale on 10/08/20.
//  Copyright © 2020 Sachin Amrale. All rights reserved.
//

import UIKit

protocol UserEventProtocol: class{
    func updateUserEvent(aTitle: String)
}

enum UserEvent{
    case expand
    case collapse
}

enum AccountType{
    case allAccount
    case westpac
    case commbank
}

class CollectionViewCell: UICollectionViewCell {

    //MARK: View Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var progressViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var refreshImageView: UIImageView!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var accountImageView: UIImageView!
    @IBOutlet var spentProgressView: UIProgressView!
    @IBOutlet var incomeProgressView: UIProgressView!
    @IBOutlet var spentView: UIView!
    @IBOutlet var spentAmount: UILabel!
    @IBOutlet var incomeView: UIView!
    @IBOutlet var incomeAmount: UILabel!
    @IBOutlet var imageWidthConstraint: NSLayoutConstraint!
    
    weak var delegate: UserEventProtocol? = nil
    var accountType: AccountType?
    var userEvent: UserEvent?
    var details: [Details]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 10
        self.incomeProgressView.layer.cornerRadius = 5
        self.incomeProgressView.clipsToBounds = true
        self.spentProgressView.layer.cornerRadius = 5
        self.spentProgressView.clipsToBounds = true
        
        self.spentView.layer.cornerRadius = self.spentView.bounds.width / 2
        self.spentView.clipsToBounds = true
        self.incomeView.layer.cornerRadius = self.incomeView.bounds.width / 2
        self.incomeView.clipsToBounds = true
        // Initialization code
    }
    
    func setupUI(aType: AccountType,aDetails: Details) {
        let spentValue = Float(aDetails.spentAmount?.replacingOccurrences(of: "$", with: "") ?? "0")!
        self.spentProgressView.progress = spentValue
        let incomeValue = Float(aDetails.incomeAmount?.replacingOccurrences(of: "$", with: "") ?? "0")!
        self.incomeProgressView.progress = incomeValue
        self.progressViewWidthConstraint.constant = self.incomeProgressView.bounds.width * CGFloat((spentValue / incomeValue))
        
        self.nameLabel.text = aDetails.title
        self.amountLabel.text = aDetails.balance
        self.spentAmount.text = (aDetails.spentAmount ?? "") + " Spent"
        self.incomeAmount.text = (aDetails.incomeAmount ?? "") + " Income"
        if aDetails.time == ""{
            self.refreshImageView.isHidden = true
        }else{
            self.refreshImageView.isHidden = false
        }
        self.timeLabel.text = aDetails.time
        
        switch aType {
        case .allAccount:
            imageWidthConstraint.constant = 0
            accountImageView?.isHidden = true
            backgroundImageView.image = UIImage(named: "blueBG")
            nameLabel.textColor = UIColor.white
            amountLabel.textColor = UIColor.white
            spentAmount.textColor = UIColor.white
            incomeAmount.textColor = UIColor.white
            timeLabel.textColor = UIColor.white
            balanceLabel.textColor = UIColor.white
        case .westpac:
            imageWidthConstraint.constant = 20
            accountImageView?.isHidden = false
            accountImageView?.image = UIImage(named: "westpacImage")
            backgroundImageView.image = UIImage(named: "whiteBG")
            accountImageView?.clipsToBounds = true
            nameLabel.textColor = UIColor.black
            amountLabel.textColor = UIColor.black
            spentAmount.textColor = UIColor.black
            incomeAmount.textColor = UIColor.black
            timeLabel.textColor = UIColor.black
            balanceLabel.textColor = UIColor.black
        case .commbank:
            imageWidthConstraint.constant = 20
            accountImageView?.isHidden = false
            accountImageView?.image = UIImage(named: "commbankImage")
            backgroundImageView.image = UIImage(named: "whiteBG")
            accountImageView?.clipsToBounds = true
            nameLabel.textColor = UIColor.black
            amountLabel.textColor = UIColor.black
            spentAmount.textColor = UIColor.black
            incomeAmount.textColor = UIColor.black
            timeLabel.textColor = UIColor.black
            balanceLabel.textColor = UIColor.black
        default:
            print("default")
        }
    }
}

