//
//  IntroViewController.swift
//  AstroZen
//
//  Created by Cypto Beast on 07/05/2024.
//


import UIKit
import AVKit
import AVFoundation

class IntroViewController: UIViewController {

    @IBOutlet weak var saltarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar el reproductor de video
        setupVideoPlayer()
    }
    
    func setupVideoPlayer() {
        guard let path = Bundle.main.path(forResource: "video", ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        // Presentar el AVPlayerViewController
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func saltarButtonAction(_ sender: Any) {
        
        // Marcar que el walkthrough ha sido completado
        UserDefaults.standard.set(true, forKey: "walkthroughCompleted")
        
        // Navegar al TabBarController
        if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController,
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate {
            delegate.window?.rootViewController = tabBarController
            delegate.window?.makeKeyAndVisible()
        }
    }
}

//import UIKit
//import AVKit
//import AVFoundation
//
//class IntroViewController: UIViewController {
//
//    @IBOutlet weak var saltarButton: UIButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Configurar el reproductor de video
//        setupVideoPlayer()
//    }
//
//    func setupVideoPlayer() {
//        guard let path = Bundle.main.path(forResource: "video", ofType:"mp4") else {
//            debugPrint("video.mp4 not found")
//            return
//        }
//
//        let player = AVPlayer(url: URL(fileURLWithPath: path))
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//
//        // Presentar el AVPlayerViewController
//        self.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
//    }
//
//    @IBAction func saltarButtonAction(_ sender: Any) {
//
//        if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController,
//           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let delegate = windowScene.delegate as? SceneDelegate {
//            delegate.window?.rootViewController = tabBarController
//            delegate.window?.makeKeyAndVisible()
//        }
//
//    }
//}
