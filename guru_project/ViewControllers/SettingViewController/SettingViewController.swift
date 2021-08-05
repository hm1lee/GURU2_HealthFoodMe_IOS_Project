import UIKit

struct Section {
    let title: String
    let options: [SettingsOption]
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler : (() -> Void)
}

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        return table
    }()
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        swipeRecongnizer()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    func swipeRecongnizer() {
        let swipRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipRight)
    }
    
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    func configure() {
        models.append(Section(title: "General", options: [
            SettingsOption(title: "버전 정보", icon: UIImage(systemName: "book.circle"), iconBackgroundColor: .systemGreen){
                                    
            },
            SettingsOption(title: "서비스 이용약관", icon: UIImage(systemName: "list.bullet.rectangle"), iconBackgroundColor: .systemGreen){
                                                                            
            },
            SettingsOption(title: "개인정보 취급방침", icon: UIImage(systemName: "lock.icloud"), iconBackgroundColor: .systemGreen){
                                                                            
            }
        ]))
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else{
            return UITableViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let model = models[indexPath.section].options[indexPath.row]
//        model.handler()
        performSegue(withIdentifier: "ShowDetail", sender: nil)
    }
}
