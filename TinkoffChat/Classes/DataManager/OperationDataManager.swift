//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 20/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class OperationDataManager: DataManager {
    
    private let backgroundQueue: OperationQueue
    
    init() {
        backgroundQueue = OperationQueue()
        backgroundQueue.underlyingQueue = DispatchQueue.global()
    }
    
    func save<T: Codable>(_ object: T, to fileName: String, completionHandler: @escaping (Error?) -> Void) {
        let url = createURL(withFileName: fileName)
        let saveOperation = SaveOperation<T>(object: object, url: url)
        saveOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completionHandler(saveOperation.error)
            }
        }
        backgroundQueue.addOperation(saveOperation)
    }
    
    func load<T: Codable>(_ type: T.Type, from fileName: String, completionHandler: @escaping (T?, Error?) -> Void) {
        let url = createURL(withFileName: fileName)
        let loadOperation = LoadOperation<T>(url: url)
        loadOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completionHandler(loadOperation.result, loadOperation.error)
            }
        }
        backgroundQueue.addOperation(loadOperation)
    }
}

class SaveOperation<T: Codable>: AsyncOperation {
    var error: Error?
    
    private let object: T
    private let url: URL
    
    init(object: T, url: URL) {
        self.object = object
        self.url = url
    }
    
    override func main() {
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: url, options: .atomic)
            error = nil
        } catch {
            self.error = error
        }
        self.state = .finished
    }
}

class LoadOperation<T: Codable>: AsyncOperation {
    var result: T?
    var error: Error?
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    override func main() {
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            result = decodedData
        } catch {
            self.error = error
        }
        self.state = .finished
    }
}

class AsyncOperation: Operation {
    
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
    override func cancel() {
        state = .finished
    }
}
