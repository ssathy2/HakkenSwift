//
//  ViewController.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit

protocol IBInstantiable {
    static func storyboardName() -> String
    static func identifier() -> String
}

protocol ViewControllerInstantiable: IBInstantiable {
    static func instance() -> UIViewController
}

extension UIViewController: ViewControllerInstantiable {
    class func storyboardName() -> String { return "" }
    class func identifier() -> String { return "" }
    class func instance() -> UIViewController {
        return UIStoryboard(name: UIViewController.storyboardName(), bundle: nil).instantiateViewController(withIdentifier: UIViewController.identifier())
    }
}

protocol DataUpdatable {
    func update(data: AnyObject?)
}

class ViewController: UIViewController, DataUpdatable {
    var viewModel: ViewModel?
    var router: Router?
    
    override class func instance() -> ViewController {
        return UIStoryboard(name: self.storyboardName(), bundle: nil).instantiateViewController(withIdentifier: self.identifier()) as! ViewController
    }
    
    func update(data: AnyObject?) { }
    
    func segueIdentifierToContainerViewControllerMapping() -> [String: String]? { return nil }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let identifierMapping = segueIdentifierToContainerViewControllerMapping(), let segueIdentifier = segue.identifier else {
            return
        }
        guard let path = identifierMapping[segueIdentifier] else {
            print("This segue identifier doesn't contain a mapping! Make sure segue identifier exists in the storyboard")
            return
        }
        setValue(segue.destination, forKeyPath: path)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewModelDidLoad()
    }
}
