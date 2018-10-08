//
//  EnterMovieViewController.swift
//  MovieApp
//
//  Created by Omer Cohen on 10/8/18.
//  Copyright © 2018 Omer Cohen. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage


class EnterMovieViewController: UIViewController,  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    var moviesCoreData : [NSManagedObject] = []
        let imagePicker = UIImagePickerController()
    var imageCapture = ""

    
    @IBAction func getCamera(_ sender: UIImageView) {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)

    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingTxtF: UITextField!
    @IBOutlet weak var titleTxtF: UITextField!
    @IBOutlet weak var genreTxtF: UITextField!
    @IBOutlet weak var yearTxtF: UITextField!
    


    @IBAction func saveMovieBtn(_ sender: UIButton) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let titleS:String = titleTxtF.text ?? "title"
        let ratingS:Double = Double((ratingTxtF.text) as! String ) ?? 0
        let releaseYearS:Double = Double((yearTxtF.text)  as! String ) ?? 0
        let genreS:String = genreTxtF.text ?? "genre"
        let barcode = appDelegate.barcode ?? "barcode"

    
        self.save(title: titleS, image: imageCapture, rating: ratingS, releaseYear: releaseYearS, genre: genreS, barcode: barcode)
    
        self.navigationController?.popViewController(animated: true)
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        
        do {
            moviesCoreData = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    func save(title: String, image: String, rating: Double, releaseYear: Double, genre: String, barcode: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
        let movie = NSManagedObject(entity: entity, insertInto: managedContext)
        movie.setValue(title, forKeyPath: "title")
        movie.setValue(image, forKeyPath: "image")
        movie.setValue(rating, forKeyPath: "rating")
        movie.setValue(releaseYear, forKeyPath: "releaseYear")
        movie.setValue(genre.description, forKeyPath: "genre")
        movie.setValue(barcode, forKey: "barcode")
        appDelegate.movies.append(movie)

        
        do {
            try managedContext.save()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
            
            let test = try managedContext.fetch(fetchRequest)
            
            for movie in test{
                
                print(movie.value(forKey: "genre"))
                
            }
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            var url = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
            
            imageCapture = url.absoluteString!
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage

        }
        
        picker.dismiss(animated: true, completion: nil)

    }
    
    
}


