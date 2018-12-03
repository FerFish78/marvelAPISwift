//
//  Modelo.swift
//  WebTests
//
//  Created by Fer Fish on 30/11/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import UIKit
import Foundation
import CoreData

struct RootJSON:Codable { //Creamos una estructura con los datos que nos ha deuvleto el json, eligiendo los que nos interesan para nuestra aplicación
   let etag:String
   struct Data:Codable {
      //De todos los campos que tiene data, sólo nos interesa count y results.
      let count: Int
      struct Results: Codable { //Tenemos que mirar los datos que hay anidados en results y decidir lo que nos interesa
         let id: Int
         let title: String
         let issueNumber: Int
         let variantDescription:String
         let description: String? //Lo ponemos opcional porque en la base de datos generada hay algunos description que vienen vacíos, con valor null
         struct Prices: Codable {
            let type: String
            let price: Double
         }
         let prices:[Prices]

         struct Thumbnail: Codable {
            let path: URL
            let imageExtension: String
            //La palabra extension es una palabra reservada y no podemos llamar así a la constante que queremos. Podemos escribir 'extension', pero entonces habría que hacerlo siempre así. Lo que hacemos es cambiar el diccionario donde internamente se lleva el control de los diferentes valores, lo que es la equivalencia entre el nombre de las claves y los campos donde se va a decodificar. Para ello utilizamos una enumeración llamada codingkey.
            enum CodingKeys: String, CodingKey {
               case path
               case imagenExtension = "extension" //En el caso de que el valor del json se llame extension, en realidad se va a llamar imageExtension, así podemos meter valores del json en nuestra estructura, para evitar el problema que hemos tenido con el uso de una palabra reservada del sistema.
            }
            
            var fullPath: URL? {
               var pathComponents = URLComponents(url: path, resolvingAgainstBaseURL: false)
               pathComponents?.scheme = "https"
               return pathComponents?.url?.appendingPathExtension(imageExtension)
            }
            
         }
         
         let thumbnail: Thumbnail
         struct Creators: Codable {
            let items:[Items]
            struct Items: Codable {
               let name: String
               let role: String
            }
         }
         let creators: Creators
      }
      let results: [Results]
   }
   let data: Data
}

//Habría que crear una base de datos en core Data para guardarlo, pero de momento lo vamos a hacer en memoria.
var datosCarga:RootJSON?
var etag: String?

func cargar(datos:Data) { //Función que reciba los datos directamente de la web
   let decoder = JSONDecoder()
   do{
      datosCarga = try decoder.decode(RootJSON.self, from: datos)
      UserDefaults.standard.set(datosCarga?.etag, forKey: "etag") //Si ese valor existiera, lo sobrescribe
      etag = datosCarga?.etag //Cuando cerramos la aplicación la etiqueta se pierde porque está en memoria, y hay que utilizar la etiqueta en la próxima llamada. De esta forma la guardamos para próximos usos
      //Creamos un obervador para que nos notifique algo, es una llamada genérica de toda la aplicación. Nos notifica cuando termina de pasarnos datos
      NotificationCenter.default.post(name: NSNotification.Name("OKCARGA"), object: nil)
   }catch {
      print ("Fallo en la serialización \(error)")
   }
}
