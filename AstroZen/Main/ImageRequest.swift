//
//  ViewModel.swift
//  AstroZen
//
//  Created by Cypto Beast on 13/04/2024.
//

import Foundation

final class ImageRequest: ObservableObject {
    
    private let urlSession: URLSession
    
    var imageURL: URL?
    
    init(urlSession: URLSession = .shared) {
            self.urlSession = urlSession
        }
    
    func generateImage(withText text: String) async {
            guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
                return
            }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

//        API nueva y valida Mate Code Studio
        urlRequest.addValue("", forHTTPHeaderField: "Authorization")

        let dictionary : [String: Any] = [
           
            "model": "dall-e-3",
            "prompt": text,
            "n": 1,
            "size": "1024x1792"
            
        ]
        
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            let model = try JSONDecoder().decode(modelResponse.self, from: data)
            
            DispatchQueue.main.async {
                guard let firstModel = model.data.first else {
                    return
                }
                self.imageURL = URL(string: firstModel.url)
                
            }
        } catch {
            print(error.localizedDescription)
            }
        
        print ("URL de Open AI: \(String(describing: self.imageURL))")
        }
    }
