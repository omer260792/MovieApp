//
//  TableViewController.swift
//  MovieApp
//
//  Created by Omer Cohen on 10/7/18.
//  Copyright © 2018 Omer Cohen. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage


class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var movies : [NSManagedObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        movies =  (appDelegate.movies)
        print(movies)
        var sortedArray = movies.sorted(by: { ($0.value(forKey: "releaseYear") as! Double) > ($1.value(forKey: "releaseYear") as! Double) })
        movies = sortedArray
        print(sortedArray)
        tableView.reloadData()
    
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        


        
        
    
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        do {
            ///////
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
            
            let test = try managedContext.fetch(fetchRequest)
            
            
            

            for movie in test{
                
                //print(movies)

                appDelegate.movies.append(movie)


               // print(movie.value(forKey: "genre"))
                
            }

           
            movies = appDelegate.movies

            tableView.reloadData()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! TableViewCell
        
        
        let movie = movies[indexPath.row]


        
        cell.titleLabel.text = movie.value(forKey: "title") as! String
        cell.ratingLabel.text = String(movie.value(forKey: "rating") as! Double)
        cell.yearLabel.text = String(movie.value(forKey: "releaseYear") as! Double)
        cell.genreLabel.text = movie.value(forKey: "genre") as! String
        cell.imageview.sd_setImage(with: URL(string: movie.value(forKey: "image") as! String), placeholderImage: UIImage(named: "defaultImg.png"))
        
        var str = movie.value(forKey: "genre") as! String
        var res = str.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
        res = res.trim("]")
        var characters : [Character]
        var string : [String] = []
        var endstring : String = ""
        
        string = res.components(separatedBy: "\"")
        

        for n in 0...string.count-1{
endstring = endstring + string[n]
            
        
        }

        cell.genreLabel.text = endstring

        return cell    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //segue
        performSegue(withIdentifier: "SegueForItem", sender: self)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PreviewViewController {
            
            var movie = movies[(tableView.indexPathForSelectedRow?.row)!]
            
            dest.movie  = movie
        }
    }

}


extension String {
    
    func trim(_ string: String) -> String {
        var set = Set<Character>()
        for c in string.characters {
            set.insert(Character(String(c)))
        }
        return trim(set)
    }
    
    func trim(_ characters: Set<Character>) -> String {
        if let index = self.characters.index(where: {!characters.contains($0)}) {
            return String(self[index..<self.endIndex])
        } else {
            return ""
        }
    }
    
}
