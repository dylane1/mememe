//
//  SavedMemesTableViewController.swift
//  MemeMeister
//
//  Created by Dylan Edwards on 3/7/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class SavedMemesTableViewController: UITableViewController, SavedMemesNavigationProtocol, MemeEditorPresentable {
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    fileprivate var storedMemesProvider: MemesProvider!
    
    internal var memeEditorNavController: NavigationController?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizedStrings.ViewControllerTitles.memeMe        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /** Set special font for the app title */
        let navController = navigationController! as! NavigationController
        navController.setNavigationBarAttributes(isAppTitle: true)
        
        storedMemesProvider = MemesProvider()
        
        configureNavigationItems()
        
        configureTableView()
        
        tableView.reloadData()
    }

    //MARK: - Configuration
    
    fileprivate func configureTableView() {
        if storedMemesProvider.memeArray.count == 0 {
            let emptyDataSetVC = UIStoryboard(name: Constants.StoryBoardID.main, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryBoardID.emptyDataSetVC) as! EmptyDataSetViewController
            
            tableView.backgroundView = emptyDataSetVC.view
        } else {
            tableView.backgroundView = nil
        }
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.backgroundColor = Constants.ColorScheme.darkBlueGrey
    }
    
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let deletionClosure = { [unowned self] in
            self.storedMemesProvider.removeMemeFromStorage(atIndex: self.selectedIndexPath.row)
            self.selectedIndexPath = IndexPath(row: 0, section: 0)
        }
        configureDetailViewController(forMeme: storedMemesProvider.memeArray[selectedIndexPath.row], selectedIndex: selectedIndexPath.row, segue: segue, deletionClosure: deletionClosure)
    }
}


//MARK: - Table View Data Source
extension SavedMemesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedMemesProvider.memeArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseID.memeListTableCell, for: indexPath) as! SavedMemesTableViewCell
        
        let model = SavedMemeCellModel(meme: storedMemesProvider.memeArray[indexPath.row])
        
        cell.configure(withDataSource: model)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            storedMemesProvider.removeMemeFromStorage(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            /** Reset the empty data set background, if needed */
            configureTableView()
        }
    }
}


//MARK: - Table View Delegate
extension SavedMemesTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: Constants.SegueID.memeDetail, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        /** Allows the bottom cell to be fully visible when scrolled to end of list */
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView              = UIView()
        footerView.frame            = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 2.0)
        footerView.backgroundColor  = UIColor.clear
        return footerView
    }
}
