//
//  main.swift
//  RoadTrip
//
//  Created by Валерия Пономарева on 18.05.2026.
//

import Foundation

// MARK: - 1️⃣ Описание программы 'RoadTrip'
print(" 🚕💨 Road Trip")
print("📝 User планирует автопутешествие: 🧭 время убытия / прибытия, общее время в пути, 🗺️ добавляет города, 🏁 расстояние между ними, указывает ⛽ расход топлива, цены на топливо и 🏨 гостиницу.")
print("Программа считает 💰 общую стоимость поездки (топливо + ночёвки) и время в пути.")

// MARK: - 2️⃣ Модель данных(команды)

struct Location {
    let name: String
    let distanceFromPrevious: Double
}

var route: [Location] = [
    Location(name: "пос. Элита", distanceFromPrevious: 0.0),
    Location(name: "Козулька", distanceFromPrevious: 89.0),
    Location(name: "Ачинск", distanceFromPrevious: 147.0),
    Location(name: "Боготол", distanceFromPrevious: 218.0),
    Location(name: "Каштан", distanceFromPrevious: 239.0),
    Location(name: "Верх-Чебула", distanceFromPrevious: 362.0),
    Location(name: "Березовский", distanceFromPrevious: 473.0),
    Location(name: "поселок шахты 'Южная'", distanceFromPrevious: 475.0),
    Location(name: "Кемерово", distanceFromPrevious: 507.0)
]

var fuelConsumption: Double = 9.5 // liter/100 km
var fuelPrice: Double = 65.8
var hotelPrice = 5900.0
var departureTimeFromElita: String = "12.00"
var departureTimeFromKemerovo: String = "15.00"
var averageSpeed: Double = 70.0

enum Command: String {
    case addLocation = "add location"
    case showRoute = "show route"
    case calculateTotal = "calculate total"
    case exit = "exit"
    case calculareArrivalTime = "calculate arrival time"
    case calculareArrivalTimeBack = "calculate arrival time back"
    case showTripTime = "show trip time"
}
// 2️⃣.1 Методы
func calcDistanceTo() -> Double { // расчет общего расстояния туда
    return route.last?.distanceFromPrevious ?? 0.0
}

func calcDistanceBack() -> Double {
    var total: Double = 0.0
    
    for i in stride(from: route.count - 1, through: 1, by: -1) {
        let difference = route[i].distanceFromPrevious - route[i - 1].distanceFromPrevious
        total += difference
    }
    return total
}

func formatTravelTime(_ travelHours: Double) -> String {
    let hours = Int(travelHours) // целая часть = 7 часов
    let minutesPart = travelHours - Double(hours) // 0.24
    let minutes = Int(minutesPart * 60) // 0.24 × 60 = 14.4 → 14 минут
    return "\(hours) часов \(minutes) минут" // "7 ч 14 мин"
}

let timeThere = calcDistanceTo() / averageSpeed
print("Время в пути туда: \(formatTravelTime(timeThere))")

func calcArrivalTime(departure: String, travelHours: Double) -> String {
    // 1. Разбираем строку "12.00" → 12 и 0
    let parts = departure.split(separator: ".")
    guard let depHour = Int(parts[0]), let depMinute = Int(parts[1]) else {
        return "ошибка"
    }
    
    // 2. Переводим отправление в минуты
    let departureMinutes = depHour * 60 + depMinute  // 720
    
    // 3. Переводим время в пути в минуты
    let travelMinutes = Int(travelHours * 60)  // 7.242857 × 60 = 434 минут
    
    // 4. Складываем
    let arrivalMinutes = departureMinutes + travelMinutes  // 720 + 434 = 1154
    
    // 5. Переводим обратно в часы и минуты
    let arrivalHour = arrivalMinutes / 60  // 1154 / 60 = 19
    let arrivalMinute = arrivalMinutes % 60  // 1154 % 60 = 14
    
    // 6. Форматируем строку
    return String(format: "%02d.%02d", arrivalHour, arrivalMinute)  // "19.14"
}
    
func calcFuelCost(distance: Double) -> Double { // считаем расход топлива
    let liters = (distance / 100) * fuelConsumption
    return liters * fuelPrice
}

func calcOvernightStays(hotelPrice: Double, days: Int) -> Double {
    return hotelPrice * Double(days)
}

let totalCostTrip = calcFuelCost(distance: calcDistanceTo()) * 2 + hotelPrice * 1

gameLoop: while true {
    print("\n📋 Доступные команды:")
    print("  - show route")
    print("  - calculate total")
    print("  - calculate arrival time")
    print("  - calculate arrival time back")
    print("  - show trip time")
    print("  - exit")
    
    let input = readLine() ?? ""
    
    switch input {
    case "show route":
        for (index, location) in route.enumerated() {
            print("\(index + 1). \(location.name) - \(location.distanceFromPrevious) км")
        }
        
    case "calculate total":
        print("💰 Общая стоимость поездки: \(totalCostTrip) руб")
        
    case "calculate arrival time":
        let arrival = calcArrivalTime(departure: departureTimeFromElita, travelHours: calcDistanceTo() / averageSpeed)
        print("🚗 Прибытие в Кемерово: \(arrival)")
        
    case "calculate arrival time back":
        let arrival = calcArrivalTime(departure: departureTimeFromKemerovo, travelHours: calcDistanceBack() / averageSpeed)
        print("🚗 Прибытие в Элиту: \(arrival)")
        
    case "add location":
        print("Введите название города:")
        let name = readLine() ?? ""
        print("Введите расстояние от предыдущего города (км):")
        let distance = Double(readLine() ?? "") ?? 0.0
        let lastDistance = route.last?.distanceFromPrevious ?? 0.0
        let newLocation = Location(name: name, distanceFromPrevious: lastDistance + distance)
        route.append(newLocation)
        print("✅ Город \(name) добавлен!")
        
    case "show trip time":
        let timeThere = calcDistanceTo() / averageSpeed
        let timeBack = calcDistanceBack() / averageSpeed
        print("⏰ Время в пути туда: \(formatTravelTime(timeThere))")
        print("⏰ Время в пути обратно: \(formatTravelTime(timeBack))")
        
    case "exit":
        print("До свидания! 🚕💨")
        break gameLoop
        
    default:
        print("❌ Неизвестная команда")
    }
}
