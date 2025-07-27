//
//  HomeViewController.swift
//  AstroZen
//
//  Created by Cypto Beast on 02/04/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeImage: UIImageView!
    
    @IBOutlet weak var homeTextYear: UITextView!
    
    
    @IBOutlet weak var tituloTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tituloTextLabel.text = "Dragon de Madera"
        
        homeTextYear.text = "\nEl año nuevo chino del Dragón de Madera, que ocurrió en 2024, es un período especial en la cultura china que marca el comienzo de un nuevo ciclo lunar. El Dragón es uno de los doce animales del zodíaco chino y se considera un símbolo de poder, fortuna y vitalidad. La madera, por otro lado, es un elemento asociado con el crecimiento, la renovación y la creatividad.\n \nPara aquellos nacidos en el año del Dragón, se cree que el año del Dragón de Madera trae consigo un aire de optimismo y oportunidades.Se considera un momento propicio para tomar decisiones audaces, buscar nuevos proyectos y perseguir metas ambiciosas.La influencia de la madera puede agregar un elemento de flexibilidad y adaptabilidad a las acciones de aquellos afectados por este año en particular.\nEn la cultura china, el año nuevo es un momento de celebración y tradiciones arraigadas. Las familias se reúnen para disfrutar de comidas festivas, intercambiar regalos y participar en actividades ceremoniales destinadas a atraer buena suerte y alejar la mala fortuna. Los desfiles coloridos, los fuegos artificiales y las exhibiciones culturales son comunes en las celebraciones del año nuevo chino.\n \nEn resumen, el año del Dragón de Madera en el calendario chino es una oportunidad para dar la bienvenida a nuevas posibilidades, abrazar el cambio y celebrar la riqueza de la cultura china. Es un momento de esperanza, renovación y optimismo para aquellos que lo celebran."
        
        
        
    }
    

    
}


