//
//  ViewController.swift
//  iOSTestProject
//
//  Created by Sachin Amrale on 09/08/20.
//  Copyright © 2020 Sachin Amrale. All rights reserved.
//

import UIKit
import MMBannerLayout
import AdvancedPageControl

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
    
    @IBOutlet weak var pageController: AdvancedPageControlView!
    @IBOutlet weak var housholdView: MoneySpentView!
    @IBOutlet weak var restuarantView: MoneySpentView!
    @IBOutlet weak var groceryView: MoneySpentView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    var userEvent: UserEvent?
    var accountDetails: [AccountDetails]?
    var selectedCell: CollectionViewCell?
    var selectedCellImageViewSnapshot: UIView?
    var animator: PopAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.parseData()

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
             layout.itemSize = CGSize(width: collectionView.frame.width + 15, height: collectionView.frame.height)  //
            layout.minimuAlpha = 1
        }
        
        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
        
        pageController.drawer = ExtendedDotDrawer(numberOfPages: 3, space: 8, raduis: 16, height: 8, width: 8, currentItem: 0, dotsColor: .lightGray, isBordered: false, borderColor: .clear, borderWidth: 0)
        pageController.numberOfPages = 3

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
        
        selectedCell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        selectedCellImageViewSnapshot = selectedCell?.backgroundImageView.snapshotView(afterScreenUpdates: false)
        if indexPath.row != 2 {
            presentSecondViewController(aIndexPth: indexPath)
        }
    }
    
    func presentSecondViewController(aIndexPth: IndexPath) {
        let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        secondViewController.transitioningDelegate = self
        switch aIndexPth.row {
        case 0:
            secondViewController.details = accountDetails?[aIndexPth.row].allAccount
            secondViewController.accountType = .allAccount
        case 1:
            secondViewController.details = accountDetails?[aIndexPth.row].westpac
            secondViewController.accountType = .westpac
        default:
            secondViewController.details = accountDetails?[aIndexPth.row].westpac
        }
        secondViewController.modalPresentationStyle = .fullScreen
        present(secondViewController, animated: true)
    }
    
    //MARK: ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        pageController.setCurrentItem(offset: CGFloat(offSet),width: CGFloat(width))
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


extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let firstViewController = presenting as? ViewController,
            let secondViewController = presented as? DetailsViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        else { return nil }

        animator = PopAnimator(type: .present, firstViewController: firstViewController, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let secondViewController = dismissed as? DetailsViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        else { return nil }

        animator = PopAnimator(type: .dismiss, firstViewController: self, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }
}


