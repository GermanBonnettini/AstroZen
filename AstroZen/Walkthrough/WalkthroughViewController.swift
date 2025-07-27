//
//  WalkthroughViewController.swift
//  AstroZen
//
//  Created by Cypto Beast on 03/04/2024.
//


import UIKit

class WalkthroughViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController!
    var pages: [UIViewController] = []
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the pages of the walkthrough
        let welcomePage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController")
        let featuresPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeaturesViewController")
        let introPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IntroViewController")
        
        pages = [welcomePage, featuresPage, introPage]
        
        // Create the page view controller
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // Set the first page
        pageViewController.setViewControllers([welcomePage], direction: .forward, animated: true, completion: nil)
        
        // Add the page view controller as a child view controller
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        // Add page control
        configurePageControl()
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        return pages[index + 1]
    }
    
    // MARK: - Page Control
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    @objc func skipWalkthrough() {
        // Llama a la función para marcar el walkthrough como completado en UserDefaults
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.walkthroughCompleted()

        // Navegar al TabBarController
        if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController,
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate {
            delegate.window?.rootViewController = tabBarController
            delegate.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
            let index = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = index
        }
    }
    
    // Llamada cuando el walkthrough finaliza
    func finishWalkthrough() {
        skipWalkthrough() // Cambia al TabBarController y marca el walkthrough como completado
    }
}

//import UIKit
//
//class WalkthroughViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//    
//    var pageViewController: UIPageViewController!
//    var pages: [UIViewController] = []
//    var pageControl = UIPageControl()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Configure the pages of the walkthrough
//        let welcomePage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController")
//        let featuresPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeaturesViewController")
//        let introPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IntroViewController")
//        
//       
//        
//        pages = [welcomePage, featuresPage, introPage]
//        
//        // Create the page view controller
//        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        pageViewController.dataSource = self
//        pageViewController.delegate = self
//        
//        // Set the first page
//        pageViewController.setViewControllers([welcomePage], direction: .forward, animated: true, completion: nil)
//        
//        // Add the page view controller as a child view controller
//        addChild(pageViewController)
//        view.addSubview(pageViewController.view)
//        pageViewController.didMove(toParent: self)
//        
//        // Add page control
//        configurePageControl()
//        
//        
//    }
//    
//    // MARK: - UIPageViewControllerDataSource
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let index = pages.firstIndex(of: viewController), index > 0 else {
//            return nil
//        }
//        return pages[index - 1]
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
//            return nil
//        }
//        return pages[index + 1]
//    }
//    
//    // MARK: - Page Control
//    
//    func configurePageControl() {
//        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
//        pageControl.numberOfPages = pages.count
//        pageControl.currentPage = 0
//        pageControl.tintColor = UIColor.black
//        pageControl.pageIndicatorTintColor = UIColor.lightGray
//        pageControl.currentPageIndicatorTintColor = UIColor.black
//        self.view.addSubview(pageControl)
//    }
//    
//   
//    
//   
//    
//    @objc func skipWalkthrough() {
//        // Navigate to the main screen (Assuming TabBarController is the rootViewController)
//        if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController,
//           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let delegate = windowScene.delegate as? SceneDelegate {
//            delegate.window?.rootViewController = tabBarController
//            delegate.window?.makeKeyAndVisible()
//        }
//    }
//    
//    // MARK: - UIPageViewControllerDelegate
//    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if let currentViewController = pageViewController.viewControllers?.first,
//            let index = pages.firstIndex(of: currentViewController) {
//            pageControl.currentPage = index
//        }
//    }
//}
