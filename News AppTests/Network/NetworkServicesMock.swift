//
//  NetworkServicesMock.swift
//  News AppTests
//
//  Created by Asalah Sayed on 01/08/2023.
//

import Foundation
@testable import News_App

final class NetworkServicesMock {
    static let result = "{\"status\":\"ok\",\"totalResults\":37,\"articles\":[{\"source\":{\"id\":null,\"name\":\"TheGuardian\"},\"author\":\"Guardianstaffreporter\",\"title\":\"Georgiaresidentdiesfromrare‘brain-eatingamoeba’-TheGuardianUS\",\"description\":\"VictiminfectedwithNaegleriafowleri,whichdestroysbraintissue,probablyafterswimminginlakeorpond\",\"url\":\"https://www.theguardian.com/us-news/2023/jul/31/brain-eating-amoeba-georgia-naegleria-fowleri\",\"urlToImage\":\"https://i.guim.co.uk/img/media/019239524ac43d119e139a0d7381e70dc50b87e0/0_131_2932_1759/master/2932.jpg?width=1200&height=630&quality=85&auto=format&fit=crop&overlay-align=bottom%2Cleft&overlay-width=100p&overlay-base64=L2ltZy9zdGF0aWMvb3ZlcmxheXMvdGctZGVmYXVsdC5wbmc&enable=upscale&s=3cd4b45b8d4b7a4abfee56d134fe75ac\",\"publishedAt\":\"2023-07-31T14:19:00Z\",\"content\":\"AGeorgiaresidenthasdiedfromararebraininfection,commonlyknownasthebrain-eatingamoeba,statehealthofficialssaidonFriday.\\r\\nThevictimwasinfectedwithNaegleriafowleri,anamoebat…[+2594chars]\"}]}"
}
extension NetworkServicesMock: NetworkServicesProtocol{
    func getTopHeadLines(completion: @escaping (Result<[News_App.Article], Error>) -> Void) {
        let data = Data(NetworkServicesMock.result.utf8)
        do{
            let result = try JSONDecoder().decode(APIResponse.self, from: data)
            completion(.success(result.articles!))
        }catch{
            completion(.failure(error))
        }
    }
    
    
}
