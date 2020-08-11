//
//  TableViewCell.swift
//  iOSTestProject
//
//  Created by Sachin Amrale on 10/08/20.
//  Copyright © 2020 Sachin Amrale. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    // MARK: View Outlets

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
    
    var accountType: AccountType?
    var details: Details?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        if let type = self.accountType{
            if type == .allAccount{
                let topColor = hexStringToUIColor(hex: "#0385C2")
                let bottomColor = hexStringToUIColor(hex: "#023591")
                containerView.layoutSubviews()
//                containerView.addLayerGradientHorizontal(aTopColor: bottomColor.cgColor, aBottomColor: topColor.cgColor)
            }
        }
    }

    func setupUI(aAccountType: AccountType,aDetails: Details?) {
        self.accountType = aAccountType
        self.details = aDetails
        let spentValue = Float(self.details?.spentAmount?.replacingOccurrences(of: "$", with: "") ?? "0")!
        self.spentProgressView.progress = spentValue
        let incomeValue = Float(self.details?.incomeAmount?.replacingOccurrences(of: "$", with: "") ?? "0")!
        self.incomeProgressView.progress = incomeValue
        self.progressViewWidthConstraint.constant = self.incomeProgressView.bounds.width * CGFloat((spentValue / incomeValue))
        incomeProgressView.layer.cornerRadius = 5
        incomeProgressView.clipsToBounds = true
        spentProgressView.layer.cornerRadius = 5
        spentProgressView.clipsToBounds = true
        switch aAccountType {
        case .allAccount:
            imageWidthConstraint.constant = 0
            imageView?.isHidden = true
            nameLabel.textColor = UIColor.white
            amountLabel.textColor = UIColor.white
            spentAmount.textColor = UIColor.white
            incomeAmount.textColor = UIColor.white
            timeLabel.textColor = UIColor.white
            balanceLabel.textColor = UIColor.white
        case .westpac:
            imageWidthConstraint.constant = 20
            imageView?.isHidden = false
            imageView?.image = UIImage(named: "westpacImage")
            imageView?.clipsToBounds = true
            containerView.backgroundColor = .white
            nameLabel.textColor = UIColor.black
            amountLabel.textColor = UIColor.black
            spentAmount.textColor = UIColor.black
            incomeAmount.textColor = UIColor.black
            timeLabel.textColor = UIColor.black
            balanceLabel.textColor = UIColor.black
        case .commbank:
            imageWidthConstraint.constant = 20
            imageView?.isHidden = false
            imageView?.image = UIImage(named: "commbankImage")
            imageView?.clipsToBounds = true
            containerView.backgroundColor = .white
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

