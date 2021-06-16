//
//  AuthorViewController.swift
//  RelationCoreData
//
//  Created by Diffa Desyawan on 16/06/21.
//

import UIKit

class AuthorViewController: UIViewController {

    @IBOutlet weak var nameAuthor: UITextField!
    @IBOutlet weak var hobbyAuthor: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    
    private var authors : [Author] = []
    private let tableCellName : String = "AuthorTableViewCell"
    
    private var edit: Bool = false
    private var authorUpdate: Author?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewCell()
        configureTableView()
        load()
    }
    
    @IBAction func actionButtonSave(_ sender: Any) {
        
        guard let name = nameAuthor.text else {
            return
        }
        
        guard let hobby = hobbyAuthor.text else {
            return
        }
        
        if edit {
            authorUpdate?.name = name
            authorUpdate?.hobby = hobby
            PersistanceManager.shared.save()
            edit = false
            self.btnSave.setTitle("Save", for: .normal)
        } else {
            PersistanceManager.shared.setAuthor(name: name, hobby: hobby)
        }
        
        // Reset text field
        nameAuthor.text = ""
        hobbyAuthor.text = ""
        
        load()
    }
    
    private func setTableViewCell(){
        let nib = UINib(nibName: tableCellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: tableCellName)
    }
    
    private func load(){
        authors = PersistanceManager.shared.fetchAuthors()
        tableView.reloadData()
    }

}

extension AuthorViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: tableCellName, for: indexPath) as? AuthorTableViewCell {
            let author = self.authors[indexPath.row]
            cell.setDataIntoCell(author: author)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "BookViewController") as? BookViewController {
            vc.author = self.authors[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete"){ (rowAction, indexPath) in
            PersistanceManager.shared.deleteAuthor(author: self.authors[indexPath.row])
            self.load()
        }
        
        let editButton = UITableViewRowAction(style: .normal, title: "Edit"){ (rowAction, indexPath) in
            self.edit = true
            self.authorUpdate = self.authors[indexPath.row]
            self.nameAuthor.text = self.authorUpdate?.name
            self.hobbyAuthor.text = self.authorUpdate?.hobby
            self.btnSave.setTitle("Edit", for: .normal)
        }
        
        editButton.backgroundColor = UIColor.systemGreen
        deleteButton.backgroundColor = UIColor.systemRed
        return [editButton, deleteButton]
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}
