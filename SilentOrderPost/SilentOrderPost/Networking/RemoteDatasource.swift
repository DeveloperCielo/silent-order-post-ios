//
//  RemoteDatasource.swift
//  SilentOrderPost
//
//  Created by Jeferson Nazario on 12/12/19.
//  Copyright © 2019 jnazario.com. All rights reserved.
//

import Foundation

class RemoteDatasource {
    static func shared() -> RemoteDatasource {
        return RemoteDatasource()
    }
    
    func silentOrder(environment: Environment = .sandbox,
                     accessToken: String,
                     cardHolderName: String,
                     cardNumber: String,
                     cardExpiration: String,
                     cardSecurityCode: String,
                     enableBinQuery: Bool,
                     onValidation: @escaping ([ValidationResults]) -> Void?,
                     onSuccess: @escaping (SuccessResult) -> Void?,
                     onError: @escaping (ErrorResult) -> Void?) {
        
        
        var url = "https://transactionsandbox.pagador.com.br/post/api/public/v1/card"
        if environment == .production {
            url = "https://transaction.cieloecommerce.cielo.com.br/post/api/public/v1/card"
        }
        
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config)
        
        guard let urlRequest: URL = URL(string: url) else { return }
        var request: URLRequest = URLRequest(url: urlRequest)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params: [String: Any] = ["AccessToken": accessToken,
                                     "HolderName": cardHolderName,
                                     "RawNumber": cardNumber,
                                     "Expiration": cardExpiration,
                                     "SecurityCode": cardSecurityCode,
                                     "EnableBinQuery": enableBinQuery]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        
        request.httpBody = postData as Data
        
        //request.setValue("\(authenticationType) \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request, completionHandler: { (result, _, error) in
            guard error == nil else {
                let errorResult = ErrorResult(errorCode: "400", errorMessage: error!.localizedDescription)
                onError(errorResult)
                return
            }
            guard let data = result else {
                let errorResult = ErrorResult(errorCode: "400", errorMessage: "")
                onError(errorResult)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromUpperCamelCase

                let decodableData = try decoder.decode(SuccessResult.self, from: data)
                
                DispatchQueue.main.async {
                    onSuccess(decodableData)
                }
            } catch let exception {
                let resultString = String(data: data, encoding: .utf8) ?? exception.localizedDescription
                let errorResult = ErrorResult(errorCode: "400", errorMessage: resultString)
                onError(errorResult)
            }
        })
        
        task.resume()
    }
}
