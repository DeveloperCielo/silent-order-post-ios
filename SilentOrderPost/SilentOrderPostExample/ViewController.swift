//
//  ViewController.swift
//  SilentOrderPostExample
//
//  Created by Jeferson Nazario on 16/12/19.
//  Copyright © 2019 jnazario.com. All rights reserved.
//

import UIKit
import SilentOrderPost

class ViewController: UIViewController {
    
    private var sdk: SilentOrderPostProtocol!
    
    lazy var btnMakePost: UIButton = {
       var btn = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        
        btn.setTitle("Make Post", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(startSilentOrder), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sdk = SilentOrderPost.createInstance(environment: .sandbox)
        
        view.addSubview(btnMakePost)
        btnMakePost.translatesAutoresizingMaskIntoConstraints = false
        btnMakePost.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnMakePost.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func startSilentOrder() {
        getAccessToken(merchantId: "538c04ae-f377-4da8-803b-67c812616387", onSuccess: { [weak self] (accessToken) in
            self?.makePost(accessToken: accessToken)
        }) { (error) in
            print(error)
        }
    }
    
    private func makePost(accessToken: String) {
        sdk.sendCardData(accessToken: accessToken,
                         cardHolderName: "Joselito Barbacena",
                         cardNumber: "4000000000001091",
                         cardExpirationDate: "10/2029",
                         cardCvv: "621",
                         enableBinQuery: true,
                         onValidation: { (results) -> Void? in
                            
                            results.forEach { (result) in
                                print(result.field + ": " + result.message)
                            }
        },
                         onSuccess: { (result) in
                            
                            let alert = UIAlertController(title: "Sucesso",
                                                          message: "PaymentToken: \(result.paymentToken ?? "null")",
                                                          preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default))
                            self.present(alert, animated: true)
                            
        }) { (error) -> Void? in
            print(error.errorMessage)
        }
    }
    
    private func getAccessToken(merchantId: String, onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void) {
        let url = "https://transactionsandbox.pagador.com.br/post/api/public/v1/accesstoken?merchantid=\(merchantId)"
        
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config)
        
        guard let urlRequest: URL = URL(string: url) else { return }
        var request: URLRequest = URLRequest(url: urlRequest)
        request.httpMethod = "POST"
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.allHTTPHeaderFields = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let task = session.dataTask(with: request, completionHandler: { (result, response, error) in
            print(response ?? "Nada")
            guard error == nil else {
                onError(error!.localizedDescription)
                return
            }
            guard let data = result else {
                onError(error!.localizedDescription)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromUpperCamelCase
                let decodableData = try decoder.decode(AccessTokenResponse.self, from: data)
                
                DispatchQueue.main.async {
                    onSuccess(decodableData.accessToken)
                }
            } catch let exception {
                onError(exception.localizedDescription)
            }
        })
        
        task.resume()
    }
    
}

