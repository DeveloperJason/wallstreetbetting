//
//  DiscussionViewModelTest.swift
//  WallStreetBettingTests
//
//  Created by Jason Philpy on 1/13/23.
//

import XCTest
@testable import WallStreetBetting

class DiscussionViewModelTest: XCTestCase {

    var viewModel: DiscussionViewModel!
    var repo: StockDiscussionRepositoryMock!
    
    override func setUp() {
        repo = StockDiscussionRepositoryMock()
        viewModel = DiscussionViewModel(repo: repo)
    }
    
    func testGetDiscussions() {
        repo.mockDiscussions = [StockDiscussion(dict: [:]), StockDiscussion(dict: [:]), StockDiscussion(dict: [:])]
        viewModel.getDiscussions(date: nil)
        XCTAssertTrue(viewModel.statusText.contains("Updated at "))
        XCTAssertEqual(viewModel.discussions.count, 3)
        let errorString = "Test Error"
        repo.mockError = StockDiscussionRepository.RepositoryError(errorString)
        viewModel.getDiscussions(date: nil)
        XCTAssertEqual(viewModel.statusText, errorString)
    }

    func testGetNumberOfRows() {
        repo.mockDiscussions = [StockDiscussion(dict: [:]), StockDiscussion(dict: [:]), StockDiscussion(dict: [:])]
        viewModel.getDiscussions(date: nil)
        XCTAssertEqual(viewModel.getNumberOfRows(), 3)
        repo.mockDiscussions.first?.ticker = "TEST"
        viewModel.setSearch("TEST")
        viewModel.getDiscussions(date: nil)
        XCTAssertEqual(viewModel.getNumberOfRows(), 1)
    }

    func testGetTickerText() {
        repo.mockDiscussions = [StockDiscussion(dict: [:]), StockDiscussion(dict: [:]), StockDiscussion(dict: [:])]
        repo.mockDiscussions[0].ticker = "TEST"
        viewModel.getDiscussions(date: nil)
        XCTAssertEqual(viewModel.getTickerText(row: 0), "TEST")
        viewModel.setSearch("TEST2")
        repo.mockDiscussions[1].ticker = "TEST2"
        viewModel.getDiscussions(date: nil)
        XCTAssertEqual(viewModel.getTickerText(row: 0), "TEST2")
    }

    func testGetCommentLabelText() {
        repo.mockDiscussions = [StockDiscussion(dict: [:]), StockDiscussion(dict: [:]), StockDiscussion(dict: [:])]
        repo.mockDiscussions[0].ticker = "TEST"
        repo.mockDiscussions[0].noOfComments = 3
        var expectedResult = "Comments: 3"
        viewModel.getDiscussions(date: nil)
        XCTAssertEqual(viewModel.getCommentLabelText(row: 0), expectedResult)
        viewModel.setSearch("TEST2")
        repo.mockDiscussions[1].ticker = "TEST2"
        repo.mockDiscussions[1].noOfComments = 5
        expectedResult = "Comments: 5"
        viewModel.getDiscussions(date: nil)
        XCTAssertEqual(viewModel.getCommentLabelText(row: 0), expectedResult)
    }
    
    func testGetSentimentLabelText() {
        repo.mockDiscussions = [StockDiscussion(dict: [:]), StockDiscussion(dict: [:]), StockDiscussion(dict: [:])]
        repo.mockDiscussions[0].ticker = "TEST"
        repo.mockDiscussions[0].sentimentScore = 0.5
        var expectedResult = "Sentiment: 0.5"
        viewModel.getDiscussions(date: nil)
        XCTAssertEqual(viewModel.getSentimentLabelText(row: 0), expectedResult)
        viewModel.setSearch("TEST2")
        repo.mockDiscussions[1].ticker = "TEST2"
        repo.mockDiscussions[1].sentimentScore = 0.75
        expectedResult = "Sentiment: 0.75"
        viewModel.getDiscussions(date: nil)
        XCTAssertEqual(viewModel.getSentimentLabelText(row: 0), expectedResult)
    }
    
    func testGetSentimentCategory() {
        repo.mockDiscussions = [StockDiscussion(dict: [:]), StockDiscussion(dict: [:]), StockDiscussion(dict: [:])]
        viewModel.getDiscussions(date: nil)
        XCTAssertEqual(viewModel.getSentimentCategory(row: 0), .neutral)
        repo.mockDiscussions[0].ticker = "TEST"
        repo.mockDiscussions[0].sentiment = .bear
        viewModel.getDiscussions(date: nil)
        XCTAssertEqual(viewModel.getSentimentCategory(row: 0), .bear)
        viewModel.setSearch("TEST2")
        repo.mockDiscussions[1].ticker = "TEST2"
        repo.mockDiscussions[1].sentiment = .bullish
        viewModel.getDiscussions(date: nil)
        XCTAssertEqual(viewModel.getSentimentCategory(row: 0), .bullish)
    }
    
    func testSetSearch() {
        viewModel.setSearch("TEST")
        XCTAssertEqual(viewModel.filterString, "TEST")
        viewModel.setSearch("test")
        XCTAssertEqual(viewModel.filterString, "TEST")
        viewModel.setSearch("")
        XCTAssertEqual(viewModel.filterString, nil)
    }

}
