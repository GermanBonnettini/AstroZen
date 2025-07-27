//
//  WallViewController.swift
//  AstroZen
//
//  Created by Cypto Beast on 09/04/2024.
//

import UIKit

class WallViewController: UIViewController {
    
    @IBOutlet weak var animalScrollView: UIScrollView!
    
    @IBOutlet weak var elementScrollView: UIScrollView!
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    
    
    let animals = ["rat_chuby_sf", "ox_chuby_sf", "tiger_chuby_sf", "rabbit_chuby_sf", "dragon_chuby_sf", "snake_chuby_sf", "horse_chuby_sf", "goat_chuby_sf", "monkey_chuby_sf", "rooster_chuby_sf", "dog_chuby_sf", "pig_chuby_sf"]
    let elements = ["water_chuby_sf", "fuego_chuby_sf", "earth_chuby_sf", "metal_chuby_sf", "wood_chuby_sf"]
    let backgrounds = ["espacio_chuby", "playa_chuby", "montana_chuby", "ciudad_chuby"]
    
    var selectedAnimal: String?
    var selectedElement: String?
    var selectedBackground: String?
    
    var animalImageViews: [UIImageView] = []
    var elementImageViews: [UIImageView] = []
    var backgroundImageViews: [UIImageView] = []
    
    
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
            stackView.spacing = 9
            
            var imageViewArray: [UIImageView] = []
            
            for (index, item) in items.enumerated() {
                let imageView = UIImageView(image: UIImage(named: item))
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true
                imageView.tag = index
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
                imageView.addGestureRecognizer(tapGesture)
                
                // Configurar constraints del UIImageView
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
                
                stackView.addArrangedSubview(imageView)
                imageViewArray.append(imageView)
            }
            
            scrollView.addSubview(stackView)
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            
            switch tag {
            case 1:
                animalImageViews = imageViewArray
            case 2:
                elementImageViews = imageViewArray
            case 3:
                backgroundImageViews = imageViewArray
            default:
                break
            }
        }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        
        // Restablecer los fondos de las imágenes no seleccionadas
        switch imageView.superview?.superview?.tag {
            case 1:
                selectedAnimal = animals[imageView.tag]
                resetImageViewBackgrounds(in: animalImageViews)
                imageView.backgroundColor = UIColor.purple.withAlphaComponent(0.5) // Fondo semi-transparente
            case 2:
                selectedElement = elements[imageView.tag]
                resetImageViewBackgrounds(in: elementImageViews)
                imageView.backgroundColor = UIColor.green.withAlphaComponent(0.5) // Fondo semi-transparente
            case 3:
                selectedBackground = backgrounds[imageView.tag]
                resetImageViewBackgrounds(in: backgroundImageViews)
                imageView.backgroundColor = UIColor.cyan.withAlphaComponent(0.5) // Fondo semi-transparente
            default:
                break
        }
        
        // Refrescar la pantalla
        view.setNeedsDisplay()
        view.layoutIfNeeded()
        
        print("Selected Animal: \(selectedAnimal ?? "")")
        print("Selected Element: \(selectedElement ?? "")")
        print("Selected Background: \(selectedBackground ?? "")")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageWall" {
            let AIimage = segue.destination as! ImageViewController
            AIimage.animalSegue = selectedAnimal ?? ""
            AIimage.elementoSegue = selectedElement ?? ""
            AIimage.fondoSegue = selectedBackground ?? ""
        }
    }
    
    func resetImageViewBackgrounds(in imageViews: [UIImageView]) {
        for imageView in imageViews {
            imageView.backgroundColor = .clear // Restablece el fondo
        }
    }
    
    @IBAction func GenWallAction(_ sender: Any) {
        guard let animal = selectedAnimal, let element = selectedElement, let background = selectedBackground else {
            print("Please make a selection in each category.")
            return
        }
        
        let selectionString = "Animal: \(animal), Element: \(element), Background: \(background)"
        print(selectionString)
        // Use the selectionString to create a wallpaper or perform other actions
    }
        
}
