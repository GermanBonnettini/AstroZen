//
//  MatchViewController.swift
//  AstroZen
//
//  Created by Cypto Beast on 05/04/2024.
//

import UIKit
import CoreData

class MatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var people = [Match]()
    var managedObjectContext: NSManagedObjectContext!
    
    var attempts = 0
    var maxAttempts = 3
    var successful = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // Cargo personas guardadas
        loadPeople()
        
        
        
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Nombre", for: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = person.nombre
       
        
        return cell
    }
    
    
    // MARK: - Core Data
    
    func loadPeople() {
        let fetchRequest: NSFetchRequest<Match> = Match.fetchRequest()
        do {
            people = try managedObjectContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error al cargar personas: \(error.localizedDescription)")
        }
    }
    
    func savePerson(name: String, apodo: String, fecha: String) {
        let persona = Match(context: managedObjectContext)
            persona.nombre = name
            persona.apodo = apodo
            persona.fecha = fecha
            
            // Asignar valores predeterminados para animal, elemento y descripcion si es necesario
            if persona.animal == nil {
                let userRequest = "Qué animal y elemento hay en esta fecha: \(persona.fecha ?? "nil"), en el horóscopo chino? Tráeme una descripción larga y detallada en español. La respuesta debe estar en formato JSON con el siguiente formato: {\"animal\": \"nombre del animal\", \"elemento\": \"nombre del elemento\", \"descripcion\": {\"español\": \"descripción detallada en español\"}}"
                realizarSolicitudConReintentos(userRequest, para: persona)
            }
            
            do {
                try managedObjectContext.save()
                people.append(persona)
                tableView.reloadData()
            } catch {
                print("Error al guardar persona: \(error.localizedDescription)")
            }
        }
    
    func deletePerson(at indexPath: IndexPath) {
        let person = people[indexPath.row]
        managedObjectContext.delete(person)
        do {
            try managedObjectContext.save()
            people.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Error al eliminar persona: \(error.localizedDescription)")
        }
    }
    
    @IBAction func addPersonAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Agregar Persona", message: nil, preferredStyle: .alert)
        
        // Agrego el primer campo de texto para el nombre
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Nombre"
        }
        
        // Agrego el segundo campo de texto para el apodo
        alertController.addTextField { (apodoTextField) in
            apodoTextField.placeholder = "Apodo"
        }
        
        // Agrego el tercer campo solo visual
        alertController.addTextField { (fechaTextField) in
            fechaTextField.placeholder = "Fecha"
            fechaTextField.isEnabled = false
        }
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        alertController.view.addSubview(datePicker)
        
        let addAction = UIAlertAction(title: "Agregar", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            if let name = alertController.textFields?.first?.text, !name.isEmpty {
               let apodo = alertController.textFields?[1].text
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let fecha = dateFormatter.string(from: datePicker.date)
                self.savePerson(name: name, apodo: apodo!, fecha: fecha)
            } else {
                self.mostrarAlerta("Nombre y Apodo no pueden estar vacíos")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 120),
                datePicker.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 20),
                datePicker.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -20)
            ])
        }
    }
        
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Llamo a la función deletePerson para eliminar la persona de la lista y de CoreData
            deletePerson(at: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Creo la acción de eliminar
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] (_, _, completionHandler) in
            self?.deletePerson(at: indexPath)
            completionHandler(true)
        }
        
        // Personalizo la apariencia del botón de eliminar
        deleteAction.image = UIImage(systemName: "trash")
        
        // Configuro la apariencia de la acción de deslizar
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }

    func realizarSolicitudConReintentos(_ request: String, para match: Match) {
        attempts = 0
        successful = false
        
        while attempts < maxAttempts && !successful {
            attempts += 1
            
            makeChatRequest(request) { animal, elemento, spanishDescription, error in
                if error == nil, let animal = animal, let elemento = elemento, let spanishDescription = spanishDescription {
                    match.animal = animal
                    match.elemento = elemento
                    match.descAnimal = spanishDescription
                    
                    do {
                        try self.managedObjectContext.save()
                        self.successful = true
                        
                        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMatch = people[indexPath.row]
        
        let alertController = UIAlertController(title: "Seleccione una opción", message: nil, preferredStyle: .actionSheet)
        
        let verAnimalAction = UIAlertAction(title: "Ver Animal", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: "Guess", sender: selectedMatch)
        }
        
        let verCompatibilidadAction = UIAlertAction(title: "Ver Compatibilidad", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: "Comp", sender: selectedMatch)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(verAnimalAction)
        alertController.addAction(verCompatibilidadAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    

    
    func mostrarAlerta(_ mensaje: String) {
        let alertController = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Aceptar", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Comp",
           let destinationVC = segue.destination as? CompViewController,
           let selectedMatch = sender as? Match {
            
            print("Passing to CompViewController: \(selectedMatch.nombre ?? "No nombre")")
            destinationVC.match = selectedMatch
            destinationVC.managedObjectContext = self.managedObjectContext
        }
        
        if segue.identifier == "Guess",
           let destinationVC = segue.destination as? GuessViewController,
           let selectedMatch = sender as? Match {
            
            print("Passing to GuessViewController: \(selectedMatch.nombre ?? "No nombre")")
            destinationVC.match = selectedMatch
            destinationVC.managedObjectContext = self.managedObjectContext
        }
    }
}
