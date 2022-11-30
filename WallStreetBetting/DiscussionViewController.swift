//
//  DiscussionViewController.swift
//  WallStreetBetting
//
//  Created by Jason Philpy on 11/20/22.
//

import UIKit
import Combine

class DiscussionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dateSelectionView: DateSelectionView!
    @IBOutlet weak var dateSelectionButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    private let refreshControl = UIRefreshControl()
    private var subscriptions = Set<AnyCancellable>()
    
    let viewModel = DiscussionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getDiscussions(date: nil)
    }
    
    func setupViews() {
        tableView.register(UINib(nibName: "DiscussionTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    func setupBindings() {
        subscriptions.insert(viewModel.$statusText.assign(to: \.text!, on: dateLabel))
        viewModel.$discussions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] discussions in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
        viewModel.$filterString
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filterString in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &subscriptions)
        dateSelectionView.$dateSelected
            .sink { [weak self] dateSelected in
                guard let date = dateSelected else { return }
                self?.dateSelectionButton.setTitle(date.displayReadyString(), for: .normal)
                self?.viewModel.getDiscussions(date: date)
            }
            .store(in: &subscriptions)
    }
    
    @IBAction func chooseDateClicked() {
        dateSelectionView.isHidden = false
    }
    
    @objc func handleRefresh() {
        viewModel.getDiscussions(date: dateSelectionView.dateSelected)
    }
        
    @objc func textFieldDidChange(textField: UITextField) {
        viewModel.setSearch(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

}

extension DiscussionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? DiscussionTableViewCell else { return UITableViewCell() }
        cell.tickerLabel.text = viewModel.getTickerText(row: indexPath.row)
        cell.commentsLabel.text = viewModel.getCommentLabelText(row: indexPath.row)
        cell.sentimentLabel.text = viewModel.getSentimentLabelText(row: indexPath.row)
        cell.setAdvice(viewModel.getSentimentCategory(row: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ticker = viewModel.getTickerText(row: indexPath.row)
        let url = URL(string: "https://finance.yahoo.com/quote/\(ticker)/")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
