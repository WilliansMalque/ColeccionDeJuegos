//
//  ViewController.swift
//  Malque1ColeccionDeJuegos
//
//  Created by Willians Malque on 30/09/24.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = juego.titulo
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        return cell
    }
    

    
    @IBOutlet weak var tableView: UITableView!
    var juegos : [Juego] = []
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try juegos =    context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        }catch{
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // Eliminar el juego del array
            let juegoAEliminar = juegos[indexPath.row]
            context.delete(juegoAEliminar)
            
            // Guardar cambios en Core Data
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            // Eliminar el juego del array y actualizar la tabla
            juegos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
           return true // Permitir mover filas
       }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = juegos[sourceIndexPath.row] // Objeto a mover
        juegos.remove(at: sourceIndexPath.row) // Eliminar del origen
        juegos.insert(movedObject, at: destinationIndexPath.row) // Insertar en el destino
           
           // Aquí puedes agregar lógica para guardar el nuevo orden en Core Data si es necesario
        
    }
    
    var isEditingMode: Bool = false
    
    @IBAction func toggleEditingMode(_ sender: Any) {
        
        guard let button = sender as? UIButton else { return } // Hacemos un cast del sender a UIButton
            isEditingMode.toggle() // Cambia el estado del modo de edición
            tableView.isEditing = isEditingMode // Activa o desactiva el modo de edición
            
            // Cambiar el título del botón según el estado
            button.setTitle(isEditingMode ? "Listo" : "Editar", for: .normal)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true
        
        // Do any additional setup after loading the view.
    }


}

