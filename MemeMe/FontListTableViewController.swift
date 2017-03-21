//
//  FontListTableViewController.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/2/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class FontListTableViewController: UITableViewController {

    fileprivate var viewModel: MemeEditorViewModel!
    
    fileprivate var selectedFont = Constants.Font.impact
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor        = UIColor.clear
        tableView.separatorColor    = Constants.ColorScheme.mediumGrey
    }

    override func viewWillAppear(_ animated: Bool) {
        for i in 0..<Constants.FontArray.count {
            if viewModel.font.value == Constants.FontArray[i] {
                selectedFont = viewModel.font.value
                selectedIndexPath = IndexPath(item: i, section: 0)
                break
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /** 
         * Scrolling here because there's a visual "bug" when scrolling is done 
         * in viewWillAppear(). It's still not a great visual experience, but
         * better than the cells being off.
         *
         * See here: http://stackoverflow.com/questions/13028239/uitableview-scrolltorowatindexpath-not-displaying-last-row-correctly
        */
        tableView.scrollToRow(at: selectedIndexPath, at: .top, animated: false)
    }

    //MARK: - Configuration
    
    internal func configure(withViewModel viewModel: MemeEditorViewModel) {
        self.viewModel = viewModel
    }

}

//MARK: - UITableViewDataSource
extension FontListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.FontFamilyNameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseID.fontListTableCell, for: indexPath) as! FontListTableViewCell
        
        let model = FontListTableViewCellModel(
            title: Constants.FontFamilyNameArray[indexPath.row],
            font: Constants.FontArray[indexPath.row]
        )
        cell.configure(withDataSource: model)
        
        if selectedFont == Constants.FontArray[indexPath.row] {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FontListTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /** Save selection to NSUserDefaults */
        Constants.userDefaults.set(Constants.FontFamilyNameArray[indexPath.row] as NSString, forKey: Constants.StorageKeys.fontName)
        
        /** Need to update MainViewViewModel & reloadData to set checkmark */
        viewModel.font.value = Constants.FontArray[indexPath.row]
        selectedFont = viewModel.font.value
        selectedIndexPath = indexPath
        tableView.reloadData()
    }
}
