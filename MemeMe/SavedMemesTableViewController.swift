//
//  SavedMemesTableViewController.swift
//  MemeMe
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

//protocol SavedMemesNavigationAction {
//    var addButtonClosure: (() -> Void)? { get }
//}
//
//extension SavedMemesNavigationAction {
//    var addButtonClosure = { [weak self] in
//        
//    }
//}

class SavedMemesTableViewController: UITableViewController {
    private var navController: SavedMemesNavigationController!
    private var memeEditorNavController: MemeEditorNavigationController?
    
    /** Storage */
    private var storedMemesProvider = MemesProvider()
    
    
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

    
    private func configureNavigationItems() {
        navController = navigationController as! SavedMemesNavigationController
        
        let addButtonClosure = { [weak self] in
            
            /** Open Meme Editor */
            self!.memeEditorNavController = UIStoryboard(name: Constants.StoryBoardIDs.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardIDs.memesEditorNavController) as? MemeEditorNavigationController
            
            self!.memeEditorNavController?.vcShouldBeDismissed = { [weak self] in
                self!.dismissViewControllerAnimated(true) {
                    self!.memeEditorNavController = nil
                }
            }
            
            self!.presentViewController(self!.memeEditorNavController!, animated: true, completion: nil)
        }
        
        navController.configure(withAddButtonClosure: addButtonClosure)
    }
    




    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
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
