//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let dateMakerFormatter = NSDateFormatter()
//dateMakerFormatter.calendar = userCalendar
let userCalendar = NSCalendar.currentCalendar()


dateMakerFormatter.dateFormat = "yyyy/MM/dd hh:mm a Z"
let startTime = dateMakerFormatter.dateFromString("2016/07/27 10:45 AM -05:00")!
print(startTime)
//let endTime = dateMakerFormatter.dateFromString("2016/07/27 12:00 PM -05:00")!
let endTime = NSDate()
let hourMinuteSecondsComponents: NSCalendarUnit = [.Hour, .Minute, .Second]
let timeDifference = userCalendar.components(
    hourMinuteSecondsComponents,
    fromDate: startTime,
    toDate: endTime,
    options: [])
print("ans")
timeDifference.hour
timeDifference.minute
timeDifference.second