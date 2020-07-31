//
//  ButtonTableViewCell.swift
//  ShoppingList-Assessment2
//
//  Created by Colton Swapp on 7/31/20.
//  Copyright © 2020 Colton Swapp. All rights reserved.
//

import UIKit

// Write out the protocol method for ButtonTableViewCellDelegate which extends to classes
protocol ListItemTableViewCellDelegate: class {
    func isCompleteButtonTapped(_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {
    
    // Set a delegate for the ButtonTableViewCellDelegate
    weak var delegate: ListItemTableViewCellDelegate?
    
    var listItem: ListItem? {
        didSet {
            updateViews()
        }
    }

    
    // MARK: - Outlets
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemIsComplete: UIButton!
    
    
    // MARK: - Actions
    @IBAction func isCompleteTappe(_ sender: Any) {
        delegate?.isCompleteButtonTapped(self)
    }
    
    
    // MARK: - Helpers
    
    func updateViews() {
        guard let listItem = listItem else { return }
        itemNameLabel.text = listItem.itemName
        updateButton(for: listItem)
    }
    
    func updateButton(for listItem: ListItem) {
        if listItem.isComplete {
            itemIsComplete.setBackgroundImage(#imageLiteral(resourceName: "complete"), for: .normal)
        } else {
            itemIsComplete.setBackgroundImage(#imageLiteral(resourceName: "incomplete"), for: .normal)
        }
    }
}
