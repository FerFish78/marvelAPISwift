//
//  Tools.swift
//  WebTests
//
//  Created by Dev1 on 29/11/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import Foundation
import CommonCrypto
import UIKit

let publicKey = "eb76d970ec1cecbd44db46d1828311ae"
let privateKey = "50970149022f7c9ea32f9fcde4416cffb14b4a2b"

var baseURL = URL(string: "https://gateway.marvel.com/v1/public")!

func conexionMarvel() {
   let ts = "\(Date().timeIntervalSince1970)"
   let valorFirmar = ts+privateKey+publicKey
   let queryts = URLQueryItem(name: "ts", value: ts)
   let queryApikey = URLQueryItem(name: "apikey", value: publicKey)
   let queryHash = URLQueryItem(name: "hash", value: valorFirmar.MD5)
   
   
   
   var url = URLComponents()
   url.scheme = baseURL.scheme
   url.host = baseURL.host
   url.path = baseURL.path
   url.queryItems = [queryts, queryApikey, queryHash]
   
   let session = URLSession.shared
   var request = URLRequest(url: url.url!.appendingPathComponent("comics"))
   request.httpMethod = "GET"
   request.addValue("*/*", forHTTPHeaderField: "Accept")
   //En la documentacion se nos dice que la primera llamada nos da una etiqueta, pero que en las subsiguientes hay que escribirla. Si en la consulta nos ha mandado los 20 primeros, no los vuelve a enviar.
   if let etag = etag {
      request.addValue(etag, forHTTPHeaderField: "If-None-Match")
   }
   session.dataTask(with: request) { (data, response, error) in
      guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
         if let error = error {
            print("Error en la comunicación \(error)")
         }
         return
      }
      if response.statusCode == 200 {
         //print(String(data: data, encoding: .utf8)!) Ahora sólo habría que llamar a la función cargar, definida en Modelo.swift
         cargar(datos: data)
      } else {
         print(response.statusCode)
      }
   }.resume()
}

func getDateTime() -> String {
   let fecha = Date()
   let formatter = DateFormatter()
   formatter.dateFormat = "ddMMyyyyhhmmss"
   return formatter.string(from: fecha)
}

extension String {
   var MD5:String? {
      guard let messageData = self.data(using: .utf8) else {
         return nil
      }
      var datoMD5 = Data(count: Int(CC_MD5_DIGEST_LENGTH))
      _ = datoMD5.withUnsafeMutableBytes { bytes in
         messageData.withUnsafeBytes { messageBytes in
            CC_MD5(messageBytes, CC_LONG(messageData.count), bytes)
         }
      }
      var MD5String = String()
      for c in datoMD5 {
         MD5String += String(format: "%02x", c) //%02x -> Para que cada byte se convierta en un hexadecimal de dos cifras
      }
      return MD5String
   }
}
func recuperaURL(url:URL, callback:@escaping (UIImage) -> Void) {
   let conexion = URLSession.shared
   conexion.dataTask(with: url) { (data, response, error) in
      guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
         if let error = error {
            print("Error en la conexión de red \(error.localizedDescription)")
         }
         return
      }
      if response.statusCode == 200 {
         if let imagen = UIImage(data: data) {
            callback(imagen)
         }
      }
      }.resume()
}

