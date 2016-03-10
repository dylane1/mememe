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
        
//        self.clearsSelectionOnViewWillAppear = false
        configureNavigationItems()
        
    }

    override func viewWillAppear(animated: Bool) {
        //TODO: Make sure this is called when Meme Editor is dismissed
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
            self!.memeEditorNavController = UIStoryboard(name: Constants.StoryBoardIDs.main, bundle: nil).instantiateViewControllerWithIdentifier(Constants.StoryBoardIDs.sb_memesEditorNavController) as? MemeEditorNavigationController
            
            self!.memeEditorNavController?.vcShouldBeDismissed = { [weak self] in
                self!.dismissViewControllerAnimated(true) {
                    magic("")
                    self!.memeEditorNavController = nil
                }
            }
            
            self!.presentViewController(self!.memeEditorNavController!, animated: true, completion: nil)
        }
        
        navController.configure(withAddButtonClosure: addButtonClosure)
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedMemesProvider.memeArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseIDs.memeListTableCell, forIndexPath: indexPath) as! SavedMemesTableViewCell
        
        //TODO: Change meme model so that top & bottom text can't be nil
        
//        let topText = storedMemesProvider.memeArray[indexPath.row].topText
        let model = SavedMemeCellModel(title: "foo", image: storedMemesProvider.memeArray[indexPath.row].memedImage!)
        magic(storedMemesProvider.memeArray[indexPath.row].topText)
//        cell.configure(withDataSource: model)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
