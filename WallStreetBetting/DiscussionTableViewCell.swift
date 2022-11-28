//
//  DiscussionTableViewCell.swift
//  WallStreetBetting
//
//  Created by Jason Philpy on 11/20/22.
//

import UIKit

class DiscussionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var buySellLabel: UILabel!
    
    func setAdvice(_ sentiment: Sentiment) {
        switch sentiment {
        case .bullish:
            buySellLabel.text = "BUY"
            buySellLabel.textColor = .green
        case .bear:
            buySellLabel.text = "SELL"
            buySellLabel.textColor = .red
        case .neutral:
            buySellLabel.text = "N/A"
            buySellLabel.textColor = .black
        }
    }
    
}
