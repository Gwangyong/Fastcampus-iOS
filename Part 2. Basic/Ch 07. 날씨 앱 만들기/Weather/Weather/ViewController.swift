import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            // endEditing(true)가 버튼이 눌리면 키보드가 사라지도록 해줌
            self.view.endEditing(true)
            
        }
    }
    
    func configureView(weatherInformation: WeatherInformation) {
        self.cityNameLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))℃"
        self.minTempLabel.text = "최저: \(Int(weatherInformation.temp.minTemp - 273.15))℃"
        self.maxTempLabel.text = "최고: \(Int(weatherInformation.temp.maxTemp - 273.15))℃"
    }
    
    // 없는 도시 이름일 경우, 에러 알럿이 뜨는 코드
    func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=dc415b07fffe8ff6db2d061c0f72d784") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            // success 하려면 상태 코드가 200대 여야 하므로, 범위를 정해줌
            let successRange = (200..<300)
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            // response를 HTTPURLResponse로 다운캐스팅을 하고 상태코드에 맞는 실행을 하기위한 코드 작성
            // successRange가 200 ~ 299까지이니, 200번대이면 아래의 코드들을 실행할 수 있도록 해줌
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                // decode가 실패하면 오류를 던지기 때문에, try? 를 사용함
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                
                // completion Handler에서 UI 작업을 한다면, 메인 스레드에서 작업을 할 수 있도록 해주어야함
                // 메인 스레드에서 작업할 수 있도록 해주는 코드
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    // 위에서 Hidden을 풀어주었으니, 아래 코드로 다시 값을 넘겨줘서 Hidden이 풀린걸로 보이도록 해줌
                    self?.configureView(weatherInformation: weatherInformation)
                }
            } else { // HTTP 응답 코드가 200 번대가 아닌, 오류코드인 경우
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                // 메인 스레드에서 Alert이 표시되도록 해야함
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
            // 모든 작업은 일시정지 상태로 시작되는데, resume()를 호출하면 data task가 실행된다.
        }.resume()
    }
}

