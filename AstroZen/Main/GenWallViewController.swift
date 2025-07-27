//
//  GenWallViewController.swift
//  AstroZen
//
//  Created by Cypto Beast on 31/05/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var animalScrollView: UIScrollView!
    @IBOutlet weak var elementScrollView: UIScrollView!
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var selectButton: UIButton!
    
    let animals = ["rat_chuby_sf", "ox_chuby_sf", "tiger_chuby_sf", "rabbit_chuby_sf", "dragon_chuby_sf", "snake_chuby_sf", "horse_chuby_sf", "goat_chuby_sf", "monkey_chuby_sf", "rooster_chuby_sf", "dog_chuby_sf", "pig_chuby_sf"]
    let elements = ["water_chuby_sf", "fuego_chuby_sf", "earth_chuby_sf", "metal_chuby_sf", "wood_chuby_sf"]
    let backgrounds = ["espacio_chuby", "playa_chuby", "montaña_chuby", "ciudad_chuby"]
    
    var selectedAnimal: String?
    var selectedElement: String?
    var selectedBackground: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView(animalScrollView, with: animals, tag: 1)
        setupScrollView(elementScrollView, with: elements, tag: 2)
        setupScrollView(backgroundScrollView, with: backgrounds, tag: 3)
    }
    
    func setupScrollView(_ scrollView: UIScrollView, with items: [String], tag: Int) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        for (index, item) in items.enumerated() {
            let imageView = UIImageView(image: UIImage(named: item))
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            imageView.tag = index
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
            
            stackView.addArrangedSubview(imageView)
        }
        
        scrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        
        switch imageView.superview?.superview?.tag {
            case 1:
                selectedAnimal = animals[imageView.tag]
                let animal = selectedAnimal
                selectedAnimal = textoParaAnimal(selectedAnimal: animal ?? "")
            case 2:
                selectedElement = elements[imageView.tag]
                let elemento = selectedElement
                selectedElement = textoParaElemento(selectedElement: elemento ?? "")
            case 3:
                selectedBackground = backgrounds[imageView.tag]
                let fondo = selectedBackground
                selectedBackground = textoParaFondo(selectedBackground: fondo ?? "")
            default:
                break
        }
        
        print("Selected Animal: \(selectedAnimal ?? "")")
        print("Selected Element: \(selectedElement ?? "")")
        print("Selected Background: \(selectedBackground ?? "")")
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        guard let animal = selectedAnimal, let element = selectedElement, let background = selectedBackground else {
            print("Please make a selection in each category.")
            return
        }
        
        let selectionString = "Animal: \(animal), Element: \(element), Background: \(background)"
        print(selectionString)
        // Use the selectionString to create a wallpaper or perform other actions
    }
    
    func textoParaAnimal(selectedAnimal: String) -> String? {
        switch selectedAnimal {
            case "rat_chuby_sf":
                return "Rata"
            case "ox_chuby_sf":
                return "Buey"
            case "tiger_chuby_sf":
                return "Tigre"
            case "rabbit_chuby_sf":
                return "Conejo"
            case "dragon_chuby_sf":
                return "Dragon"
            case "snake_chuby_sf":
                return "Serpiente"
            case "horse_chuby_sf":
                return "Caballo"
            case "goat_chuby_sf":
                return "Cabra"
            case "monkey_chuby_sf":
                return "Mono"
            case "rooster_chuby_sf":
                return "Gallo"
            case "dog_chuby_sf":
                return "Perro"
            case "pig_chuby_sf":
                return "Cerdo"
            default:
                return nil
        }
    }
    
    func textoParaElemento(selectedElement: String) -> String? {
        switch selectedElement {
            case "water_chuby_sf":
                return "Agua"
            case "metal_chuby_sf":
                return "Metal"
            case "wood_chuby_sf":
                return "Madera"
            case "fuego_chuby_sf":
                return "Fuego"
            case "earth_chuby_sf":
                return "Tierra"
            default:
                return nil
        }
        
    }
    
    func textoParaFondo(selectedBackground: String) -> String? {
        switch selectedBackground {
            case "espacio_chuby":
                return "Espacio"
            case "playa_chuby":
                return "Playa"
            case "montaña_chuby":
                return "Montaña"
            case "ciudad_chuby":
                return "Ciudad"
            default:
                return nil
        }
    }
    
}
