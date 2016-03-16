//
//  SavedMemesTableViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

class SavedMemesTableViewController: UITableViewController, SavedMemesNavigation {
    
    private var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    /** Storage */
    private var storedMemesProvider: MemesProvider!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizedStrings.ViewControllerTitles.memeMe
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self

        configureNavigationItems()
        
    }

    override func viewWillAppear(animated: Bool) {
        storedMemesProvider = MemesProvider()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.SegueIDs.memeDetail {
            let savedMemeVC = segue.destinationViewController as! SavedMemeViewController
            savedMemeVC.title = storedMemesProvider.memeArray[selectedIndexPath.row].topText
            //TODO: pass meme instead so it can be edited
            //TODO: pass a deleteClosure to reset selectedIndex
            savedMemeVC.configure(withMemeImage: storedMemesProvider.memeArray[selectedIndexPath.row].memedImage!)
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseIDs.memeListTableCell, forIndexPath: indexPath) as! SavedMemesTableViewCell
        
        let topText = storedMemesProvider.memeArray[indexPath.row].topText
        let bottomText = storedMemesProvider.memeArray[indexPath.row].bottomText
        
        var title = topText
        if topText != "" && bottomText != "" { title += "\n" }
        title += bottomText
        
        let model = SavedMemeCellModel(title: title, image: storedMemesProvider.memeArray[indexPath.row].memedImage!)
        cell.configure(withDataSource: model)
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
   
    
   
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            storedMemesProvider.removeMemeFromStorage(atIndex: indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
}


//MARK: - Table View Delegate
extension SavedMemesTableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        performSegueWithIdentifier(Constants.SegueIDs.memeDetail, sender: self)
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
    
//    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCellEditingStyle
//    {
//        if ((!editing)){
//            return UITableViewCellEditingStyle.None;
//        }
//        
//        if (editing && indexPath.row == intervalArray.count){
//            return UITableViewCellEditingStyle.Insert;
//        }
//        else{
//            return UITableViewCellEditingStyle.Delete;
//        }
//    }
//    
//    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
//        let proposedInterval = intervalArray[proposedDestinationIndexPath.row]
//        
//        if proposedInterval.isWarmUp {
//            return NSIndexPath(forItem: proposedDestinationIndexPath.row + 1, inSection: 0)
//        } else if proposedInterval.isCoolDown {
//            return NSIndexPath(forItem: proposedDestinationIndexPath.row - 1, inSection: 0)
//        }
//        return proposedDestinationIndexPath
//    }
}
