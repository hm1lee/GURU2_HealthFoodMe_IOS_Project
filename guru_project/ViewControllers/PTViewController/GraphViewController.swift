//
//  GraphViewController.swift
//  guru_project
//
//  Created by 양성혜 on 2021/08/03.
//

import UIKit
import Charts
import FirebaseDatabase

class GraphViewController:UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var dayLabel: UILabel!
    
   
    var ref: DatabaseReference!
    var refHandle:DatabaseHandle!
    
    var unitssDay: [String] = []
    var unitsTime: [Double] = []
   
    var day  = ""
    var time = 0
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        dayLabel.text = "\(day)"
        
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setChart(dataPoints: unitssDay, values: unitsTime)
    }
    
    func getData(){
        
        refHandle = ref.child("users/user_pt/\(day)").observe(DataEventType.value, with: { snapshop in
            let ptDict = snapshop.value as? [String: AnyObject] ?? [:]
            for(key, value) in ptDict {
                self.unitssDay.append(value["PTName"]!! as! String)
                print(self.unitssDay)
            }
        })
        
        refHandle = ref.child("users/user_pt/\(day)").observe(DataEventType.value, with: { snapshop in
            let ptDict = snapshop.value as? [String: AnyObject] ?? [:]
            for(key, value) in ptDict {
                self.unitsTime.append(value["PTTime"]!! as! Double)
                print(self.unitsTime)
            }
        })
    }
    
    func setChart(dataPoints: [String], values: [Double]) {

        // 데이터 생성
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
                dataEntries.append(dataEntry)
        }
                
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "운동")
                
        // 차트 컬러
        chartDataSet.colors = [.brown]
                
        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
                
        // 선택 안되게
        chartDataSet.highlightEnabled = false
        // 줌 안되게
        barChartView.doubleTapToZoomEnabled = false

        // X축 레이블 위치 조정
        barChartView.xAxis.labelPosition = .bottom
        // X축 레이블 포맷 지정
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: unitssDay)
                
        // X축 레이블 갯수 최대로 설정 (이 코드 안쓸 시 Jan Mar May 이런식으로 띄엄띄엄 조금만 나옴)
        barChartView.xAxis.setLabelCount(dataPoints.count, force: false)
                
        // 오른쪽 레이블 제거
        barChartView.rightAxis.enabled = false
                
        // 기본 애니메이션
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.0)

        // 미니멈
        barChartView.leftAxis.axisMinimum = 0

        // 백그라운드컬러
        barChartView.backgroundColor = .white
    }
     
    
    @IBAction func pressedPT(_ sender: UIButton) {
        
        let ptVC = storyboard?.instantiateViewController(withIdentifier: "ptVC") as! PTViewController
        ptVC.modalPresentationStyle = .fullScreen
        ptVC.modalTransitionStyle = .crossDissolve
        
        self.present(ptVC, animated: true, completion: nil)
    }
    
    @IBAction func pressedHome(_ sender: UIButton) {
    }
}
