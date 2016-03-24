//
//  FontListTableViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/2/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class FontListTableViewController: UITableViewController {

    private var viewModel: MemeEditorViewModel!
    
    private var selectedFont = Constants.Font.impact
    private var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor        = Constants.ColorScheme.lightGrey
        tableView.separatorColor    = Constants.ColorScheme.darkGrey
    }

    override func viewWillAppear(animated: Bool) {
        for i in 0..<Constants.FontArray.count {
            if viewModel.font.value == Constants.FontArray[i] {
                selectedFont = viewModel.font.value
                selectedIndexPath = NSIndexPath(forItem: i, inSection: 0)
                break
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        /** 
         * Scrolling here because there's a visual "bug" when scrolling is done 
         * in viewWillAppear(). It's still not a great visual experience, but
         * better than the cells being off.
         *
         * See here: http://stackoverflow.com/questions/13028239/uitableview-scrolltorowatindexpath-not-displaying-last-row-correctly
        */
        tableView.scrollToRowAtIndexPath(selectedIndexPath, atScrollPosition: .Top, animated: false)
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.FontFamilyNameArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseID.fontListTableCell, forIndexPath: indexPath) as! FontListTableViewCell
        
        let model = FontListTableViewCellModel(
            title: Constants.FontFamilyNameArray[indexPath.row],
            font: Constants.FontArray[indexPath.row]
        )
        cell.configure(withDataSource: model)
        
        if selectedFont == Constants.FontArray[indexPath.row] {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }

        return cell
    }
    
    internal func configure(withViewModel viewModel: MemeEditorViewModel) {
        self.viewModel = viewModel
    }

}

//MARK: - UITableViewDelegate
extension FontListTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /** Save selection to NSUserDefaults */
        Constants.userDefaults.setObject(Constants.FontFamilyNameArray[indexPath.row] as NSString, forKey: Constants.StorageKeys.fontName)
        
        /** Need to update MainViewViewModel & reloadData to set checkmark */
        viewModel.font.value = Constants.FontArray[indexPath.row]
        selectedFont = viewModel.font.value
        selectedIndexPath = indexPath
        tableView.reloadData()
    }
}
