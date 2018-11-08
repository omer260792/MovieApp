//
//  ViewController.swift
//  MovieApp
//
//  Created by Omer Cohen on 10/7/18.
//  Copyright © 2018 Omer Cohen. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    var movieArray : [movieObj] = []
    var moviesCoreData : [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ViewWillAppear
         navigationItem.title = "REST API"
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        do {
            moviesCoreData = try managedContext.fetch(fetchRequest)
            
            if (moviesCoreData.isEmpty) {
        
            }else{
                for n in 0...moviesCoreData.count-1{
                    
                    let objetToDelete = moviesCoreData[n] as! NSManagedObject
                    
                    managedContext.delete(objetToDelete)
                    
                    
                    try managedContext.save()
                    
                }
            }
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    
        let urlString = "https://api.androidhive.info/json/movies.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {

                //Decode retrived data with JSONDecoder and assing type of Article object
                let moviesData = try JSONDecoder().decode([movieObj].self, from: data)
                
                for movie in moviesData{

                    let code = ""
                    
                    //Get back to the main queue
                    DispatchQueue.main.async {
                        

                        self.save(title: movie.title, image: movie.image, rating: movie.rating, releaseYear: movie.releaseYear, genre: movie.genre, barcode: code)
                        
                    }
                    
                }

                
        
            } catch let jsonError {
                print(jsonError)
            }
            
            
            }.resume()
    }
    
    func save(title: String, image: String, rating: Double, releaseYear: Double, genre: [String], barcode: String) {
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(title, forKeyPath: "title")
        person.setValue(image, forKeyPath: "image")
        person.setValue(rating, forKeyPath: "rating")
        person.setValue(releaseYear, forKeyPath: "releaseYear")
        person.setValue(genre.description, forKeyPath: "genre")
        person.setValue(barcode, forKeyPath: "barcode")

        
        
        
        do {
            try managedContext.save()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
            _ = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }


}

struct movieObj: Codable {
    
    
    let title: String
    let image: String
    let rating: Double
    let releaseYear: Double
    let genre: [String]
    

}



