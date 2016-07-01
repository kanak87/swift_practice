//
//  main.swift
//  swift-practice
//
//  Created by YongEun on 2016. 7. 1..
//  Copyright © 2016년 YongEun. All rights reserved.
//

import Foundation

var str:String = "Hello, playground"
let num:Int = 10

let name = "YongEun"
var family_name = "Jung"

print("\(name) \(family_name)")
print(name + " " + family_name)

var num_list = [1, 2, 3, 4, 5]
var num_dic = [ "one":1, 2:"two", "three":"three"]

print(num_list[0])
print(num_dic[2])
print(num_dic[3])

for num in num_dic
{
    print(num)
}

for num in num_list
{
    print(num)
}

for var i = 0; i < num_list.count; ++i
{
    print(num_list[i])
}

for i in 0 ..< num_list.count
{
    print(num_list[i])
}

for i in 0 ..< 5
{
    print(num_list[i])
}
print("---------------------")
if num_list[0] > num_list[1]
{
    print("haha")
}
else if num_list[1] > num_list[2]
{
    print("nono")
}
else
{
    print("hoho")
}

var input_value = 2//"kk"
switch input_value
{
    //case "a":
    //    print("aaaaa")
    case 1:
        print(1)
    default:
        print("default")
}


func sumOfNum(number1:Int, number2:Int) -> Int
{
    return number1 + number2
}

print(sumOfNum(20, number2:30))

func sums(numbers:Int...) -> Int
{
    var sum = 0
    for num in numbers
    {
        sum += num
        
    }
    
    return sum
}

print(sums(0,1,2,3,4,5))

func castNumber(num:Int) -> (f:Float, b:Bool, s:String)
{
    return (Float(num), Bool(num), String(num))
}

print(castNumber(100))
//print(type(castNumber(20))) => tuple?

print("--------------")

// optional
var t:Int?
print(t)
t = 100
print(t)
t = nil
print(t)
t = 100
print(t!) // Forced-Unwrapping

//var t2:Int? = nil
var t2:Int? = 100
if let val = t2 // Optional Binding
{
    //print("t2 \(t2!) not nil");
    print("t2 \(val) not nil");
}
else
{
    print("t2 \(t2) nil");
}


var tempDict = [ "one":["two":["three":3]] ]

if let val = tempDict["one"]?["two2"]?["three"] // Optional Chaining
{
    print(val)
}
else
{
    print("no val")
}

print(tempDict["one"]!["two"]!["three"]!)
//print(tempDict["one"]!["two2"]!["three"]!)