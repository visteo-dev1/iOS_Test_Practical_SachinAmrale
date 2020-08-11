//
//  ViewController.swift
//  iOSTestProject
//
//  Created by Sachin Amrale on 09/08/20.
//  Copyright © 2020 Sachin Amrale. All rights reserved.
//

import UIKit
import MMBannerLayout

class ViewController: UIViewController {

    //MARK: View Outlets
    
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var stackContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dropMenuContainerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var housholdView: MoneySpentView!
    @IBOutlet weak var restuarantView: MoneySpentView!
    @IBOutlet weak var groceryView: MoneySpentView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    var userEvent: UserEvent?
    var accountDetails: [AccountDetails]?
    let transition = PopAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.parseData()
        
        transition.dismissCompletion = { [weak self] in
          guard
            let selectedIndexPathCell = self?.collectionView.indexPathsForSelectedItems?.first,
            let selectedCell = self?.collectionView.cellForItem(at: selectedIndexPathCell)
              as? CollectionViewCell
            else {
              return
          }
//          selectedCell.shadowView.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    func parseData(){
        if let path = Bundle.main.path(forResource: "Data", ofType: "json") {
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(BankDetails.self, from: data)
                if let data = responseData.data{
                    self.accountDetails = data
                    self.collectionView.reloadData()
                }
            }catch {
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.userEvent = .collapse
    }

    func setupUI(){
        self.containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        self.headerLabel.text = "Home"
        
        self.dropMenuContainerView.layoutIfNeeded()
        self.dropMenuContainerView.layer.cornerRadius = 17
        self.dropMenuContainerView.clipsToBounds = true
        
        self.stackContainerView.layoutIfNeeded()
        self.stackContainerView.layer.cornerRadius = 10
        
        self.buttonsContainerView.layoutIfNeeded()
        self.buttonsContainerView.layer.cornerRadius = 30
        
        
        self.groceryView.amountLabel.text = "$653"
        self.groceryView.nameLabel.text = "Groceries"
        self.groceryView.imageView.image = UIImage(named: "grocery")
        
        self.restuarantView.amountLabel.text = "$405"
        self.restuarantView.nameLabel.text = "Restuarants"
        self.restuarantView.imageView.image = UIImage(named: "restuarent")
        
        self.housholdView.amountLabel.text = "$201"
        self.housholdView.nameLabel.text = "Household"
        self.housholdView.imageView.image = UIImage(named: "household")
        
        self.backButton.isHidden = true
        self.backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if let layout = collectionView.collectionViewLayout as? MMBannerLayout {
            layout.itemSpace = 15
//            layout.itemSize = collectionView.frame.insetBy(dx: 0, dy: 0).size
             layout.itemSize = CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height)  //
            layout.minimuAlpha = 1
        }
        
        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")

    }
    
    @objc func backButtonClicked(){
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveLinear, animations: {
        }) { (finished) in
            self.headerLabel.text = "Home"
            self.backButton.isHidden = true
            self.userEvent = .collapse
            self.collectionView.isScrollEnabled = true
            self.collectionViewHeightConstraint.constant = 220
            self.collectionView.reloadData()
        }
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

//MARK: Collection view delegates and datasource
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.accountDetails?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! CollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell.setupUI(aType: .allAccount, aDetails: (self.accountDetails?[indexPath.row].allAccount?.first)!)
        case 1:
            cell.setupUI(aType: .westpac, aDetails: (self.accountDetails?[indexPath.row].westpac?.first)!)
        case 2:
            cell.setupUI(aType: .commbank, aDetails: (self.accountDetails?[indexPath.row].commbank?.first)!)
        default:
            print("default")
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailsViewController") as! DetailsViewController
        switch indexPath.row {
        case 0:
            viewController.details = self.accountDetails?[indexPath.row].allAccount
        case 1:
            viewController.details = self.accountDetails?[indexPath.row].westpac
        case 2:
            viewController.details = self.accountDetails?[indexPath.row].commbank
        default:
            viewController.details = self.accountDetails?[indexPath.row].allAccount
        }
        viewController.transitioningDelegate = self
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
}

extension UIView{
    func addLayerGradientHorizontal(aTopColor: CGColor,aBottomColor: CGColor) {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.bounds = self.bounds
        layer.frame.origin = CGPoint(x: 0.0, y: 0.0)
        layer.colors = [aTopColor, aBottomColor]
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(layer, at: 0)
        self.layoutIfNeeded()
    }
}

//extension ViewController: UserEventProtocol{
//
////    func updateUserEvent(aTitle: String) {
////        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveLinear, animations: {
////        }) { (finished) in
////            self.headerLabel.text = aTitle
////            self.backButton.isHidden = false
////            self.userEvent = .expand
////            self.collectionViewHeightConstraint.constant = 220 * 3
////            self.collectionView.reloadData()
////            self.collectionView.isScrollEnabled = false
////        }
////    }
//}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(
      forPresented presented: UIViewController,
      presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            guard
                let selectedIndexPathCell = collectionView.indexPathsForSelectedItems?.first,
                let selectedCell = collectionView.cellForItem(at: selectedIndexPathCell) as? CollectionViewCell,
              let selectedCellSuperview = selectedCell.superview
              else {
                return nil
            }

            transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
            transition.originFrame = CGRect(
              x: transition.originFrame.origin.x + 20,
              y: transition.originFrame.origin.y + 20,
              width: transition.originFrame.size.width - 40,
              height: transition.originFrame.size.height - 40
            )

            transition.presenting = true
//            selectedCell.shadowView.isHidden = true
            
            return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
      transition.presenting = false
      return transition
    }
}

