//
//  ViewController.swift
//  Paint_App
//
//  Created by Gokul Gopalakrishnan on 07/12/21.
//

import UIKit


struct Modified_point
{
    var stroke: Float
    var color: Int
    var Points: [CGPoint]
}

var Points = [Modified_point]()

var SizeofSlider = 10

var Color: [UIColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1),#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1),#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)]

var Color_type: Int = 0



class ViewController: UIViewController {
    
    let canvas = Canvas()
    
   
    @IBOutlet weak var Paint_Collection: UICollectionView!
    
    @IBOutlet weak var Download_click: UIButton!
    
    @IBOutlet weak var Revert_click: UIButton!
    
    @IBOutlet weak var Eraser_click: UIButton!
    
    @IBOutlet weak var Slider_Size: UISlider!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(canvas)
        canvas.backgroundColor = .white
        
        canvas.translatesAutoresizingMaskIntoConstraints = false
        
        canvas.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true

        canvas.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        canvas.bottomAnchor.constraint(equalTo: Paint_Collection.topAnchor,constant: -5).isActive = true
        
    
        
  
    }
  
    
    @IBAction func Size_Slider(_ sender: UISlider) {
        
        SizeofSlider = Int(sender.value)
    }
    
    
    @IBAction func Clear_button(_ sender: Any) {
        
        canvas.clear()
      
    }
    
    
    @IBAction func Undo_butto(_ sender: Any) {
        
        canvas.undo()
    }
    
}



extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Color.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = Color[indexPath.row]
        cell.layer.cornerRadius = 5
                return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        Color_type = indexPath.row
        
    }
   
}


class Canvas: UIView
{
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
      
        guard let context = UIGraphicsGetCurrentContext()
        
        else
        {
            return
        }
        
       
        context.setLineCap(.butt)
        
    
        
        Points.forEach {( line ) in
            
            context.setLineWidth(CGFloat(line.stroke))
            context.setStrokeColor(Color[line.color].cgColor)

            for (i,j) in line.Points.enumerated()
            {
                if(i == 0)
                {
                    context.move(to: j)
             
                }else
                {
                    context.addLine(to: j)
                }
            }
          context.strokePath()
        }
              
    }
    
    func clear()
    {
        Points.removeAll()
        setNeedsDisplay()
    }
    
    func undo()
    {
        Points.popLast()
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        Points.append(Modified_point.init(stroke: Float(SizeofSlider), color: Color_type, Points: [] ))
    
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        guard let Coordiante = touches.first?.location(in: nil) else
        {
            return
        }
    
        guard var lastline = Points.popLast() else  { return }
        
        lastline.Points.append(Coordiante)
        
        Points.append(lastline)
        
      
        
        setNeedsDisplay()
    }
 
  
}
