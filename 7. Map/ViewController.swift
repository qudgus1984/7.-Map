//
//  ViewController.swift
//  7. Map
//
//  Created by 이병현 on 2022/03/31.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var myMap: MKMapView!
    @IBOutlet var lblLocationInfo1: UILabel!
    @IBOutlet var lblLocationInfo2: UILabel!
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblLocationInfo1.text = "" // 위치 정보를 표시할 레이블에는 아직 특별히 표시할 필요가 없으므로 공백
        lblLocationInfo2.text = "" // 위치 정보를 표시할 레이블에는 아직 특별히 표시할 필요가 없으므로 공백
        locationManager.delegate = self // 상수 locationManager의 델리게이트를 self로 설정함
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도를 최고로 설정함
        locationManager.requestWhenInUseAuthorization() // 위치 데이터를 추적하기 위해 사용자의 승인을 요구함
        locationManager.startUpdatingLocation() // 위치 업데이트를 시작함
        myMap.showsUserLocation = true // 위치 보기 값을 true로 설정함
    }
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue : CLLocationDegrees, delta span :Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        // 위도 값과 경도 값을 매개변수로 하여 CLLocationCoordinate2DMake 함수를 호출하고 리턴값을 pLocation으로 받음
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        // 범위 값을 매개변수로 하여 MKCoordinateSpanMake 함수를 호출하고, 리턴 값을 spanValue로 받음
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        // pLocation과 spanValue 값을 매개변수로 하여 MKCoordinateRegionMake 함수를 호출하고 리턴 값을 pRegion으로 받음
        myMap.setRegion(pRegion, animated: true) // pRegion값을 매개변수로 하여 myMap.setRegion 함수를 호출
        return pLocation
    }
    
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue : CLLocationDegrees, delta span :Double, title strTitle: String, subtitle strSubtitle:String) {
        let annotation = MKPointAnnotation()
        // 핀을 설치하기 위해 MKPointAnnotation 함수를 호출하여 리턴값을 annotation으로 받음
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        // annotation의 coordinate 값을 goLocation 함수로부터 CLLocation2D 형태로 받아야 하는데 이를 위해서 goLocation 함수를 수정해야 함
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last // 위치가 업데이트되면 먼저 마지막 위치 값을 찾아냄
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue:
                    (pLocation?.coordinate.longitude)!, delta: 0.01)
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            (placemarks, error) -> Void in
            let pm = placemarks!.first // placemarks 값의 첫 부분만 pm 상수로 대입
            let country = pm!.country // pm 상수에서 나라 값을 country  상수에 대입
            var address:String = country! // 문자열 address에 country 상수 값을 대입
            if pm!.locality != nil { // pm 상수에서 지역 값이 존재하면 address 문자열에 추가함
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil { // pm 상수에서 도로 값이 존재하면 address 문자열에 추가
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.lblLocationInfo1.text = "현재 위치" // 레이블에 "현재 위치" 텍스트를 표시
            self.lblLocationInfo2.text = address // 레이블에 address 문자열의 값을 표시
            
        })
        
        locationManager.stopUpdatingLocation() // 마지막으로 위치가 업데이트 되는 것을 멈추게 함
        
        // 마지막 위치의 위도와 경도 값을 가지고 앞에서 만든 goLocation 함수를 호출함. 이때 delta 값은 지도의 크기를 정하는데, 값이 작을수록 확대되는 효과가 있음. delta를 0.01로 하였으니 1의 값보다 지도를 100배로 확대해서 보여줄 것
    }

    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.lblLocationInfo1.text = ""
            self.lblLocationInfo2.text = ""
            locationManager.startUpdatingLocation()
            // 현재 위치 표시
        } else if sender.selectedSegmentIndex == 1 {
            setAnnotation(latitudeValue: 37.602638, longitudeValue: 126.955252, delta: 1, title: "상명대학교 서울캠퍼스", subtitle: "서울특별시 종로구 홍지문2길 20")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "상명대학교 서울캠퍼스"
            // 상명대학교 표시
        } else if sender.selectedSegmentIndex == 2 {
            setAnnotation(latitudeValue: 37.506074, longitudeValue: 126.860826, delta: 0.1, title: "우리 집", subtitle: "서울특별시 중앙로 12길 17-8")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "고척 리가아파트"
            // 우리 집 표시
        }
        
    }
    
}

