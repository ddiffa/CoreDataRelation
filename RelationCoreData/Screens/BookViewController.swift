//
//  BookViewController.swift
//  RelationCoreData
//
//  Created by Diffa Desyawan on 16/06/21.
//

import UIKit
import MobileCoreServices

class BookViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var nameAuthorLabel: UILabel!
    @IBOutlet weak var hobbyAuthorLabel: UILabel!
    @IBOutlet weak var titleBookLabel: UITextField!
    @IBOutlet weak var descBookLabel: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var thumbnailBook: UIImageView!
    private var tableCellName : String = "BookTableViewCell"
    var author : Author?
    private var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewCell()
        configureTableView()
        if let author = author {
            nameAuthorLabel.text = author.name
            hobbyAuthorLabel.text = author.hobby
            
            load()
        }
        
    }
    
    
    private func setTableViewCell(){
        let nib = UINib(nibName: tableCellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: tableCellName)
    }

    @IBAction func actionSaveBookButton(_ sender: Any) {
        
        guard let author = author else {
            print("error author")
            return
        }
        
        guard let title = titleBookLabel.text else {
            print("error title")
            return
        }
        
        guard let desc = descBookLabel.text else {
            print("error desc")
            return
        }
        
        guard let image = thumbnailBook.image?.jpegData(compressionQuality: 50.0) else {
            return
        }
        
        titleBookLabel.text = ""
        descBookLabel.text = ""
        thumbnailBook.image = UIImage(systemName: "photo")
        
        PersistanceManager.shared.setBook(title: title, desc: desc, imageData: image, author: author)
        
        load()

    }
    
    @IBAction func chooseImageAction(_ sender: Any) {
        let imagePickerActionSheet = UIAlertController(title: "Add Image", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraButton = UIAlertAction(
                title: "Take Photo",
                style: .default) {
                (alert) -> Void in
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                imagePicker.mediaTypes = [kUTTypeImage as String]
                self.present(imagePicker, animated: true, completion: {
                    
                })
            }
            
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        let libraryButton = UIAlertAction(
            title: "Choose Existing",
            style: .default) { (alert) -> Void in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = [kUTTypeImage as String]
            self.present(imagePicker, animated: true, completion: {
                
            })
            
        }
        
        imagePickerActionSheet.addAction(libraryButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        imagePickerActionSheet.addAction(cancelButton)
        
        present(imagePickerActionSheet, animated: true, completion: {
            
        })
    }
    
    private func load(){
        guard let author = author else {
            print("error author")
            return
        }
        
        books = PersistanceManager.shared.fetchBook(author: author)
        tableView.reloadData()
    }
}

extension BookViewController : UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: tableCellName) as? BookTableViewCell {
            let book = self.books[indexPath.row]
            cell.setDataIntoCell(book: book)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(120.0)
    }
}

extension BookViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedPhoto = info[.editedImage] as? UIImage else {
            dismiss(animated: true)
            return
        }
        
        self.thumbnailBook.image = selectedPhoto
        dismiss(animated: true, completion: nil)
    }

}
