//
//  DateSelectionView.swift
//  WallStreetBetting
//
//  Created by Jason Philpy on 11/27/22.
//

import UIKit
import Combine

class DateSelectionView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!

    @Published private(set) var dateSelected: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DateSelectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        datePicker.maximumDate = Date()
    }

    @IBAction func dateChanged(_ sender: UIDatePicker) {
        
    }
    
    @IBAction func loadDateClicked() {
        dateSelected = datePicker.date
        isHidden = true
    }
    
    @IBAction func cancelClicked() {
        isHidden = true
    }
    
}
