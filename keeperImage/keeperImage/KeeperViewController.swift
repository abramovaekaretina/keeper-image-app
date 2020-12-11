//
//  KeeperViewController.swift
//  keeperImage
//
//  Created by Ekaterina Abramova on 12.12.2020.
//

import UIKit

class KeeperViewController: UIViewController {
    
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let pickerController = UIImagePickerController()
    
    var arrayOfImages: [UIImage?] = [
        UIImage(named: "image1"),
        UIImage(named: "image2"),
        UIImage(named: "image3"),
        UIImage(named: "image4"),
        UIImage(named: "image5"),
        UIImage(named: "image6"),
        UIImage(named: "image7")
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        choosePhotoButton.layer.cornerRadius = 10
        choosePhotoButton.setShadow(offset: CGSize(width: 0, height: 0), opacity: 0.2, radius: 4)
        
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        pickerController.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func choosePhotoButtonPressed(_ sender: Any) {
        present(pickerController, animated: true)
        print("Choose photo button pressed")
    }

}

extension KeeperViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            print("Image is selected")
            arrayOfImages.append(image)
//            UserDefaults.standard.setValue(arrayOfImages, forKey: "ArrayKey")
            collectionView.reloadData()
        }
        picker.dismiss(animated: true)
    }
    
}

extension KeeperViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionViewCell.self ), for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = arrayOfImages[indexPath.item]
        cell.imageView.contentMode = .scaleAspectFill
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 10, height: (view.frame.width / 3) - 10)
    }
    
}

