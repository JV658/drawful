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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//
//        let location = touch.location(in: self)
//
//        currentLine = Line(begin: location, end: location)
//
//        setNeedsDisplay()
        
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
}
