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
    @Published private(set) var filterString: String?
    
    init(repo: StockDiscussionRepository = StockDiscussionRepository()) {
        self.repo = repo
    }
    
    func getDiscussions(date: Date? = nil) {
        discussions.removeAll()
        isLoading = true
        statusText = "Loading discussions..."
        repo.getTop50StockDiscussions(date: date?.apiReadyString()) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let discs):
                self?.discussions = discs
                let timestamp = Date().timestampDisplayString()
                self?.statusText = "Updated at \(timestamp)"
            case .failure(let error):
                self?.statusText = error.description
            }
        }
    }
    
    func getNumberOfRows() -> Int {
        if let filter = filterString {
            return discussions.filter { $0.ticker.contains(filter) }.count
        } else {
            return discussions.count
        }
    }
    
    func getTickerText(row: Int) -> String {
        if let filter = filterString {
            return discussions.filter { $0.ticker.contains(filter) }[row].ticker
        } else {
            return discussions[row].ticker
        }
    }
    
    func getCommentLabelText(row: Int) -> String {
        if let filter = filterString {
            return "Comments: \(discussions.filter { $0.ticker.contains(filter) }[row].noOfComments)"
        } else {
            return "Comments: \(discussions[row].noOfComments)"
        }
    }
    
    func getSentimentLabelText(row: Int) -> String {
        if let filter = filterString {
            return "Sentiment: \(discussions.filter { $0.ticker.contains(filter) }[row].sentimentScore)"
        } else {
            return "Sentiment: \(discussions[row].sentimentScore)"
        }
    }
    
    func getSentimentCategory(row: Int) -> Sentiment {
        if let filter = filterString {
            return discussions.filter { $0.ticker.contains(filter) }[row].sentiment ?? .neutral
        } else {
            return discussions[row].sentiment ?? .neutral
        }
    }
    
    func setSearch(_ string: String?) {
        if let searchString = string, searchString.count > 0 {
            filterString = searchString.uppercased()
        } else {
            filterString = nil
        }
    }
}
