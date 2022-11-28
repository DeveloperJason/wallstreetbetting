//
//  StockDiscussion.swift
//  WallStreetBetting
//
//  Created by Jason Philpy on 11/19/22.
//

import Foundation

enum Sentiment: String {
    case bullish = "Bullish"
    case bear = "Bearish"
    case neutral = ""
}
class StockDiscussion {
    
    var noOfComments = 0
    var sentiment: Sentiment?
    var sentimentScore = 0.0
    var ticker = ""
    
    init(dict: Dictionary<String,Any>) {
        noOfComments = dict["no_of_comments"] as? Int ?? 0
        sentiment = Sentiment(rawValue: dict["sentiment"] as? String ?? "")
        sentimentScore = dict["sentiment_score"] as? Double ?? 0.0
        ticker = dict["ticker"] as? String ?? ""
    }
}
