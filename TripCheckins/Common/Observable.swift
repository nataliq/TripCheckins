//
//  Observable.swift
//  TripCheckins
//
//  Created by Nataliya  on 9/12/17.
//  Copyright © 2017 Nataliya Patsovska. All rights reserved.
//

import Foundation

typealias ObserverObject = AnyObject & Observer

protocol Observable {
    
    mutating func addObserver(_ observer: ObserverObject)
    mutating func removeObserver(_ observer: ObserverObject)
    func notifyObservers()
}

protocol Observer: class {
    func didUpdateObservableObject(_ observable: Observable)
}

protocol ObserversContainer {
    var observers: [WeakObserverReference] { set get }
}

class WeakObserverReference {
    private(set) weak var observer: ObserverObject?
    init(observer: ObserverObject?) {
        self.observer = observer
    }
}

extension Observable where Self: ObserversContainer {
    mutating func addObserver(_ observer: ObserverObject) {
        observers.append(WeakObserverReference(observer: observer))
    }
    
    mutating func removeObserver(_ observer: AnyObject & Observer) {
        if let observerIndex = observers.index(where: { $0 === observer }) {
            observers.remove(at: observerIndex)
        }
    }
    
    func notifyObservers() {
        self.observers.forEach { $0.observer?.didUpdateObservableObject(self) }
    }
}

