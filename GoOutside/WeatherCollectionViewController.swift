//
//  WeatherCollectionViewController.swift
//  GoOutside
//
//  Created by Thomas McKanna on 1/28/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import UIKit

private let reuseableIdentifierForCell = "weatherCell"
private let reusableIdentifierForHeader = "headerView"
private let reusableIdentifierForFooter = "footerView"
private let itemsPerRow = 1
let sectionInsets = UIEdgeInsets(top: 15.0, left: 50.0, bottom: 15.0, right: 50.0)
private let cellHeight: CGFloat = 75.0


class WeatherCollectionViewController: UICollectionViewController {
    
    var weatherForWeek = [DailyWeather]()
    var bgImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "WeatherTableBackgroundHorizontal4"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // temp 
        makeTempScoringArray()
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseableIdentifierForCell, for: indexPath) as! WeatherCollectionViewCell
        
        dateFormatter.dateFormat = "MM/dd"
        let day = weatherForWeek[indexPath.row]
        let score = scoreDay(withTemp: (day.tempMax+day.tempMin)/2, andPrecipProbability: day.precipChance)
        
        
        // Configure the cell...
        cell.dayLabel.text = convertToWeekday(Number: day.weekday)
        cell.dateLabel.text = dateFormatter.string(from: day.time)
        cell.weatherLabel.text = convertToCleanText(Weather: day.weather.rawValue)
        cell.highLabel.text = "High: " + String(day.tempMax) + DEGREE_SYMBOL
        cell.percentLabel.text = String(score)
        
        cell.weatherLabel.textColor = returnColor(ForWeather: day.weather.rawValue)
        cell.percentLabel.textColor = returnColor(ForScore: score)
        
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
        print(section)
        return sectionInsets.top
    }
    
}

private extension WeatherCollectionViewController {
    func dayFor(IndexPath indexPath: IndexPath) -> DailyWeather {
        return weatherForWeek[indexPath.row]
    }
}

extension WeatherCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView? = nil
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reusableIdentifierForHeader, for: indexPath) as! WeatherCollectionReusableView
            headerView.logoLabel.text = "GoOutside"
            headerView.logoLabel.font = UIFont.init(name: "WildRide", size: 125.0)
            headerView.logoLabel.textColor = colorSpring
            
            headerView.view.backgroundColor = colorDarkGrayReducedOpacity
            headerView.layer.cornerRadius = 4
            
            headerView.dateLabel.textColor = UIColor.white
            headerView.weatherLabel.textColor = UIColor.white
            headerView.scoreLabel.textColor = UIColor.white
            
            if UIApplication.shared.statusBarOrientation.isPortrait {
                headerView.scoreLabel.text = "Score"
            }
            else {
                headerView.scoreLabel.text = "Score (1-100)"
            }
            
            reusableView = headerView
        }
        
        if kind == UICollectionElementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reusableIdentifierForFooter, for: indexPath) as! WeatherFooterCollectionReusableView
            
            footerView.footerLabel.text = "Powered by Dark Sky"
            
            reusableView = footerView
        }
        
        return reusableView!
    }
}
