//
//  UserViewController.swift
//  AstroZen
//
//  Created by Cypto Beast on 05/04/2024.
//

//import UIKit
//import CoreData
//
//class UserViewController: UIViewController {
//    
//    
//    @IBOutlet weak var animalImage: UIImageView!
//    
//    @IBOutlet weak var elementImage: UIImageView!
//    
//    @IBOutlet weak var tituloTextField: UILabel!
//    
//    @IBOutlet weak var descTextField: UITextView!
//    
//    var managedObjectContext: NSManagedObjectContext!
//    var nombre: String = ""
//    var fecha: String = ""
//    var attempts = 0
//    var maxAttempts = 3
//    var successful = false
//    var animal: String = ""
//    var elemento: String = ""
//    var spanishDescription: String = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        managedObjectContext = appDelegate.persistentContainer.viewContext
//        
//        // Cargar el usuario desde Core Data
//        loadUser()
//    }
//    
//    func loadUser() {
//        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
//        
//        do {
//            let users = try managedObjectContext.fetch(fetchRequest)
//            if let user = users.first {
//                // Usuario encontrado, asignar datos
//                self.nombre = user.nombre ?? ""
//                self.fecha = user.fecha ?? ""
//                self.animal = user.animal ?? ""
//                self.elemento = user.elemento ?? ""
//                self.spanishDescription = user.desc ?? ""
//                asignarDatos(animal: self.animal, elemento: self.elemento, desc: self.spanishDescription)
//            } else {
//                // Usuario no encontrado, solicitar datos
//                captarUser { nombre, fecha, error in
//                    guard let nombre = nombre, let fecha = fecha, error == nil else {
//                        self.mostrarAlerta("Error al capturar los datos")
//                        return
//                    }
//                    
//                    let user = User(context: self.managedObjectContext)
//                    user.nombre = nombre
//                    user.fecha = fecha
//                    
//                    do {
//                        try self.managedObjectContext.save()
//                    } catch {
//                        DispatchQueue.main.async {
//                            self.mostrarAlerta("Error al guardar los datos en CoreData")
//                        }
//                        return
//                    }
//                    
//                    let userRequest = "Qué animal y elemento hay en esta fecha: \(fecha), en el horóscopo chino? Tráeme una descripción larga y detallada en español. La respuesta debe estar en formato JSON con el siguiente formato: {\"animal\": \"nombre del animal\", \"elemento\": \"nombre del elemento\", \"descripcion\": {\"español\": \"descripción detallada en español\"}}"
//                    
//                    self.realizarSolicitudConReintentos(userRequest, para: user)
//                }
//            }
//        } catch {
//            mostrarAlerta("Error al cargar el usuario desde CoreData")
//        }
//    }
//    
//    func realizarSolicitudConReintentos(_ request: String, para user: User) {
//        attempts = 0
//        successful = false
//        
//        while attempts < maxAttempts && !successful {
//            attempts += 1
//            
//            makeChatRequest(request) { animal, elemento, spanishDescription, error in
//                if error == nil, let animal = animal, let elemento = elemento, let spanishDescription = spanishDescription {
//                    user.animal = animal
//                    user.elemento = elemento
//                    user.desc = spanishDescription
//                    
//                    do {
//                        try self.managedObjectContext.save()
//                        self.successful = true
//                        
//                        DispatchQueue.main.async {
//                            self.asignarDatos(animal: animal, elemento: elemento, desc: spanishDescription)
//                        }
//                    } catch {
//                        DispatchQueue.main.async {
//                            self.mostrarAlerta("Error al guardar los datos en CoreData")
//                        }
//                    }
//                } else {
//                    if self.attempts == self.maxAttempts {
//                        DispatchQueue.main.async {
//                            self.mostrarAlerta("Error al conectar con el servicio después de varios intentos")
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func mostrarAlerta(_ mensaje: String) {
//        let alertController = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "Aceptar", style: .cancel)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
//    
//    func captarUser(completion: @escaping (String?, String?, Error?) -> Void) {
//        let alertController = UIAlertController(title: "Busca tu animal", message: nil, preferredStyle: .alert)
//        
//        alertController.addTextField { (nameTextField) in
//            nameTextField.placeholder = "Nombre"
//        }
//        
//        alertController.addTextField { (fechaTextField) in
//            fechaTextField.placeholder = "Apodo"
//        }
//        
//        alertController.addTextField { (fechaTextField) in
//            fechaTextField.placeholder = "Fecha"
//            fechaTextField.isEnabled = false
//        }
//        
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
//        alertController.view.addSubview(datePicker)
//        
//        // Configurar el datePicker
//        datePicker.translatesAutoresizingMaskIntoConstraints = false
//        datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 120).isActive = true
//        datePicker.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 20).isActive = true
//        datePicker.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -20).isActive = true
//        
//        let addAction = UIAlertAction(title: "Agregar", style: .default) { (_) in
//            if let name = alertController.textFields?.first?.text {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "dd/MM/yyyy"
//                
//                let fecha = dateFormatter.string(from: datePicker.date)
//                completion(name, fecha, nil)
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
//            completion(nil, nil, nil) // Si se cancela, pasa la fecha actual y nil para el nombre
//        }
//        
//        alertController.addAction(addAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
//    
//    func asignarDatos(animal: String, elemento: String, desc: String) {
//        switch animal {
//            case "Rat", "Rata":
//                self.animalImage.image = UIImage(named: "rat_chuby_sf")
//            case "Ox", "Buey":
//                self.animalImage.image = UIImage(named: "ox_chuby_sf")
//            case "Tiger", "Tigre":
//                self.animalImage.image = UIImage(named: "tiger_chuby_sf")
//            case "Rabbit", "Conejo":
//                self.animalImage.image = UIImage(named: "rabbit_chuby_sf")
//            case "Dragón", "Dragon":
//                self.animalImage.image = UIImage(named: "dragon_chuby_sf")
//            case "Snake", "Serpiente":
//                self.animalImage.image = UIImage(named: "snake_chuby_sf")
//            case "Horse", "Caballo":
//                self.animalImage.image = UIImage(named: "horse_chuby_sf")
//            case "Goat", "Cabra":
//                self.animalImage.image = UIImage(named: "goat_chuby_sf")
//            case "Monkey", "Mono":
//                self.animalImage.image = UIImage(named: "monkey_chuby_sf")
//            case "Rooster", "Gallo":
//                self.animalImage.image = UIImage(named: "rooster_chuby_sf")
//            case "Dog", "Perro":
//                self.animalImage.image = UIImage(named: "dog_chuby_sf")
//            case "Pig", "Cerdo":
//                self.animalImage.image = UIImage(named: "pig_chuby_sf")
//            default:
//                return
//        }
//        
//        switch elemento {
//            case "Water", "Agua":
//                self.elementImage.image = UIImage(named: "water_chuby_sf")
//            case "Metal":
//                self.elementImage.image = UIImage(named: "metal_chuby_sf")
//            case "Wood", "Madera":
//                self.elementImage.image = UIImage(named: "wood_chuby_sf")
//            case "Fire", "Fuego":
//                self.elementImage.image = UIImage(named: "fuego_chuby_sf")
//            case "Earth", "Tierra":
//                self.elementImage.image = UIImage(named: "earth_chuby_sf")
//            default:
//                return
//        }
//        
//        self.tituloTextField.text = "\(animal)   de   \(elemento)"
//        self.descTextField.text = desc
//    }
//}
import UIKit
import CoreData

class UserViewController: UIViewController {
    
    @IBOutlet weak var animalImage: UIImageView!
    @IBOutlet weak var elementImage: UIImageView!
    @IBOutlet weak var tituloTextField: UILabel!
    @IBOutlet weak var descTextField: UITextView!
    
    var managedObjectContext: NSManagedObjectContext!
    var nombre: String = ""
    var fecha: String = ""
    var attempts = 0
    var maxAttempts = 3
    var successful = false
    var animal: String = ""
    var elemento: String = ""
    var spanishDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // Configurar fondos
        configurarFondoPara(tituloTextField)
        configurarFondoPara(descTextField)
        
        // Cargar el usuario desde Core Data
        loadUser()
    }
    
    func configurarFondoPara(_ label: UILabel) {
        let backgroundImage = UIImage(named: "papyrus.png")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = label.bounds
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        label.addSubview(backgroundImageView)
        label.sendSubviewToBack(backgroundImageView)
        label.backgroundColor = .clear
    }
    
    func configurarFondoPara(_ textView: UITextView) {
        let backgroundImage = UIImage(named: "papyrus.png")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = textView.bounds
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        textView.addSubview(backgroundImageView)
        textView.sendSubviewToBack(backgroundImageView)
        textView.backgroundColor = .clear
    }
    
    func loadUser() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try managedObjectContext.fetch(fetchRequest)
            if let user = users.first {
                // Usuario encontrado, asignar datos
                self.nombre = user.nombre ?? ""
                self.fecha = user.fecha ?? ""
                self.animal = user.animal ?? ""
                self.elemento = user.elemento ?? ""
                self.spanishDescription = user.desc ?? ""
                asignarDatos(animal: self.animal, elemento: self.elemento, desc: self.spanishDescription)
            } else {
                // Usuario no encontrado, solicitar datos
                captarUser { nombre, fecha, error in
                    guard let nombre = nombre, let fecha = fecha, error == nil else {
                        self.mostrarAlerta("Error al capturar los datos")
                        return
                    }
                    
                    let user = User(context: self.managedObjectContext)
                    user.nombre = nombre
                    user.fecha = fecha
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        DispatchQueue.main.async {
                            self.mostrarAlerta("Error al guardar los datos en CoreData")
                        }
                        return
                    }
                    
                    let userRequest = "Qué animal y elemento hay en esta fecha: \(fecha), en el horóscopo chino? Tráeme una descripción larga y detallada en español. La respuesta debe estar en formato JSON con el siguiente formato: {\"animal\": \"nombre del animal\", \"elemento\": \"nombre del elemento\", \"descripcion\": {\"español\": \"descripción detallada en español\"}}"
                    
                    self.realizarSolicitudConReintentos(userRequest, para: user)
                }
            }
        } catch {
            mostrarAlerta("Error al cargar el usuario desde CoreData")
        }
    }
    
    func realizarSolicitudConReintentos(_ request: String, para user: User) {
        attempts = 0
        successful = false
        
        while attempts < maxAttempts && !successful {
            attempts += 1
            
            makeChatRequest(request) { animal, elemento, spanishDescription, error in
                if error == nil, let animal = animal, let elemento = elemento, let spanishDescription = spanishDescription {
                    user.animal = animal
                    user.elemento = elemento
                    user.desc = spanishDescription
                    
                    do {
                        try self.managedObjectContext.save()
                        self.successful = true
                        
                        DispatchQueue.main.async {
                            self.asignarDatos(animal: animal, elemento: elemento, desc: spanishDescription)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.mostrarAlerta("Error al guardar los datos en CoreData")
                        }
                    }
                } else {
                    if self.attempts == self.maxAttempts {
                        DispatchQueue.main.async {
                            self.mostrarAlerta("Error al conectar con el servicio después de varios intentos")
                        }
                    }
                }
            }
        }
    }
    
    func mostrarAlerta(_ mensaje: String) {
        let alertController = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Aceptar", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func captarUser(completion: @escaping (String?, String?, Error?) -> Void) {
        let alertController = UIAlertController(title: "Busca tu animal", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Nombre"
        }
        
        alertController.addTextField { (fechaTextField) in
            fechaTextField.placeholder = "Apodo"
        }
        
        alertController.addTextField { (fechaTextField) in
            fechaTextField.placeholder = "Fecha"
            fechaTextField.isEnabled = false
        }
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        alertController.view.addSubview(datePicker)
        
        // Configurar el datePicker
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 120).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 20).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -20).isActive = true
        
        let addAction = UIAlertAction(title: "Agregar", style: .default) { (_) in
            if let name = alertController.textFields?.first?.text {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                
                let fecha = dateFormatter.string(from: datePicker.date)
                completion(name, fecha, nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
            completion(nil, nil, nil) // Si se cancela, pasa la fecha actual y nil para el nombre
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
        self.descTextField.text = desc
    }
}
