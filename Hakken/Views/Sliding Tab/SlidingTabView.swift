//
//  SlidingTabView.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 1/2/17.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit

enum TabState: Int {
    case Active
    case Inactive
}

protocol SlidingTabViewDelegate: class {
    func didTapOption(option: SlidingTabOption)
}

class SlidingTabCollectionViewCell: CollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func update(model: AnyObject) {
        super.update(model: model)
        if let option = model as? String {
            label.text = option
        }
    }
}

class SlidingTabView: UIView {
    @IBOutlet weak var sliderLineContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var slideLineView: UIView!
    weak var delegate: SlidingTabViewDelegate?
    
    var options: [SlidingTabOption] = [SlidingTabOption]()
    class func instance() -> SlidingTabView? {
        let slidingTabView = UINib(nibName:"SlidingTabView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? SlidingTabView
        slidingTabView?.sharedSetup()
        if slidingTabView != nil {
            return slidingTabView
        }
        return nil
    }
    
    func sharedSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SlidingTabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SlidingTabCollectionViewCell")
    }
    
    func setup(options: [SlidingTabOption]) {
        // generate labels from strings
        self.options = options
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        moveLineToOption(option: 0, animated: false)
    }
    
    func moveLineToOption(option: Int, animated: Bool) {
        guard let _ = collectionView.cellForItem(at: IndexPath(row: option, section: 0)) as? SlidingTabCollectionViewCell else {
            return
        }
        let attriubtes = collectionView.layoutAttributesForItem(at: IndexPath(row: option, section: 0))
        let newLineRect = CGRect(x: attriubtes!.frame.origin.x, y: 0, width: attriubtes!.frame.width, height: 1.0)
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.slideLineView.frame = newLineRect
            })
        } else {
            slideLineView.frame = newLineRect
        }
    }
    
    func didTapView(gestureRecognizer: UIGestureRecognizer) {
        
    }
}

extension SlidingTabView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsCount = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        return CGSize(width: collectionView.superview!.bounds.width/CGFloat(itemsCount), height: collectionView.bounds.height)
    }
}

extension SlidingTabView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveLineToOption(option: indexPath.item, animated: true)
        delegate?.didTapOption(option: options[indexPath.row])
    }
}

extension SlidingTabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlidingTabCollectionViewCell", for: indexPath) as! SlidingTabCollectionViewCell
        cell.update(model: options[indexPath.row].rawValue as AnyObject)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
}
