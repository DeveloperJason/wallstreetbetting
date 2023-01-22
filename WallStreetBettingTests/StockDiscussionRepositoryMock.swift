//
//  StockDiscussionRepositoryMock.swift
//  WallStreetBettingTests
//
//  Created by Jason Philpy on 1/13/23.
//

import Foundation
@testable import WallStreetBetting

class StockDiscussionRepositoryMock: StockDiscussionRepository {
    
    var mockError: RepositoryError?
    var mockDiscussions = [StockDiscussion]()
    
    override func getTop50StockDiscussions(date: String? = nil, completion: @escaping (Result<[StockDiscussion], StockDiscussionRepository.RepositoryError>) -> Void) {
        if let error = mockError {
            completion(.failure(error))
        } else {
            completion(.success(mockDiscussions))
        }
    }
}
