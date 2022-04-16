//
//  AppCoordinator.swift
//  MarvelCharacters
//
//  Created by Daniel Pérez Parreño on 13/4/22.
//
import UIKit

/// Define what type of flows can be started from this Coordinator
protocol AppCoordinatorProtocol: Coordinator {
    func showLoginFlow()
    func showMainFlow()
}

/// App coordinator is the only one coordinator which will exist during app's life cycle
class AppCoordinator: AppCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?

    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    var type: CoordinatorType { .app }

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: true)
    }

    func start() {
        showLoginFlow()
    }

    func showLoginFlow() {
        // Implement Login FLow
        let loginCoordinator = LoginCoordinator.init(navigationController)
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }

    func showMainFlow() {
        // Implement Main (Tab bar) FLow
        let tabCoordinator = TabCoordinator.init(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("AppCoordinator finish ", childCoordinator.type)

        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        navigationController.viewControllers.removeAll()

        switch childCoordinator.type {
        case .tab:
            showLoginFlow()
        case .login:
            showMainFlow()
        default:
            break
        }
    }
}
