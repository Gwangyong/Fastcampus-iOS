import Foundation

// Codable: 자신을 변환하거나 외부 표현(JSON으로 생각)으로 변환할 수 있는 타입
struct WeatherInformation: Codable {
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    // 기본적으로 JSON 형태의 데이터로 변환하려면, JSON 타입의 키와 사용자가 정의한 프로퍼티가 일치해야한다.
    // 이 때, key와 프로퍼티의 이름을 다르게 하고싶을 경우에 CodingKeys라는 String 타입의 열거형을 통해서 CodingKey프로토콜을 준수하게 만들면 된다.
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
