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


    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var openCameraButton: UIButton!

    lazy var imagesPath = documentPath.appendingPathComponent("Images")
    
    //MARK: - Private properties
    
    private let pickerController = UIImagePickerController()
    private let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let fileManager = FileManager.default

    private var arrayOfImages = [UIImage?]()
    private var arrayOfImagesName = [String]()
    private var numberOfImage: Int = -1
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let login = UserDefaults.standard.value(forKey: "Login") as? String {
            let newPath = imagesPath.appendingPathComponent(login)
            try? fileManager.createDirectory(at: newPath, withIntermediateDirectories: true, attributes: nil)
            print(newPath)
        } else {
            print("error")
        }
        
        navigationController?.navigationBar.isHidden = false
        choosePhotoButton.layer.cornerRadius = 10
        openCameraButton.layer.cornerRadius = 10
        choosePhotoButton.setShadow(color: UIColor.white.cgColor, offset: CGSize(width: 0, height: 0), opacity: 1, radius: 10)
        openCameraButton.setShadow(color: UIColor.white.cgColor, offset: CGSize(width: 0, height: 0), opacity: 1, radius: 10)

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

    //MARK: - IBActions
    
    @IBAction func choosePhotoButtonPressed(_ sender: Any) {
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        print("Choose photo button pressed")
    }
    
    @IBAction func openCameraButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.sourceType = .camera
            present(pickerController, animated: true)
        } else {
            showErrorAlert()
//            print("парампам")
        }
    }
    
    //MARK: - Flow functions

    func createImage() {
        arrayOfImages.removeAll()
        if let login = UserDefaults.standard.value(forKey: "Login") as? String {
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

    func showErrorAlert() {
        let errorAlert = UIAlertController(title: "Warning", message: "This device doesn't support the using camera", preferredStyle: .alert)
        let enterAction = UIAlertAction(title: "OK", style: .default)
        errorAlert.addAction(enterAction)
        present(errorAlert, animated: true)
    }
    
}

//MARK: - Extension UIImagePicker

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
            if let login = UserDefaults.standard.value(forKey: "Login") as? String {
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

//MARK: - Extensions UICollectionView

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
            
            if let login = UserDefaults.standard.value(forKey: "Login") as? String {
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
