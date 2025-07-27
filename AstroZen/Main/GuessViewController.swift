//
//  GuessViewController.swift
//  AstroZen
//
//  Created by Cypto Beast on 28/05/2024.
//

import UIKit
import CoreData
import GoogleMobileAds

class GuessViewController: UIViewController {
    
    @IBOutlet weak var animalImage: UIImageView!
    
    @IBOutlet weak var elementImage: UIImageView!
    
    @IBOutlet weak var tituloTextField: UILabel!
    
    @IBOutlet weak var descTextView: UITextView!
    
    var bannerView: GADBannerView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var match: Match?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inicializa el banner de anuncios
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-5452031297260034/9529394011"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        asignarDatos(animal: match?.animal ?? "", elemento: match?.elemento ?? "", desc: match?.descAnimal ?? "")
        
        
        
    }
    
    func asignarDatos(animal: String, elemento: String, desc: String) {
        switch animal {
            case "Rat", "Rata":
                self.animalImage.image = UIImage(named: "rat_chuby_sf")
            case "Ox", "Buey":
                self.animalImage.image = UIImage(named: "ox_chuby_sf")
            case "Tiger", "Tigre":
                self.animalImage.image = UIImage(named: "tiger_chuby_sf")
            case "Rabbit", "Conejo":
                self.animalImage.image = UIImage(named: "rabbit_chuby_sf")
            case "Dragón", "Dragon":
                self.animalImage.image = UIImage(named: "dragon_chuby_sf")
            case "Snake", "Serpiente":
                self.animalImage.image = UIImage(named: "snake_chuby_sf")
            case "Horse", "Caballo":
                self.animalImage.image = UIImage(named: "horse_chuby_sf")
            case "Goat", "Cabra":
                self.animalImage.image = UIImage(named: "goat_chuby_sf")
            case "Monkey", "Mono":
                self.animalImage.image = UIImage(named: "monkey_chuby_sf")
            case "Rooster", "Gallo":
                self.animalImage.image = UIImage(named: "rooster_chuby_sf")
            case "Dog", "Perro":
                self.animalImage.image = UIImage(named: "dog_chuby_sf")
            case "Pig", "Cerdo":
                self.animalImage.image = UIImage(named: "pig_chuby_sf")
            default:
                return
        }
        
        switch elemento {
            case "Water", "Agua":
                self.elementImage.image = UIImage(named: "water_chuby_sf")
            case "Metal":
                self.elementImage.image = UIImage(named: "metal_chuby_sf")
            case "Wood", "Madera":
                self.elementImage.image = UIImage(named: "wood_chuby_sf")
            case "Fire", "Fuego":
                self.elementImage.image = UIImage(named: "fuego_chuby_sf")
            case "Earth", "Tierra":
                self.elementImage.image = UIImage(named: "earth_chuby_sf")
            default:
                return
        }
        
        self.tituloTextField.text = "\(animal)   de   \(elemento)"
        self.descTextView.text = desc
    }
    
    func mostrarAlerta(_ mensaje: String) {
        let alertController = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Aceptar", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
}
