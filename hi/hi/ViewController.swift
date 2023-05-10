//
//  ViewController.swift
//  hi
//
//  Created by Margarita Yaganova on 08.05.2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sickLabel: UILabel!
    @IBOutlet weak var healthyLabel: UILabel!
    
    var n1: String? // число ячеек
    var m1: String? // максимальное количество окрашиваемых ячеек
    var t1: String? // время задержки в секундах
    
    lazy var n: Int = Int(n1 ?? "") ?? 0 // число ячеек
    lazy var m: Int = Int(m1 ?? "") ?? 0             // максимальное количество окрашиваемых ячеек
    lazy var t: Double = Double(t1 ?? "") ?? 0             // время задержки в секундах
    
    var cellSize: CGFloat = 50           // размер ячейки
    var cellSpacing: CGFloat = 10        // расстояние между ячейками
    var cellsPerRow = 4
    var cellsPerColumn = 2
    let maxCellsPerRow = 6
    
    let pic = UIImage(named: "man")
    
    lazy var sickCount: Int = 0          // количество больных ячеек
    lazy var healthyCount: Int = n       // количество здоровых ячеек
    
    var cells: [UICollectionViewCell] = [] // массив ячеек
    
    @IBOutlet weak var resetButtonPressed: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let goVC = presentingViewController as? GoViewController {
            goVC.sumbittionButton.alpha = 1
            goVC.randomButton.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        n1 = (presentingViewController as? GoViewController)?.n1
        m1 = (presentingViewController as? GoViewController)?.m1
        t1 = (presentingViewController as? GoViewController)?.t1
        

        resetButtonPressed.layer.cornerRadius = 25
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        
        
        layout.scrollDirection = .vertical
            layout.minimumLineSpacing = cellSpacing
            layout.minimumInteritemSpacing = cellSpacing
            layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        collectionView.collectionViewLayout = layout
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        for _ in 0..<n {
            cells.append(UICollectionViewCell())
        }
        
        collectionView.alwaysBounceVertical = true // включение скролл-эффекта
        collectionView.contentSize = CGSize(width: collectionView.frame.width, height: (cellSize + cellSpacing) * CGFloat(n/m))
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
            collectionView.addGestureRecognizer(pinchGesture)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let screenWidth = UIScreen.main.bounds.width
        let availableWidth = screenWidth - (CGFloat(cellsPerRow + 1) * cellSpacing)
        let cellWidth = availableWidth / CGFloat(cellsPerRow)

        return CGSize(width: cellWidth, height: cellWidth)
    }

    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        if gestureRecognizer.state == .changed {
            let scale = gestureRecognizer.scale

            // считаем новое количество ячеек
            var newCellsPerRow = max(Int(round(Double(cellsPerRow) / scale)), 1)

            // добавляем минимальные/максимальные ограничения
            if newCellsPerRow > maxCellsPerRow {
                newCellsPerRow = maxCellsPerRow
            } else if newCellsPerRow < 1 {
                newCellsPerRow = 1
            }

            // обновляем размер таблицы
            let screenWidth = UIScreen.main.bounds.width
            let availableWidth = screenWidth - (CGFloat(newCellsPerRow + 1) * cellSpacing)
            let cellWidth = availableWidth / CGFloat(newCellsPerRow)
            layout.itemSize = CGSize(width: cellWidth, height: cellWidth)

            // Update number of cells
            cellsPerRow = newCellsPerRow

            layout.invalidateLayout()
            collectionView.layoutIfNeeded()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return n
    }
    
    var cellColors: [UIColor] = []

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
        cell.backgroundView = UIImageView(image: pic)
        if cellColors.indices.contains(indexPath.item) {
            cell.backgroundColor = cellColors[indexPath.item]
        } else {
            cell.backgroundColor = UIColor.green // зеленый цвет при создании ячейки
            cellColors.append(cell.backgroundColor ?? UIColor.green)
        }
        cells[indexPath.item] = cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        if cell.backgroundColor == UIColor.green {
            cell.backgroundColor = UIColor.red // красный цвет при нажатии на зеленую ячейку
            
            DispatchQueue.global().async {
                self.sickCount += 1
                self.healthyCount -= 1
                
                DispatchQueue.main.async {
                    self.updateLabels()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + t, execute: {
                self.colorRandomCells(cell: cell)
            })
        }
    }
    
    func colorRandomCells(cell: UICollectionViewCell) {
        guard let index = collectionView.indexPath(for: cell) else {
            return
        }
        
        let row = index.item / Int(sqrt(Double(n)))
        let col = index.item % Int(sqrt(Double(n)))
        var count = Int.random(in: 0...m)
        var indexes: [Int] = []
        if row > 0 {
            indexes.append((row-1) * Int(sqrt(Double(n))) + col)
        }
        if row < Int(sqrt(Double(n)))-1 {
            indexes.append((row+1) * Int(sqrt(Double(n))) + col)
        }
        if col > 0 {
            indexes.append(row * Int(sqrt(Double(n))) + col - 1)
        }
        if col < Int(sqrt(Double(n)))-1 {
            indexes.append(row * Int(sqrt(Double(n))) + col + 1)
        }
        
        indexes.shuffle()
        
        for i in 0..<indexes.count {
            let index = indexes[i]
            if index >= 0 && index < self.cells.count {
                let randomDelay = Double.random(in: 0...t)
                DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay, execute: {
                    if count > 0 &&  self.cells[index].backgroundColor != UIColor.red {
                        if index >= 0 && index < self.cellColors.count {
                            self.cellColors[index] = UIColor.red
                        }
                        self.cells[index].backgroundColor = UIColor.red
                        self.sickCount += 1
                        self.healthyCount -= 1
                        
                        count -= 1
                        self.updateLabels()
                        self.colorRandomCells(cell: self.cells[index])
                    }
                })
                if count == 0 {
                    break
                }
            }
        }
    }
    
    func updateLabels() {
        sickLabel.text = "Заражены: \(sickCount)"
        healthyLabel.text = "Здоровы: \(healthyCount)"
    }
    
    @IBAction func startReset(_ sender: UIButton) {
        sickCount = 0
            healthyCount = n
            for cell in cells {
                cell.backgroundColor = UIColor.green
            }
            updateLabels()
    }
}
