//
//  ViewController.swift
//  ChallengeCrousalSample
//
//  Created by Vikas Kumar on 13/12/22.
//

import UIKit
import iCarousel

class ViewController: UIViewController {
    
    var carouselTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CarouselCell.self, forCellReuseIdentifier: String(describing: CarouselCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.separatorColor               = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(carouselTableView)
        carouselTableView.dataSource = self
        carouselTableView.delegate = self
        
        let constraints = [
            carouselTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            carouselTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
//        carousel = iCarousel.init(frame: CGRect(x: 20, y: 250, width: view.bounds.width - 40, height: 420))
//        carousel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        carousel.type = .rotary
//        carousel.dataSource = self
//        carousel.delegate = self
//        carousel.backgroundColor = .yellow
//
//        view.addSubview(carousel)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CarouselCell.self), for: indexPath) as? CarouselCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .orange
        return cell
    }
}

class CarouselCell: UITableViewCell {
    
    var carouselView: iCarousel = {
        let carousel = iCarousel.init()
        carousel.type = .rotary
        carousel.backgroundColor = .yellow
        carousel.translatesAutoresizingMaskIntoConstraints = false
        return carousel
    }()
    
    // MARK: - Cell Init Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(carouselView)
        carouselView.dataSource = self
        carouselView.delegate = self
        
        let constraints = [
            carouselView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            carouselView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            carouselView.topAnchor.constraint(equalTo: contentView.topAnchor),
            carouselView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 350)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CarouselCell: iCarouselDataSource, iCarouselDelegate {
    
    func numberOfItems(in carousel: iCarousel) -> Int { 3 }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if let view = view {
            let label = view.viewWithTag(1) as? UILabel
            label?.text = "\(index + 1)"
            return view
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: carousel.bounds.width - 90, height: carousel.bounds.height))
            view.backgroundColor = .lightGray
            view.layer.cornerRadius = 20
            view.layer.borderWidth = 1
            view.clipsToBounds = true
            view.layer.borderColor = UIColor.gray.cgColor
            let label = UILabel(frame: view.bounds)
            label.textAlignment = .left
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 30)
            label.tag = 1
            label.text = "\(index + 1)"
            view.addSubview(label)
            return view
        }
    }
    func carousel(_ carousel: iCarousel, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        let count: CGFloat = 3.0
        let spacing: CGFloat = 2.0
        let arc: CGFloat = CGFloat.pi * 2.0
        let itemWidth: CGFloat = carousel.bounds.width - 100.0
        let radius: CGFloat = max(itemWidth * spacing / 2.0, itemWidth * spacing / 2.0 / tan(arc/2.0/count))
        let angle = offset / count * arc
        return CATransform3DTranslate(transform, radius * sin(angle), 0.0, cos(angle) - radius)
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        //customize carousel display
        switch option {
        case .count:
            return 3
        case .wrap:
            return CGFloat(truncating: true)
        case .fadeMin:
            return -0.7
        case .fadeMax:
            return 0.7
        default:
            return value
        }
    }
}
