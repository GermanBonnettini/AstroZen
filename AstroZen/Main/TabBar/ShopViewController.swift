//
//  ShopViewController.swift
//  AstroZen
//
//  Created by Cypto Beast on 10/06/2024.
//

import UIKit
import WebKit

class ShopViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var astroZenMercadoShop: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        astroZenMercadoShop.navigationDelegate = self
        
        if let url = URL(string: "https://astrozenn.blogspot.com/p/shop.html?m=1") {
            let request = URLRequest(url: url)
            astroZenMercadoShop.load(request)
        }
    }
    
    // MARK: - WKNavigationDelegate metodos
    
    func astroZenMercadoShop(_ astroZenMercadoShop: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Código para cuando la navegación empieza
        print("Comenzando a cargar la página web")
    }
    
    func astroZenMercadoShop(_ astroZenMercadoShop: WKWebView, didFinish navigation: WKNavigation!) {
        // Código para cuando la navegación finaliza
        print("Página web cargada")
    }
    
    func astroZenMercadoShop(_ astroZenMercadoShop: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Código para manejar errores de navegación
        print("Error al cargar la página web: \(error.localizedDescription)")
    }
}
