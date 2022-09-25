//
//  UIStoryboard+Instatiet.swift
//  WeatherForecast
//
//  Created by Mac on 24.09.2022.
//

import UIKit

func controllerFromStoryboard<VC: UIViewController>(_ viewController: VC.Type) -> VC {
    let id = String(describing: viewController)
    let storyboard = UIStoryboard(name: id, bundle: .main)
    
    guard let viewController = storyboard.instantiateInitialViewController() as? VC
    else {
        fatalError("Couldn't instantiate \(VC.description())")
    }
    
    return viewController
}
