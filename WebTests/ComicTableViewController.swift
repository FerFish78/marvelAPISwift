//
//  ComicTableViewController.swift
//  WebTests
//
//  Created by Fer Fish on 29/11/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import UIKit

class ComicTableViewController: UITableViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      conexionMarvel()
      NotificationCenter.default.addObserver(forName: NSNotification.Name("OKCARGA"), object: nil, queue: OperationQueue.main) {
         _ in
         self.tableView.reloadData()
         guard let blur = self.navigationController?.view.viewWithTag(200) as?
         UIVisualEffectView, let activity = self.navigationController?.view.viewWithTag(201) as?
            UIActivityIndicatorView else {
               return
         }
         
         //Hacemos una animación de 1 segundo de duracion, que cuando acabe le dé el valor 0.0 al alpha de blur, y el sistema crea una animación de 1 segundo hasta llegar al valor deseado, haciendo una especie de fundido
         UIView.animate(withDuration: 1.0, animations:
            { blur.alpha = 0.0
               activity.alpha = 0.0 }){
            finished in
            if finished {
               blur.removeFromSuperview()
               activity.stopAnimating()
               activity.removeFromSuperview()
            }
         }
      }
      //Tenemos que estar un buen rato con la tabla vacía, así que ponemos la pantalla en negro durante la espera:
      let blurEffect = UIBlurEffect(style: .dark)
      let blurredEffectView = UIVisualEffectView(effect: blurEffect)
      blurredEffectView.frame = navigationController?.view.frame ?? CGRect.zero
      blurredEffectView.tag = 200
      navigationController?.view.addSubview(blurredEffectView)
      let activity = UIActivityIndicatorView(style: .whiteLarge)
      activity.frame = navigationController?.view.frame ?? CGRect.zero
      activity.tag = 201
      activity.startAnimating()
      navigationController?.view.addSubview(activity)
   }
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return datosCarga?.data.count ?? 0
   }
   
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! ComicViewCell
    
    // Configure the cell...
      if let datosComic = datosCarga?.data.results[indexPath.row] {
         cell.cabecera.text = datosComic.title
         var descripcionText: String = ""
         if let descripcion = datosComic.description {
            descripcionText += descripcion
         } else {
            descripcionText += "Descripción no disponible"
         }
         if let precio = datosComic.prices.first?.price {
            descripcionText += "\n"
            descripcionText += "Precio: \(precio)"
         }
         cell.detalle.text = descripcionText
         if let imagenURL = datosComic.thumbnail.fullPath {
            recuperaURL(url: imagenURL) {
               imagen in
               if let resize = imagen.resizeImage(newWidth: cell.imagen.bounds.size.width) {
               DispatchQueue.main.async {
                  cell.imagen.image = imagen
                  }
               }
            }
         }
      }
    
    return cell
    }
 
   
   deinit {
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name("OKCARGA"), object: nil)
   }
   
   /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
   
   /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
    // Delete the row from the data source
    tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
   
   /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    
    }
    */
   
   /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    }
    */
   
}

