//
//  ServiceRequester.swift
//  kkhw
//
//  Created by wonwoo on 2019/08/10.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import Foundation
import RxSwift

enum NetError:LocalizedError{
    case none
    case netError
    case netDataDecodeError
    case unknwonError
}

class ServiceRequester {
    init(){}
//    func request<T>(baseUrl:URL, path:String) -> Observable<T> where T: Decodable {
//
//        return Observable<T>.create{ observer -> Disposable in
//
//            let url = URL(string:"\(baseUrl.absoluteString)\(path)")!
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                guard error == nil else{
//                    observer.onError(NetError.netError)
//                    return
//                }
//
//                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
//
//                    do {
//                        let model = try JSONDecoder().decode(T.self, from: data)
//                        observer.onNext(model)
//                    }
//                    catch {
//                        observer.onError(NetError.netDataDecodeError)
//                    }
//                }
//                }.resume()
//
//            return Disposables.create()
//        }
//    }
    
    func request<T>(baseUrl:URL, path:String) -> Single<T> where T: Decodable {
        return Single<T>.create { single in
            let url = URL(string:"\(baseUrl.absoluteString)\(path)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else{
                    single(.error(NetError.netError))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                    
                    do {
                        let model = try JSONDecoder().decode(T.self, from: data)
                        single(.success(model))
                    }
                    catch {
                        single(.error(NetError.netDataDecodeError))
                    }
                }
            }.resume()
            
            return Disposables.create()
        }
    }
}
