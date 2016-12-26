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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        NSLayoutConstraint.activate([commentsButtonWidthConstraint, urlLabelHeightConstraint])
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
        scoreLabel.text = "\(story.score)"
        titleLabel.text = story.title
        if let descendants = story.descendants.value {
            commentsButton.titleLabel?.text = "\(descendants)"
        }
        else {
            commentsButtonWidthConstraint.constant = 0
        }
        
        styleURLLabel(story: story)
    }
    
    func styleURLLabel(story: Story) {
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
