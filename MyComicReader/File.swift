//
//  File.swift
//  MyComicReader
//
//  Created by zirui huang on 3/6/23.
//

import Foundation
import UIKit

var files: [File] = []

var Dfiles: [File] = []
//var MarkIndex:Int!
//var images: [UIImage] = []
var backgroundcolor: UIColor!

var gap: CGFloat = 0

var isblack: Int = 0
//currentlistFiles(inDirectory: <#URL#>)
func findFirstImage(inDirectory directory: URL) -> UIImage? {
    let keys = [URLResourceKey.creationDateKey, URLResourceKey.fileSizeKey]
    do {
        let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: keys, options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
            print("Error: \(error.localizedDescription)")
            return true
        })!
        
        // Filter the enumerator to include only image files
        let imageFiles = enumerator.allObjects.filter { (url) -> Bool in
            return (url as! URL).isFileURL && ["jpg", "jpeg", "png", "gif"].contains((url as! URL).pathExtension.lowercased())
        }
        let sortedImageFiles = imageFiles.sorted { (url1, url2) -> Bool in
                    return (url1 as! URL).lastPathComponent < (url2 as! URL).lastPathComponent
                }
        
        
        // Get the URL of the first image file
        if let imageUrl = sortedImageFiles.first as? URL {
            return UIImage(contentsOfFile: imageUrl.path)
        }
    } catch {
        print("Error: \(error.localizedDescription)")
    }
    
    // If no image files were found, return nil
    return nil
}

func getFiles(inDirectory directory: URL) {
    let keys = [URLResourceKey.creationDateKey, URLResourceKey.fileSizeKey]
    do {
        let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: keys)
        for url in contents {
            do {
                let attributes = try url.resourceValues(forKeys: Set(keys))
                let fileSize = attributes.fileSize ?? 0
                let creationDate = attributes.creationDate ?? Date()
                let fileName = url.lastPathComponent
                let image = findFirstImage(inDirectory: url)
                if image == nil{
                    _ = File(name: fileName, type: .Manga, size: fileSize, creationDate: creationDate, isDirectory: true, url: url)
                }
                else{
                    _ = File(name: fileName, type: .Undefined, size: fileSize, creationDate: creationDate, isDirectory: true, url: url)
                }
                let file = File(name: fileName, type: .Manga, size: fileSize, creationDate: creationDate, isDirectory: true, url: url)
                file.fileImage = image
                files.append(file)
                print("File name: \(fileName), size: \(fileSize), created on: \(creationDate)")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

func AlllistImage(inDirectory directory: URL) {
    let keys = [URLResourceKey.creationDateKey, URLResourceKey.fileSizeKey]
    let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: keys)
    
    while let url = enumerator?.nextObject() as? URL {
        do {
            let attributes = try url.resourceValues(forKeys: Set(keys))
            let fileSize = attributes.fileSize ?? 0
            let creationDate = attributes.creationDate ?? Date()
            let fileName = url.lastPathComponent
            if let imageData = try? Data(contentsOf: url),
                    var image = UIImage(data: imageData) {
                //black function
                if isblack == 1{
                    let context = CIContext(options: nil)
                    let currentFilter = CIFilter(name: "CIPhotoEffectMono")
                    currentFilter!.setValue(CIImage(image: image), forKey: kCIInputImageKey)
                    let output = currentFilter!.outputImage
                    let cgimg = context.createCGImage(output!, from: output!.extent)
                    let processedImage = UIImage(cgImage: cgimg!)
                    image = processedImage
                }
                
                    let file = File(name: fileName, type: .Manga, size: fileSize, creationDate: creationDate, isDirectory: false, url: url)
                    file.fileImage = image
                    Dfiles.append(file)
                
                }
            Dfiles = Dfiles.sorted { $0.name < $1.name }
            print("File name: \(fileName), size: \(fileSize), created on: \(creationDate)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

class File {
    
    var contents: [File] = []
    enum `Type`: String {
        case Undefined = "Undefined"
        //case Comicbook = "Comicbook"
        case Manga = "Manga"
    }
    var url: URL
    var type: Type
    var name: String
    var size: Int
    var creationDate: Date
    var fileImage: UIImage?
    var isDirectory: Bool
    
    init(name: String, type: Type, size: Int, creationDate: Date, isDirectory: Bool, url:URL) {
        self.type = type
        self.name = name
        self.size = size
        self.creationDate = creationDate
        //self.fileImage = fileImage
        self.isDirectory = isDirectory
        self.url = url
    }
    let fileManager = FileManager.default
    
}
