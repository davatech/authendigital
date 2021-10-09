//
//  API.swift
//  AD Test
//
//  Created by Dava Tech Group, Inc.
//

import Foundation
import Combine

extension URL {
    static let apiBaseURL: String = "https://authen.cloud/dispatch/extension/"
}

// SECUTIRY WARNING
// This is for testing purpose only!
// You should never call Authen Digital APIs from your app but in your server.
class API {

    var cancellationToken: AnyCancellable?

    // SECUTIRY WARNING
    // This is for testing purpose only!
    // You should never store keys in your app.
    // This should be done on your server instead.

    // Put your developer key here
    private let developerKey = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    // Put your licence key here
    private let licenceKey = "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"

    private struct Call {

        struct Response<T> {
            let value: T
            let response: URLResponse
        }

        func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .tryMap { result -> Response<T> in
                    
                    let value = try JSONDecoder().decode(T.self, from: result.data)
                    print("API RESPONSE: \(value)")
                    return Response(value: value, response: result.response)
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }

    }

    private func requestOpen(isActivation: Bool, username: String) -> AnyPublisher<OpenResponse, Error> {

        guard let url = URL(string: URL.apiBaseURL)?.appendingPathComponent("open") else {
            fatalError("Couldn't create URL for Open command")
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create URLComponents")
        }

        // Add request parameters
        components.queryItems = [URLQueryItem(name: "User", value: username)]
        components.queryItems?.append(contentsOf: [URLQueryItem(name: "Developer-Key", value: developerKey)])
        components.queryItems?.append(contentsOf: [URLQueryItem(name: "License-Key", value: licenceKey)])
        if isActivation {
            components.queryItems?.append(contentsOf: [URLQueryItem(name: "op", value: "activate")])
        }

        var request = URLRequest(url: components.url!)
        request.httpMethod = "Get"

        return Call().run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    private func requestVerify(session: String?) -> AnyPublisher<VerifyResponse, Error> {

        guard let url = URL(string: URL.apiBaseURL)?.appendingPathComponent("verify") else {
            fatalError("Couldn't create URL for Verify command")
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create URLComponents")
        }

        // Add request parameters
        components.queryItems = [URLQueryItem(name: "Session", value: session)]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "Get"

        return Call().run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    private func requestList(session: String?) -> AnyPublisher<ListResponse, Error> {

        guard let url = URL(string: URL.apiBaseURL)?.appendingPathComponent("device") else {
            fatalError("Couldn't create URL for List command")
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create URLComponents")
        }

        components.queryItems = [URLQueryItem(name: "Session", value: session)]
        components.queryItems?.append(contentsOf: [URLQueryItem(name: "Op", value: "list")])
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "Get"
        
        return Call().run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    private func requestNewDevice(session: String?) -> AnyPublisher<NewDeviceResponse, Error> {

        guard let url = URL(string: URL.apiBaseURL)?.appendingPathComponent("newdevice") else {
            fatalError("Couldn't create URL for New Device command")
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create URLComponents")
        }

        components.queryItems = [URLQueryItem(name: "Session", value: session)]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "Get"
        
        return Call().run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

}

extension API {

    func open(isActivation: Bool = false, username: String, _ completion: @escaping (OpenResponse) -> Void) {
        cancellationToken = requestOpen(isActivation: isActivation, username: username)
            .mapError({ (error) -> Error in
                print("OPEN: \(error)")
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    completion($0)
                  })
    }

    func verify(_ session: String?, _ completion: @escaping (VerifyResponse) -> Void) {
        cancellationToken = requestVerify(session: session)
            .mapError({ (error) -> Error in
                print("VERIFY: \(error)")
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    completion($0)
                  })
    }
    
    func list(session:String?, _ completion: @escaping (ListResponse) -> Void) {
        cancellationToken = requestList(session: session)
            .mapError({ (error) -> Error in
                print("LIST: \(error)")
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    completion($0)
                  })
    }
    
    func newDevice(session:String?, _ completion: @escaping (NewDeviceResponse) -> Void) {
        cancellationToken = requestNewDevice(session: session)
            .mapError({ (error) -> Error in
                print("NEW DEVICE: \(error)")
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    completion($0)
                  })
    }

}
