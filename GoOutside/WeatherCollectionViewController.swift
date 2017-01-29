//
//  WeatherCollectionViewController.swift
//  GoOutside
//
//  Created by Thomas McKanna on 1/28/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import UIKit

private let reuseableIdentifier = "weatherCell"
private let itemsPerRow = 1
let sectionInsets = UIEdgeInsets(top: 15.0, left: 50.0, bottom: 15.0, right: 50.0)
private let cellHeight: CGFloat = 75.0


class WeatherCollectionViewController: UICollectionViewController {
    
    var weatherForWeek = [DailyWeather]()
    var bgImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "WeatherTableBackgroundHorizontal4"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareBackgroundView()
        
        DailyWeather.getWeather(at: (38.593549,-90.62556)) { weather in
            self.weatherForWeek = weather
            self.refreshUI()
            
            end = DispatchTime.now()
            print("TIME: \(Double(end!.uptimeNanoseconds - start!.uptimeNanoseconds) / 1_000_000_000)")
        }
        
        //decideBackgroundPicture()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        bgImageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        self.refreshUI()
    }
    
    // used to refresh UI on main thread (for faster refresh)
    func refreshUI() {
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
        })
    }
    
    func prepareBackgroundView() {
        bgImageView.contentMode = .scaleAspectFill
        collectionView?.backgroundView = UIView()
        bgImageView.frame = CGRect(x: 0, y: 0, width: (collectionView?.frame.size.width)!, height: (collectionView?.frame.size.height)!)
        collectionView?.backgroundView?.addSubview(bgImageView)
    }
}

extension WeatherCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherForWeek.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseableIdentifier, for: indexPath) as! WeatherCollectionViewCell
        
        dateFormatter.dateFormat = "MM/dd"
        let day = weatherForWeek[indexPath.row]
        
        // Configure the cell...
        cell.dayLabel.text = convertToWeekday(Number: day.weekday)
        cell.dateLabel.text = dateFormatter.string(from: day.time)
        cell.weatherLabel.text = day.weather.rawValue
        cell.highLabel.text = String(day.tempMax)
        cell.lowLabel.text = String(day.tempMin)
        cell.percentLabel.text = "(??)%"
        
        cell.layer.cornerRadius = 4
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = cell.bounds
        cell.backgroundView = blurEffectView

        //blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        return cell
    }
}

extension WeatherCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // width of a cell
        let widthPerItem = view.frame.width - sectionInsets.left - sectionInsets.right
        
        return CGSize(width: widthPerItem, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
}

private extension WeatherCollectionViewController {
    func dayFor(IndexPath indexPath: IndexPath) -> DailyWeather {
        return weatherForWeek[indexPath.row]
    }
}
