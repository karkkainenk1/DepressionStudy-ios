//
//  PageViewController.swift
//  Health
//
//  Created by Admin on 7/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//  This file is for the Terms & Conditions section of the application

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageControl = UIPageControl()
    // add pages to viewcontroller here (needs storyboard id)
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "term0"),
                self.newVc(viewController: "term1"),
                self.newVc(viewController: "term2"),
                self.newVc(viewController: "term3"),
                self.newVc(viewController: "term4"),
                self.newVc(viewController: "term5")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        // First page options "if" to use variable parameter: "[firstViewController]"
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
      
        configurePageControl()
        
        // Do any additional setup after loading the view.
    }
    
    // Sets up the pageviewcontroller navigation dots
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: UIScreen.main.bounds.maxX / 2 - 50,y: UIScreen.main.bounds.maxY - 50,width: 100,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    // instantiating a new ViewController page
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    // Function for the current page in the view (animations completed)
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of: pageContentViewController)!
    }
    
    // Function for the previous page in the view
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        // behavior at end of the view page array [loop/no loop]
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            //return orderedViewControllers.last
            // Commment the line below, then uncomment the line above for pages to loop.
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    // Function for the next page in the view
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // behavior at end of the view page array [loop/no loop]
        guard orderedViewControllersCount != nextIndex else {
            //return orderedViewControllers.first
            // Commment the line below, then uncomment the line above for pages to loop.
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
}
