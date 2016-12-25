//
//  Router.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/25/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit

enum RouterError: Error {
    case NoNavigationControllerFound
    case NoMasterNavigationControllerSetup
    case NoDetailNavigationControllerSetup
    case NoViewImplementationFoundForView(String)
}

class Router {
    var masterNavigationController: UINavigationController?
    var detailNavigationController: UINavigationController?
    var viewControllerMap: [String: ViewController.Type]?
    
    init(splitViewController: UISplitViewController, viewControllerMap: [String: ViewController.Type]) {
        if splitViewController.viewControllers.count == 0 {
            return
        }
        
        if splitViewController.viewControllers.count >= 1 {
            if let masterNavigationController = splitViewController.viewControllers[0] as? UINavigationController {
                self.masterNavigationController = masterNavigationController
            }
            
            if splitViewController.viewControllers.count == 2 {
                if let detailNavigationController = splitViewController.viewControllers[1] as? UINavigationController {
                    self.detailNavigationController = detailNavigationController
                }
            }
        }
        
        self.viewControllerMap = viewControllerMap
    }
    
    init(navigationController: UINavigationController, viewControllerMap: [String: ViewController.Type]) {
        masterNavigationController = navigationController
        self.viewControllerMap = viewControllerMap
    }
    
    private func validate(view: String, navigationController: UINavigationController?, isDetail: Bool) throws -> (ViewController, UINavigationController) {
        guard let navigationController = navigationController else {
            if isDetail {
                throw RouterError.NoDetailNavigationControllerSetup
            }
            else {
                throw RouterError.NoMasterNavigationControllerSetup
            }
        }
        
        guard let viewType = viewControllerMap?[view] else {
            throw RouterError.NoViewImplementationFoundForView("No view implementation found for view: \(view)")
        }
        
        return (viewType.instance(), navigationController)
    }
    
    private func push(view: String, data: AnyObject?, navigationController: UINavigationController?, isDetail: Bool, animated: Bool) {
        do {
            let tuple = try validate(view: view, navigationController: navigationController, isDetail: isDetail)
            tuple.0.update(data: data)
            tuple.0.router = self
            tuple.1.pushViewController(tuple.0, animated: animated)
        }
        catch let error {
            print(error)
        }
    }
    
    private func root(view: String, data: AnyObject?, navigationController: UINavigationController?, isDetail: Bool, animated: Bool) {
        do {
            let tuple = try validate(view: view, navigationController: navigationController, isDetail: isDetail)
            tuple.0.update(data: data)
            tuple.0.router = self
            tuple.1.setViewControllers([tuple.0], animated: animated)
        }
        catch let error {
            print(error)
        }
    }
    
    private func pop(navigationController: UINavigationController?, animated: Bool) {
        guard let navigationController = navigationController else {
            return
        }
        navigationController.popViewController(animated: animated)
    }
    
    func push(view: String, data: AnyObject?, animated: Bool) {
        push(view: view, data: data, navigationController: masterNavigationController, isDetail: false, animated: animated)
    }
    
    func pushDetail(view: String, data: AnyObject?, animated: Bool) {
        push(view: view, data: data, navigationController: detailNavigationController, isDetail: true, animated: animated)
    }
    
    func root(view: String, data: AnyObject?, animated: Bool) {
        root(view: view, data: data, navigationController: masterNavigationController, isDetail: false, animated: animated)
    }
    
    func rootDetail(view: String, data: AnyObject?, animated: Bool) {
        root(view: view, data: data, navigationController: detailNavigationController, isDetail: true, animated: animated)
    }
    
    func pop(animated: Bool) {
        pop(navigationController: masterNavigationController, animated: animated)
    }
    
    func popDetail(animated: Bool) {
        pop(navigationController: detailNavigationController, animated: animated)
    }
    
}
