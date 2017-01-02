//
//  StoryListCollectionViewCell.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/25/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit

class StoryListCollectionViewCell: CollectionViewCell {
    @IBOutlet weak var urlLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTimeSubmittedLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var commentsButtonWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        styleButton()
    }
    
    private func styleButton() {
        commentsButton.clipsToBounds = false
        commentsButton.layer.cornerRadius = commentsButtonWidthConstraint.constant/2
        commentsButton.titleLabel?.textAlignment = .center
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commentsButtonWidthConstraint.constant = 44
        urlLabelHeightConstraint.constant = 15
    }
    
    override public class func nibName() -> String {
        return "StoryListCollectionViewCell"
    }
    
    override func update(model: AnyObject) {
        super.update(model: model)
        
        guard let story = model as? Story else {
            return
        }
        dateTimeSubmittedLabel.text = "Submitted \(story.time.relativeDateTimeStringToNow()) by \(story.by)"
        scoreLabel.text = "\(story.score) points"
        titleLabel.text = story.title
        if let descendants = story.descendants.value {
            commentsButton.setTitle("\(descendants)", for: .normal)
            commentsButton.setTitle("\(descendants)", for: .selected)
            commentsButton.setTitle("\(descendants)", for: .highlighted)
        }
        else {
            commentsButtonWidthConstraint.constant = 0
        }
        
        styleURLLabel(story: story)
    }
    
    private func styleURLLabel(story: Story) {
        if story.isUserGenerated() {
            urlLabel.text = nil
            urlLabelHeightConstraint.constant = 0
        } else if let host = story.url?.host {
            urlLabel.text = "(\(host))"
        }
        
        if story.enumType == .Job {
            commentsButton.isHidden = true
        }
    }
}
