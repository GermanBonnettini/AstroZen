//
//  DALLE3Client.swift
//  AstroZen
//
//  Created by Cypto Beast on 11/04/2024.
//

import Foundation


func makeChatRequest(_ userRequest: String, completion: @escaping (String?, String?, String?, Error?) -> Void) {
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("", forHTTPHeaderField: "Authorization")

    let requestBody: [String: Any] = [
        "model": "gpt-3.5-turbo-0125",
        "response_format": ["type": "json_object"],
        "messages": [
            ["role": "system", "content": "You are a helpful assistant designed to deliver JSON."],
            ["role": "user", "content": userRequest]
        ]
    ]

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, nil, nil, error)
                return
            }
            
            print ("Pudo conectar tiene que decir nil: \(String(describing: error))")

            do {
                    // Convertir el Data en un diccionario JSON
                    guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        completion(nil, nil, nil, NSError(domain: "InvalidResponse", code: 0, userInfo: nil))
                        return
                    }
                    
                    print("Pudo convertir la data del JSON en Diccionario")
                    
                    // Extraer los datos necesarios del JSON
                    if let choices = jsonResponse["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let content = message["content"] as? String,
                       let contentData = content.data(using: .utf8),
                       let contentJSON = try JSONSerialization.jsonObject(with: contentData, options: []) as? [String: Any] {
                        
                        // Extraer "animal"
                        guard let animal = contentJSON["animal"] as? String else {
                            print("Error: no se encontró la clave 'animal'")
                            completion(nil, nil, nil, NSError(domain: "MissingAnimal", code: 0, userInfo: nil))
                            return
                        }
                        
                        // Extraer "elemento" o "element"
                        guard let element = contentJSON["elemento"] as? String ?? contentJSON["element"] as? String else {
                            print("Error: no se encontró la clave 'elemento' ni 'element'")
                            completion(nil, nil, nil, NSError(domain: "MissingElement", code: 0, userInfo: nil))
                            return
                        }
                        
                        // Extraer "descripcion" o "description"
                        if let descriptionDict = contentJSON["descripcion"] as? [String: Any] ?? contentJSON["description"] as? [String: Any] {
                            // Extraer "español" o "spanish" de la descripción
                            guard let spanishDescription = descriptionDict["español"] as? String ?? descriptionDict["spanish"] as? String else {
                                print("Error: no se encontró la clave 'español' en 'descripcion'")
                                completion(nil, nil, nil, NSError(domain: "MissingSpanishDescription", code: 0, userInfo: nil))
                                return
                            }
                            
                            print("Datos extraídos del JSON: animal: \(animal), elemento: \(element), descripción: \(spanishDescription)")
                            
                            completion(animal, element, spanishDescription, nil)
                        } else {
                            print("Error: no se encontró la clave 'descripcion' ni 'description'")
                            completion(nil, nil, nil, NSError(domain: "MissingDescription", code: 0, userInfo: nil))
                        }
                        
                    } else {
                        print("Error: estructura JSON inesperada")
                        completion(nil, nil, nil, NSError(domain: "InvalidJSONStructure", code: 0, userInfo: nil))
                    }
                    
                } catch {
                    print("No pudo convertir la data del JSON en Diccionario: \(error.localizedDescription)")
                    completion(nil, nil, nil, error)
                }
        }

        task.resume()
    } catch {
        print ("Problemas con el body")
        completion(nil, nil, nil, error)
    }
}

