//
//  PreviewViewController.swift
//  MovieApp
//
//  Created by Omer Cohen on 10/8/18.
//  Copyright © 2018 Omer Cohen. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData


class PreviewViewController: UIViewController {

    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var ratingLab: UILabel!
    @IBOutlet weak var yearLab: UILabel!
    
    @IBOutlet weak var genreLab: UILabel!
    var movie: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {return}
        
       imageView.sd_setImage(with: URL(string: movie.value(forKey: "image") as! String), placeholderImage: UIImage(named: "defaultImg.png"))
    

        titleLab.text = movie.value(forKey: "title") as! String
        ratingLab.text = String(movie.value(forKey: "rating") as! Double)
        yearLab.text = String(movie.value(forKey: "releaseYear") as! Double)
        barcodeLabel.text = movie.value(forKey: "barcode") as! String

        
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
        
        genreLab.text = endstring

    }
    

 
}
