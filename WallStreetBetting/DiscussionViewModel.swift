//
//  DiscussionVIewModel.swift
//  WallStreetBetting
//
//  Created by Jason Philpy on 11/20/22.
//

import Foundation
import Combine

class DiscussionViewModel {
    
    private let repo: StockDiscussionRepository
    @Published private(set) var discussions = [StockDiscussion]()
    @Published private(set) var isLoading = false
    @Published private(set) var statusText = ""
    
    init(repo: StockDiscussionRepository = StockDiscussionRepository()) {
        self.repo = repo
    }
    
    func getDiscussions(date: Date? = nil) {
        discussions.removeAll()
        isLoading = true
        statusText = "Loading discussions..."
        repo.getTop50StockDiscussions(date: date?.apiReadyString()) { [weak self] discussions, error in
            self?.isLoading = false
            if let discs = discussions {
                self?.discussions = discs
                let timestamp = Date().timestampDisplayString()
                self?.statusText = "Updated at \(timestamp)"
            } else {
                self?.statusText = error ?? "Error loading discussions"
            }
        }
    }
    
    func getNumberOfRows() -> Int {
        return discussions.count
    }
    
    func getTickerText(row: Int) -> String {
        return discussions[row].ticker
    }
    
    func getCommentLabelText(row: Int) -> String {
        return "Comments: \(discussions[row].noOfComments)"
    }
    
    func getSentimentLabelText(row: Int) -> String {
        return "Sentiment: \(discussions[row].sentimentScore)"
    }
    
    func getSentimentCategory(row: Int) -> Sentiment {
        return discussions[row].sentiment ?? .neutral
    }

}
