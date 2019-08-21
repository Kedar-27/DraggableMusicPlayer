//
//  DynamicValue.swift
//  DragabbleViewController
//
//  Created by Kedar Sukerkar on 21/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//


import Foundation


class DynamicValue<T> {
    
    
    // MARK: - Properties
    typealias CompletionHandler = ((T) -> Void)
    
    var value : T {
        didSet {
            self.notify()
        }
    }
    
    private var observers = [String: CompletionHandler]()
    
    
    // MARK: - Initializer
    init(_ value: T) {
        self.value = value
    }
    
    deinit {
        observers.removeAll()
    }
    
    
    // MARK: - Observers
    
    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    
    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    private func notify() {
        observers.forEach({ $0.value(value) })
    }
    
    
}
