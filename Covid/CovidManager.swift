//
//  CovidManager.swift
//  Covid
//
//  Created by Jose Angel Cortes Gomez on 16/12/20.
//

import Foundation

protocol CovidManagerDelegate {
    
    func updateData(data: CovidModel)
    
    func ifError(error: Error)
}

struct CovidManager {
    var delegate: CovidManagerDelegate?
        
    let dataURL = "https://corona.lmao.ninja/v3/covid-19/countries/"
    
    // Consultar con nombre del pais
    func fechtCovid(nameCountry: String) {
        let urlString = "\(dataURL)\(nameCountry)"
        
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString: String) {
        // 1.- Crear una url
        if let url = URL(string: urlString) {
            
            // 2.- Crear el objeto URLSession
            let session = URLSession(configuration: .default)
            
            // 3.- Asignar una tarea a la sesion
            let task = session.dataTask(with: url) { (data, request, error) in
                if error != nil {
                    delegate?.ifError(error: error!)
                    print(error!)
                    return
                }
                
                if let dataSure = data {
                    // Decodificar el objeto JSON de la API
                    if let data = self.parseJSON(covidData: dataSure) {
                        
                        // Quien sea el delegado cualquier class o structur que implemente el metodo updateWeather
                        delegate?.updateData(data: data)
                    }
                }
            }
            
            // 4.- Empezar la tarea
            task.resume()
        }
    }
    
    func parseJSON(covidData: Data) -> CovidModel? {
        
        let decoder = JSONDecoder()
        do {
            let dataDecoder = try decoder.decode(CovidData.self, from: covidData)
            let nameCountry = dataDecoder.country
            let cases = dataDecoder.cases
            let todayCases = dataDecoder.todayCases
            let deaths = dataDecoder.deaths
            let todayDeaths = dataDecoder.todayDeaths
            let recovered = dataDecoder.recovered
            let todayRecovered = dataDecoder.todayRecovered
            let flag = dataDecoder.countryInfo.flag
            
            // Crear un Objeto de tipo ClimaModelo
            let covidObj = CovidModel(nameCountry: nameCountry, cases: cases, todayCases: todayCases, deaths: deaths, todayDeaths: todayDeaths, recovered: recovered, todayRecovered: todayRecovered, flag: flag)

            return covidObj
        } catch {
            print(error)
            delegate?.ifError(error: error)
            return nil
        }
    }
}
