//
//  DrawView.swift
//  drawful
//
//  Created by Cambrian on 2022-11-15.
//

import UIKit

class DrawView: UIView {
    
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int?
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        let doubleTabRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
        doubleTabRecognizer.numberOfTapsRequired = 2
        doubleTabRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTabRecognizer)
        
        let tapRecognize = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tapRecognize.numberOfTapsRequired = 1
        tapRecognize.require(toFail: doubleTabRecognizer)
        addGestureRecognizer(tapRecognize)
    }
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double Tap")
        
        selectedLineIndex = nil
        currentLines.removeAll()
        finishedLines.removeAll()
        setNeedsDisplay()
    }
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        print("tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        setNeedsDisplay()
    }
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        for line in finishedLines {
            stroke(line)
        }
        
        UIColor.red.setStroke()
        for (_, line) in currentLines{
            stroke(line)
        }
        
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            stroke(selectedLine)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//
//        let location = touch.location(in: self)
//
//        currentLine = Line(begin: location, end: location)
//
//        setNeedsDisplay()
        
        print(#function)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        // get the touch event
//        let touch = touches.first!
//
//        // get the location of the touch event
//        let location = touch.location(in: self)
//
//        // change the end position of the currentline
//        currentLine!.end = location
//
//        // reload the view
//        setNeedsDisplay()
        
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//
//        let location = touch.location(in: self)
//
//        currentLine!.end = location
//
//        finishedLines.append(currentLine!)
//
//        currentLine = nil
//
//        setNeedsDisplay()
        print(#function)
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            
            currentLines.removeValue(forKey: key)
        }
        setNeedsDisplay()
    }
    
    func indexOfLine(at point: CGPoint) -> Int? {
        // find a line close to point
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        
        return nil
    }
}
