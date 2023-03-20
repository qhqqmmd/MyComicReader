//
//  FileView.swift
//  MyComicReader
//
//  Created by zirui huang on 3/6/23.
//

import UIKit
import Security
import ZipArchive

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var TImageView: UIImageView!
    @IBOutlet weak var TTitleLabel: UILabel!
    var TURL: URL!
    
}

class FileView: UITableViewController, UIDocumentPickerDelegate{
    
    
    
    @IBOutlet weak var sortbuttondown: UIButton!
    
    @IBOutlet weak var sortbuttonup: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
  
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let DeleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
            // delete the item at the current index path
            let file = files[indexPath.row]
            
            let filemanager = FileManager.default
            
            do{
                try filemanager.removeItem(at: file.url)
                 files.remove(at: indexPath.row)
                tableView.reloadData()
            }catch{
                    print("Error:can't delete")
                }
                
                
            completionHandler(true)
        }
        let renameAction = UIContextualAction(style: .normal, title: "Rename") { (action, sourceView, completionHandler) in
            
            // delete the item at the current index path
            let alert2 = UIAlertController(title: "Name should not be empty and repeated", message: "Please enter a name for new folder!", preferredStyle: .alert)
            alert2.addAction(UIAlertAction(title: NSLocalizedString("OK", comment:"Keep the State"), style: .default))
            let alert = UIAlertController(title: "Initialization ", message: "Please enter a name for new folder!", preferredStyle: .alert)
            
            alert.addTextField(){
                (textField) in
                    textField.placeholder = "Enter name"
                textField.text = "New Folder"
            }
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Action"), style: .default, handler: { _ in
                if let textField = alert.textFields?.first {
                    
                    let reminderText = textField.text
                    let file = files[indexPath.row]
                    
                    let filemanager = FileManager.default
                    
                    let newFolderURL = file.url.deletingLastPathComponent().appending(path: reminderText!)
                    print(newFolderURL.path)
                    print(file.url.path)
                    do{
                        //try filemanager.createDirectory(at: newFolderURL, withIntermediateDirectories: false)
                        
                        try filemanager.moveItem(at: file.url, to: newFolderURL)
                        // filemanager.removeItem(at: file.url)
                        file.url = newFolderURL
                        file.name = reminderText!
                        tableView.reloadData()
                    }catch{
                        self.present(alert2,animated: false,completion: nil)
                            print("Error:can't rename")
                        }
                    
                    }
                NSLog("Change name")
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:"Keep the State"), style: .default))
            self.present(alert, animated: false, completion: nil)
                
                
            completionHandler(true)
        }
        renameAction.backgroundColor = .blue
        
        
        DeleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [DeleteAction, renameAction])
           configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return files.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let file = files[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier:file.type.rawValue , for: indexPath)as! MyTableViewCell
        
        
        cell.TTitleLabel.text = file.name
        cell.TImageView.image = file.fileImage
        cell.TURL = file.url
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetilView {
            if let cell = sender as? MyTableViewCell, let url = cell.TURL {
                let nextVC = segue.destination as! DetilView
                nextVC.url = url
            }
        }
    }
    
    
    
    
    @IBAction func refresh(_ sender: UIButton) {
        tableView.reloadData()
    }
    
    
    
    @IBAction func SortButton(_ sender: UIButton) {
        files.sort { $0.name < $1.name }
        sortbuttondown.isHidden = true
        sortbuttonup.isHidden = false
        tableView.reloadData()
        
    }
    
    @IBAction func DoubleSortButton(_ sender: UIButton) {
        files.sort { $0.name > $1.name }
        sortbuttonup.isHidden = true
        sortbuttondown.isHidden = false
        tableView.reloadData()
    }
    
    
    @IBAction func addfile(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.zip-archive"], in: .import)
                documentPicker.delegate = self
                documentPicker.allowsMultipleSelection = false
                present(documentPicker, animated: true)
    }
    
    
    
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        // 如果选择的文件是一个压缩文件，则解压缩它
        if url.pathExtension == "zip" {
            let unzipPath = NSTemporaryDirectory() + url.deletingPathExtension().lastPathComponent
            let unzipSuccess = SSZipArchive.unzipFile(atPath: url.path, toDestination: unzipPath)
            if unzipSuccess {
                print("Zip file unzipped successfully to path: \(unzipPath)")
                // 如果解压缩成功，则将解压缩后的文件夹导入到指定位置
                importFolder(atPath: unzipPath)
            } else {
                print("Failed to unzip zip file")
            }
        } else {
            // 如果选择的文件不是压缩文件，则将它作为文件夹导入到指定位置
            let folderPath = url.path
            importFolder(atPath: folderPath)
        }
    }

    func importFolder(atPath folderPath: String) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent((folderPath as NSString).lastPathComponent)
        
        do {
            try fileManager.copyItem(atPath: folderPath, toPath: destinationURL.path)
            print("Folder imported successfully!")
            
            refreshandcheck(inDirectory: destinationURL)
        } catch {
            print("Error importing folder: \(error.localizedDescription)")
        }
    }

    
    
    @IBAction func newfolderbutton(_ sender: UIButton) {
        let alert2 = UIAlertController(title: "Name should not be empty", message: "Please enter a name for new folder!", preferredStyle: .alert)
        alert2.addAction(UIAlertAction(title: NSLocalizedString("OK", comment:"Keep the State"), style: .default))
        let alert = UIAlertController(title: "Initialization ", message: "Please enter a name for new folder!", preferredStyle: .alert)
        
        alert.addTextField(){
            (textField) in
                textField.placeholder = "Enter name"
            textField.text = "New Folder"
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Action"), style: .default, handler: { _ in
            if let textField = alert.textFields?.first {
                
                    let reminderText = textField.text
                
                self.newfolder(foldername: reminderText!)
                }
            NSLog("Change name")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:"Keep the State"), style: .default))
        self.present(alert, animated: false, completion: nil)
            }
    
    func newfolder(foldername:String) {
        
        let fileManager = FileManager.default
        //let foldername:String = "New Folder"
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let newFolderURL = documentsDirectory.appendingPathComponent(foldername)

        
        do {
            try fileManager.createDirectory(at: newFolderURL, withIntermediateDirectories: true, attributes: nil)
            print(newFolderURL)
            print("New folder created successfully")
            refreshandcheck(inDirectory: newFolderURL)
            
                
        } catch {
            print("Error creating new folder: \(error.localizedDescription)")
        }
        //getFiles(inDirectory: documentsDirectory)
        
        //AlllistFiles(inDirectory: documentsDirectory)
        //print("\n current")
        //currentlistFiles(inDirectory: documentsDirectory)
        
    }
    
    func refreshandcheck(inDirectory newFolderURL: URL){
        
        let alert = UIAlertController(title: "Same folder Alert", message: "A folder with the same name already exists or name is null", preferredStyle: .alert)
        
        
        alert.addTextField(){
            (textField) in
                textField.placeholder = "Please re-name"
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Change", comment: "Force action"), style: .default, handler: { _ in
            if let textField = alert.textFields?.first {
                    let reminderText = textField.text
                
                self.newfolder(foldername: reminderText!)
                }
            NSLog("Change name")
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:"Keep the State"), style: .default))
        
        if files.contains(where: { $0.url == newFolderURL || $0.name == newFolderURL.lastPathComponent }) {
            
            self.present(alert, animated: false, completion: nil)
            
            // 如果已经存在同名目录，给用户提示
            //print("A folder with the same name already exists")
            return
        }
        do{
            
            let keys = [URLResourceKey.creationDateKey, URLResourceKey.fileSizeKey]
            let attributes = try newFolderURL.resourceValues(forKeys: Set(keys))
            
            let image = findFirstImage(inDirectory: newFolderURL)
            if image == nil{
                let file = File(name: newFolderURL.lastPathComponent, type: .Undefined, size: attributes.fileSize ?? 0, creationDate: attributes.creationDate ?? Date(), isDirectory: true, url: newFolderURL)
                file.fileImage=image
                
                files.append(file)
            }
            else{
                let file = File(name: newFolderURL.lastPathComponent, type: .Manga, size: attributes.fileSize ?? 0, creationDate: attributes.creationDate ?? Date(), isDirectory: true, url: newFolderURL)
                file.fileImage=image
                
                files.append(file)
            }
            
            //getFiles(inDirectory: newFolderURL)
            
        }catch{
                print("Errorrefresh: \(error.localizedDescription)")
            }
        //files = files.map { _ in  }
            
    tableView.reloadData()
        
    }
    
    func AlllistFiles(inDirectory directory: URL) {
        let keys = [URLResourceKey.creationDateKey, URLResourceKey.fileSizeKey]
        let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: keys)
        
        while let url = enumerator?.nextObject() as? URL {
            do {
                let attributes = try url.resourceValues(forKeys: Set(keys))
                let fileSize = attributes.fileSize ?? 0
                let creationDate = attributes.creationDate ?? Date()
                let fileName = url.lastPathComponent
                print("File name: \(fileName), size: \(fileSize), created on: \(creationDate)")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func currentlistFiles(inDirectory directory: URL) {
        let keys = [URLResourceKey.creationDateKey, URLResourceKey.fileSizeKey]
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: keys)
            for url in contents {
                do {
                    let attributes = try url.resourceValues(forKeys: Set(keys))
                    let fileSize = attributes.fileSize ?? 0
                    let creationDate = attributes.creationDate ?? Date()
                    let fileName = url.lastPathComponent
                    print("File name: \(fileName), size: \(fileSize), created on: \(creationDate)")
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

}
