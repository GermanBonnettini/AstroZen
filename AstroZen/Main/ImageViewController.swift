//
//  ImageViewController.swift
//  AstroZen
//
//  Created by Cypto Beast on 13/04/2024.
//

import UIKit
import GoogleMobileAds


class ImageViewController: UIViewController {
    
    @IBOutlet weak var shareButtonNew: UIButton!
  
    @IBOutlet weak var AIimageWall: UIImageView!
    
    @IBOutlet weak var downloadButtonNew: UIButton!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var bannerView: GADBannerView!
    
    var viewmodel = ImageRequest()
    
    var frase: String = ""
    
    var animalSegue: String = ""
    var elementoSegue: String = ""
    var fondoSegue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inicializa el banner de anuncios
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = ""
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        // Configura el activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // Comienza la animación
        activityIndicator.startAnimating()

        frase = ("\(animalSegue) con \(elementoSegue) con fondo de \(fondoSegue)")
        
        Task {
            await viewmodel.generateImage(withText: frase)
            print("URL de Open AI: \(String(describing: viewmodel.imageURL))")
            do {
                guard let imageURL = viewmodel.imageURL else {
                    print("La URL de la imagen es nil")
                    activityIndicator.stopAnimating() // Detén la animación si hay error
                    return
                }
                
                let imageData = try Data(contentsOf: imageURL, options: [])
                guard let image = UIImage(data: imageData) else {
                    print("No se pudo crear la imagen desde los datos")
                    activityIndicator.stopAnimating() // Detén la animación si hay error
                    return
                }
                
                DispatchQueue.main.async {
                    // Asigna la imagen cargada a la UIImageView en el hilo principal
                    self.AIimageWall.image = image
                    self.activityIndicator.stopAnimating() // Detén la animación cuando la imagen se haya cargado
                }
            } catch {
                print("Error al obtener la imagen:", error.localizedDescription)
                activityIndicator.stopAnimating() // Detén la animación en caso de error
            }
        }
    }
    @IBAction func shareButtonAct(_ sender: Any) {
        guard let image = AIimageWall.image else {
            print("No hay imagen para compartir")
            return
        }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityController, animated: true)
    }
    
    @IBAction func downloadButtonAct(_ sender: Any) {
        guard let image = AIimageWall.image else {
            print("No hay imagen para compartir")
            return
        }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityController, animated: true)
    }
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Guardado", message: "La imagen ha sido guardada en tu galería", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
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

