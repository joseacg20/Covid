//
//  ViewController.swift
//  Covid
//
//  Created by Jose Angel Cortes Gomez on 16/12/20.
//

import UIKit

class ViewController: UIViewController {
    
    var covidManager = CovidManager()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var totalCasesLabel: UILabel!
    @IBOutlet weak var casesConfirmedTodayLabel: UILabel!
    @IBOutlet weak var totalDeathsLabel: UILabel!
    @IBOutlet weak var deathsConfirmedTodayLabel: UILabel!
    @IBOutlet weak var totalRecoveredLabel: UILabel!
    @IBOutlet weak var recoveredConfirmedTodayLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Ocultar el teclado al precionar cualquier parte de la pantalla
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
                
        view.addGestureRecognizer(tap)
        
        // Cargamos el delegado del CovidManager
        covidManager.delegate = self
    }
    
    // Ocultar el teclado una vez que se termino de editar el textfield
    @objc func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
    // Buscamos en base al nombre de la ciudad
    @IBAction func ButtonSearch(_ sender: UIButton) {
        // Eliminacion del espacio que se añadel al usar el autocompletado del teclado
        let string = searchTextField.text!
        let trimmed = string.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        
        // Ocultar el teclado
        dismissKeyboard()
        
        covidManager.fechtCovid(nameCountry: trimmed)
    }
}

// MARK: - Metodos para actualizar interfaz de usuario
extension ViewController: CovidManagerDelegate {
    
    // Comprobamos si existe algun error al tratar de consultar la API
    func ifError(error: Error){
        DispatchQueue.main.async {
            if error.localizedDescription == "The operation couldn’t be completed." {
                let alert = UIAlertController(title: "Error", message: "Lo sentimos intente mas tarde se acabo el timepo para obtener los datos estadisticos", preferredStyle: .alert)
                
                let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                                
                // Agregar acciones al alert
                alert.addAction(actionAcept)
                
                // Mostramos el alert
                self.present(alert, animated: true, completion: nil)
            }
            
            if error.localizedDescription == "The data couldn’t be read because it is missing." {
                let alert = UIAlertController(title: "Error", message: "Lo sentimos no encontramos el pais que esta buscando, por favor verifica el nombre o intente mas tarde", preferredStyle: .alert)
                
                let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                                
                // Agregar acciones al alert
                alert.addAction(actionAcept)
                
                // Mostramos el alert
                self.present(alert, animated: true, completion: nil)
            }
            
            if error.localizedDescription == "A data connection is not currently allowed." {
                let alert = UIAlertController(title: "Error", message: "Perdimos la coneccion de internet intente mas tarde", preferredStyle: .alert)
                
                let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                                
                // Agregar acciones al alert
                alert.addAction(actionAcept)
                
                // Mostramos el alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Actualizamos los elementos graficos una vez que obtuvimos la respuesta de la API
    func updateData(data: CovidModel) {
        DispatchQueue.main.async {
            self.messageLabel.text = "Las estadisticas actuales al dia de hoy en \(String(data.nameCountry)) son de:"
            self.totalCasesLabel.text = String(data.cases)
            self.casesConfirmedTodayLabel.text = String(data.todayCases)
            self.totalDeathsLabel.text = String(data.deaths)
            self.deathsConfirmedTodayLabel.text = String(data.todayDeaths)
            self.totalRecoveredLabel.text = String(data.recovered)
            self.recoveredConfirmedTodayLabel.text = String(data.todayRecovered)
            let flag = String(data.flag)
            let url = NSURL(string: flag)
            let dataImge = NSData(contentsOf : url! as URL)
            self.flagImageView.image = UIImage(data : dataImge! as Data)
        }
    }
}

// MARK: - Delegados para implementar Textfield
extension ViewController: UITextFieldDelegate {
    
    // Programar el boton del teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        
        return true
    }
     
    // Ocultar el teclado una vez que se termino de editar el textfield
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
     }
}
