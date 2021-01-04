//
//  KeeperViewController.swift
//  keeperImage
//
//  Created by Ekaterina Abramova on 12.12.2020.
//

//swiftlint:disable all

import UIKit
import SwiftyKeychainKit

class KeeperViewController: UIViewController {

    private let pickerController = UIImagePickerController()
    let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileManager = FileManager.default
    lazy var imagesPath = documentPath.appendingPathComponent("Images")
    var numberOfImage: Int = -1
    var logins = [String]()
    var login: String?

    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

//    var arrayOfImages: [UIImage?] = [
//        UIImage(named: "image1"),
//        UIImage(named: "image2"),
//        UIImage(named: "image3"),
//        UIImage(named: "image4"),
//        UIImage(named: "image5"),
//        UIImage(named: "image6"),
//        UIImage(named: "image7")
//    ]

    var arrayOfImages = [UIImage?]()
    var arrayOfImagesName = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let login = login {
            let newPath = imagesPath.appendingPathComponent(login)
            try? fileManager.createDirectory(at: newPath, withIntermediateDirectories: true, attributes: nil)
            print(newPath)
        } else {
            print("error")
        }
        
//        if let login = UserDefaults.standard.value(forKey: "Login") as? String {
//            print(imagesPath)
//            let newPath = imagesPath.appendingPathComponent(login)
//            try? fileManager.createDirectory(at: newPath, withIntermediateDirectories: true, attributes: nil)
//            print(newPath)
//        } else {
//            print("error")
//        }
        
        navigationController?.navigationBar.isHidden = false
        choosePhotoButton.layer.cornerRadius = 10

        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        pickerController.delegate = self

        collectionView.dataSource = self
        collectionView.delegate = self
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        createImage()
        collectionView.reloadData()
    }

    func createImage() {
        arrayOfImages.removeAll()
        if let login = login {
            if let imageNames = try? fileManager.contentsOfDirectory(atPath: "\(imagesPath.path)/\(login)") {
                for imageName in imageNames {
                    if let image = UIImage(contentsOfFile: "\(imagesPath.path)/\(login)/\(imageName)") {
                        arrayOfImages.append(image)
                        arrayOfImagesName.append(imageName)
                    }
                }
            }
        }
    }

    @IBAction func choosePhotoButtonPressed(_ sender: Any) {
        present(pickerController, animated: true)
        print("Choose photo button pressed")
    }
    
    func checkLogins() {
//        for user in
    }

}

extension KeeperViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {

            if fileManager.fileExists(atPath: imagesPath.path) == false {
                do {
                    try fileManager.createDirectory(atPath: imagesPath.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    print(error)
                }
            }
            print("Image is selected")
            arrayOfImages.append(image)
            let data = image.jpegData(compressionQuality: 1)
            let imageName = "\(Date().timeIntervalSince1970).png"
            arrayOfImagesName.append(imageName)
            if let login = login {
                let folderPath = "\(imagesPath.path)/\(login)"
                print(folderPath)
                if fileManager.createFile(atPath: "\(folderPath)/\(imageName)", contents: data, attributes: nil) {
                    print("yes")
                } else {
                    print("no")
                }
            }
            
            
        }
        collectionView.reloadData()
        picker.dismiss(animated: true)
    }
}

extension KeeperViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let nameController = String(describing: ImageCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nameController,
                                                            for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = arrayOfImages[indexPath.item]
        cell.imageView.contentMode = .scaleAspectFill
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nameController = String(describing: SelectedImageViewController.self)
        let selectedImageViewController = storyboard.instantiateViewController(identifier: nameController) as SelectedImageViewController
        navigationController?.pushViewController(selectedImageViewController, animated: true)
        if let image = arrayOfImages[indexPath.item] {
            selectedImageViewController.image = image
            numberOfImage = indexPath.item
//            print(numberOfImage)
//            print(arrayOfImagesName)
            UserDefaults.standard.setValue(arrayOfImagesName, forKey: "ArrayNameKey")
            UserDefaults.standard.setValue(numberOfImage, forKey: "NumberKey")
            let absoluteString = documentPath.absoluteString
            
            if let login = login {
                let imagePath = "\(absoluteString)Images/\(login)/\(arrayOfImagesName[numberOfImage])".replacingOccurrences(of: "file://", with: "")
                print(imagePath)
                UserDefaults.standard.setValue(imagePath, forKey: "ImagePathKey")
            }
            
        }
    }
}

extension KeeperViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 10, height: (view.frame.width / 3) - 10)
    }
}
