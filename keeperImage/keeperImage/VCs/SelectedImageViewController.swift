//
//  SelectedImageViewController.swift
//  keeperImage
//
//  Created by Ekaterina Abramova on 20.12.2020.
//

//swiftlint:disable all

import UIKit

class SelectedImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileManager = FileManager.default
    var image = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(processSwipe(_:)))
        rightSwipeGesture.direction = .right
        let leftSwipeDirection = UISwipeGestureRecognizer(target: self, action: #selector(processSwipe(_:)))
        leftSwipeDirection.direction = .left

        view.addGestureRecognizer(rightSwipeGesture)
        view.addGestureRecognizer(leftSwipeDirection)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = image

    }
    
    @objc func processSwipe(_ swipeGesture: UISwipeGestureRecognizer) {
        if let imagePath = UserDefaults.standard.value(forKey: "ImagePathKey") as? String {
            if let image = UIImage(contentsOfFile: imagePath) {
                print(image)
                switch swipeGesture.direction {
                case .left:
                    print("Swipe to left")
                    imageView.image = image
                case .right:
                    print("Swipe to right")
                    imageView.image = image
                default:
                    print("")
                }
            }
        }
        
    }

    @IBAction func shareImageButtonPressed(_ sender: Any) {
        if let imagePath = UserDefaults.standard.value(forKey: "ImagePathKey") as? String {
            if let image = UIImage(contentsOfFile: imagePath) {
                print(image)
                let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                present(ac, animated: true)
            }
        }
    }

    @IBAction func deleteImageButtonPressed(_ sender: Any) {
        if let index = UserDefaults.standard.value(forKey: "NumberKey") as? Int,
           let arrayNames = UserDefaults.standard.value(forKey: "ArrayNameKey") as? [String],
           let imagePath = UserDefaults.standard.value(forKey: "ImagePathKey") as? String {
            let alert = UIAlertController(title: "Delete image", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                if self.fileManager.fileExists(atPath: imagePath) {
                    do {
                        try self.fileManager.removeItem(atPath: imagePath)
                    } catch {
                        print(error)
                    }
                }
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }
    }
}
