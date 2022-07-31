//
//  APIService.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import Foundation

struct APIServiceError: Error {
    let title: String
    let message: String
}

extension APIServiceError {
    static let invalidUrl = APIServiceError(title: "Invalid Request", message: "Try again later.")
    static let unableToFetchData = APIServiceError(title: "Server Error", message: "some error occurred")
    static func didFail(with error: Error) -> APIServiceError {
        APIServiceError(title: "unknown error", message: error.localizedDescription)
    }
}

final class APIService<T: Decodable> {
    private let baseUrlString = "https://dataservice.accuweather.com"
    
    private let urlSession: URLSession = .shared
    private let jsonDecoder = JSONDecoder()
    
    private let endpointUrlString: String
    
    init(endpointUrlString: String) {
        self.endpointUrlString = endpointUrlString
    }
    
    func fetchResponse(appendingString text: String, withParameters params: [URLQueryItem], completionHandler: @escaping (_ result: Result<T, APIServiceError>) -> Void) {
        guard let url = URL(string: baseUrlString + endpointUrlString + text),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completionHandler(.failure(.invalidUrl))
            return
        }
        components.queryItems = params
        guard let url = components.url else {
            completionHandler(.failure(.invalidUrl))
            return
        }
        let request = URLRequest(url: url)
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            guard data != nil, error == nil, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completionHandler(.failure(.unableToFetchData))
                return
            }
            do {
                let decodedData = try self.jsonDecoder.decode(T.self, from: data!)
                completionHandler(.success(decodedData))
            } catch {
                completionHandler(.failure(.didFail(with: error)))
            }
        }
        dataTask.resume()
    }
}

extension APIService {
    static var currentConditions: APIService<[CurrentWeather]> {
        APIService<[CurrentWeather]>(endpointUrlString: "/currentconditions/v1")
    }
    static var hourlyForecast: APIService<[HourlyForecast]> {
        APIService<[HourlyForecast]>(endpointUrlString: "/forecasts/v1/hourly/12hour")
    }
}
