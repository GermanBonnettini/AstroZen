//
//  CompViewController.swift
//  AstroZen
//
//  Created by Cypto Beast on 26/04/2024.
//


import UIKit
import CoreData
import GoogleMobileAds

class CompViewController: UIViewController {
    
    @IBOutlet weak var userAnimal: UIImageView!
    @IBOutlet weak var matchAnimal: UIImageView!
    @IBOutlet weak var userElement: UIImageView!
    @IBOutlet weak var matchElement: UIImageView!
    @IBOutlet weak var compText: UILabel!
    @IBOutlet weak var barraComp: UIProgressView!
    @IBOutlet weak var descText: UITextView!
    
    var attempts = 0
    var maxAttempts = 3
    var successful = false
    
    var managedObjectContext: NSManagedObjectContext!
    
    var match: Match?
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inicializa el banner de anuncios
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = "ca-app-pub-5509906576053930/8404563345"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let match = match {
                    loadUserAndMatch(match: match)
        } else {
            mostrarAlerta("Error al cargar el match seleccionado")
        }
    }
    
    func loadUserAndMatch(match: Match) {
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try managedObjectContext.fetch(userFetchRequest)
            
            guard let user = users.first else {
                mostrarAlerta("Error al cargar el usuario desde CoreData")
                return
            }
            
            // Solo hacer la petición si la descripción está vacía
            if match.descMatch?.isEmpty ?? true {
                let userRequest = "Que compatibilidad hay entre \(user.animal ?? "") de \(user.elemento ?? "") con \(match.animal ?? "") de \(match.elemento ?? "") en el horoscopo chino?. Dame una respuesta larga y muy detallada. La respuesta debe estar en formato JSON con el siguiente formato: {\"animal\": \"Perro\", \"elemento\": \"Agua\", \"descripcion\": {\"español\": \"descripción detallada en español\"}}"
                
                realizarSolicitudConReintentos(userRequest, para: match, para: user)
            } else {
                // Si ya hay una descripción, usarla directamente
                asignarDatos(animalMatch: match.animal ?? "", elementoMatch: match.elemento ?? "", animalUser: user.animal ?? "", elementoUser: user.elemento ?? "", descMatch: match.descMatch ?? "")
            }
        } catch {
            mostrarAlerta("Error al cargar el usuario desde CoreData")
        }
    }
    
    func realizarSolicitudConReintentos(_ request: String, para match: Match, para user: User) {
        attempts = 0
        successful = false
        
        makeChatRequest(request) { animal, elemento, spanishDescription, error in
            
            if error == nil {
                match.descMatch = spanishDescription
                
                do {
                    try self.managedObjectContext.save()
                    self.successful = true
                    
                    DispatchQueue.main.async {
                        self.asignarDatos(animalMatch: match.animal ?? "", elementoMatch: match.elemento ?? "", animalUser: user.animal ?? "", elementoUser: user.elemento ?? "", descMatch: match.descMatch ?? "")
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.mostrarAlerta("Error al guardar los datos en CoreData")
                    }
                }
            } else {
                self.attempts += 1
                if self.attempts < self.maxAttempts {
                    self.realizarSolicitudConReintentos(request, para: match, para: user)
                } else {
                    DispatchQueue.main.async {
                        self.mostrarAlerta("Error al conectar con el servicio después de varios intentos")
                    }
                }
            }
        }
    }
    
    func asignarDatos(animalMatch: String, elementoMatch: String, animalUser: String, elementoUser: String, descMatch: String) {
        self.matchAnimal.image = imagenParaAnimal(animal: animalMatch)
        self.matchElement.image = imagenParaElemento(elemento: elementoMatch)
        self.userAnimal.image = imagenParaAnimal(animal: animalUser)
        self.userElement.image = imagenParaElemento(elemento: elementoUser)
        self.descText.text = descMatch
        self.compText.text = "\(animalUser)  &  \(animalMatch)"
    }

    func imagenParaAnimal(animal: String) -> UIImage? {
        switch animal {
            case "Rat", "Rata":
                return UIImage(named: "rat_chuby_sf")
            case "Ox", "Buey":
                return UIImage(named: "ox_chuby_sf")
            case "Tiger", "Tigre":
                return UIImage(named: "tiger_chuby_sf")
            case "Rabbit", "Conejo":
                return UIImage(named: "rabbit_chuby_sf")
            case "Dragón", "Dragon":
                return UIImage(named: "dragon_chuby_sf")
            case "Snake", "Serpiente":
                return UIImage(named: "snake_chuby_sf")
            case "Horse", "Caballo":
                return UIImage(named: "horse_chuby_sf")
            case "Goat", "Cabra":
                return UIImage(named: "goat_chuby_sf")
            case "Monkey", "Mono":
                return UIImage(named: "monkey_chuby_sf")
            case "Rooster", "Gallo":
                return UIImage(named: "rooster_chuby_sf")
            case "Dog", "Perro":
                return UIImage(named: "dog_chuby_sf")
            case "Pig", "Cerdo":
                return UIImage(named: "pig_chuby_sf")
            default:
                return nil
        }
    }

    func imagenParaElemento(elemento: String) -> UIImage? {
        switch elemento {
            case "Water", "Agua":
                return UIImage(named: "water_chuby_sf")
            case "Metal":
                return UIImage(named: "metal_chuby_sf")
            case "Wood", "Madera":
                return UIImage(named: "wood_chuby_sf")
            case "Fire", "Fuego":
                return UIImage(named: "fuego_chuby_sf")
            case "Earth", "Tierra":
                return UIImage(named: "earth_chuby_sf")
            default:
                return nil
        }
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
