//
//  SavedMemesTableViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemesTableViewController: UITableViewController, SavedMemesNavigationProtocol, MemeEditorPresentable {
    private var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    private var storedMemesProvider: MemesProvider!
    
    internal var memeEditorNavController: NavigationController?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedStrings.ViewControllerTitles.memeMe        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /** Set special font for the app title */
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
        
        storedMemesProvider = MemesProvider()
        
        configureNavigationItems()
        
        configureTableView()
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Configuration
    
    private func configureTableView() {
        if storedMemesProvider.memeArray.count == 0 {
            let emptyDataSetVC = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardID.emptyDataSetVC) as! EmptyDataSetViewController
            
            tableView.backgroundView = emptyDataSetVC.view
        } else {
            tableView.backgroundView = nil
        }
//        tableView.separatorInset = UIEdgeInsetsZero
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.backgroundColor = Constants.ColorScheme.darkBlueGrey
    }
    
    //MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let deletionClosure = { [unowned self] in
            self.storedMemesProvider.removeMemeFromStorage(atIndex: self.selectedIndexPath.row)
            self.selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        }
        configureDetailViewController(forMeme: storedMemesProvider.memeArray[selectedIndexPath.row], selectedIndex: selectedIndexPath.row, segue: segue, deletionClosure: deletionClosure)
    }
}


//MARK: - Table View Data Source
extension SavedMemesTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedMemesProvider.memeArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseID.memeListTableCell, forIndexPath: indexPath) as! SavedMemesTableViewCell
        
        let model = SavedMemeCellModel(meme: storedMemesProvider.memeArray[indexPath.row])
        
        cell.configure(withDataSource: model)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
   
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            storedMemesProvider.removeMemeFromStorage(atIndex: indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}


//MARK: - Table View Delegate
extension SavedMemesTableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        performSegueWithIdentifier(Constants.SegueID.memeDetail, sender: self)
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        /** Allows the bottom cell to be fully visible when scrolled to end of list */
        return 2
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.frame = CGRectMake(0, 0, view.bounds.size.width, 2.0)
        footerView.backgroundColor = UIColor.clearColor()
        return footerView
    }
}
