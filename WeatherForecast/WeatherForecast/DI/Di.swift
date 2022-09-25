//
//  Di.swift
//  WeatherForecast
//
//  Created by Mac on 25.09.2022.
//

import Foundation
import Swinject

extension Container {
    static let sharedContainer: Container = {
        let container = Container()
        container.register(ApiService.self) { _ in ApiServiceImplementation()}
        container.register(LocationManager.self) { _ in LocationManagerImplementation()}
        container.register(MainViewModel.self) { resolver in
            let viewModel = MainViewModelImplementation()
            viewModel.apiService = resolver.resolve(ApiService.self)
            viewModel.locationManager = resolver.resolve(LocationManager.self)
            return viewModel
        }
        container.register(SearchLocationViewModel.self) { resolver in
            let viewModel = SearchLocationViewModelImplementation()
            return viewModel
        }
        container.register(MainViewController.self) { resolver in
            let controller = controllerFromStoryboard(MainViewController.self)
            controller.viewModel = resolver.resolve(MainViewModel.self)
            return controller
        }
        container.register(SearchLocationViewController.self) { resolver in
            let controller = controllerFromStoryboard(SearchLocationViewController.self)
            controller.viewModel = resolver.resolve(SearchLocationViewModel.self)
            return controller
        }
        return container
    }()
}
