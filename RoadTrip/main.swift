//
// main.swift
// RoadTrip
// Created by Валерия Пономарева on 18.05.2026.

import Foundation

// MARK: - 1️⃣ Описание программы
print("🚕💨 Road Trip")
print("📝 Планирование автопутешествия: время убытия/прибытия, города, расстояния, расход и цены на топливо, гостиницу.")
print("Программа считает общую стоимость поездки (топливо + ночёвки) и время в пути.")

// MARK: - 2️⃣ Модель данных
struct Location {
    let name: String
    let distanceFromPrevious: Double
}

var route: [Location] = [
    Location(name: "пос. Элита",            distanceFromPrevious:   0.0),
    Location(name: "Козулька",              distanceFromPrevious:  89.0),
    Location(name: "Ачинск",                distanceFromPrevious: 147.0),
    Location(name: "Боготол",               distanceFromPrevious: 218.0),
    Location(name: "Каштан",                distanceFromPrevious: 239.0),
    Location(name: "Верх-Чебула",           distanceFromPrevious: 362.0),
    Location(name: "Березовский",           distanceFromPrevious: 473.0),
    Location(name: "поселок шахты 'Южная'", distanceFromPrevious: 475.0),
    Location(name: "Кемерово",              distanceFromPrevious: 507.0)
]

var fuelConsumption: Double = 9.5
var fuelPrice:       Double = 65.8
var hotelPrice:      Double = 5900.0
var departureElita:  String = "12.00"
var departureKemerovo:String = "15.00"
var averageSpeed:    Double = 70.0

// MARK: - Команды как enum
enum Command: String {
    case addLocation               = "add location"
    case showRoute                 = "show route"
    case calculateTotal            = "calculate total"
    case exit                      = "exit"
    case calculareArrivalTime      = "calculate arrival time"
    case calculareArrivalTimeBack  = "calculate arrival time back"
    case showTripTime              = "show trip time"

    static func from(_ string: String) -> Command? {
        Command(rawValue: string.lowercased())
    }
}

// MARK: - 2️⃣.1 Логика / вычисления

func totalDistanceThere() -> Double {
    route.last?.distanceFromPrevious ?? 0
}

func totalDistanceBack() -> Double {
    guard let last = route.last else { return 0 }
    return last.distanceFromPrevious
}

func formatTravelTime(_ hours: Double) -> String {
    let h = Int(hours)
    let m = Int((hours - Double(h)) * 60)
    return "\(h) часов \(m) минут"
}

func calcArrivalTime(departure: String, travelHours: Double) -> String {
    let parts = departure.split(separator: ".")
    guard parts.count == 2,
          let hour = Int(parts[0]),
          let minute = Int(parts[1])
    else { return "ошибка" }

    let depMinutes = hour * 60 + minute
    let travelMinutes = Int(travelHours * 60)
    let arrivalMinutes = depMinutes + travelMinutes

    let h = arrivalMinutes / 60
    let m = arrivalMinutes % 60

    return String(format: "%02d.%02d", h, m)
}

func calcFuelCost(distance: Double) -> Double {
    let liters = distance / 100 * fuelConsumption
    return liters * fuelPrice
}

let totalCostTrip = calcFuelCost(distance: totalDistanceThere()) * 2
                   + hotelPrice * 1

// MARK: - 3️⃣ Game loop

gameLoop: while true {
    print("\n📋 Доступные команды:")
    print("  - show route")
    print("  - calculate total")
    print("  - calculate arrival time")
    print("  - calculate arrival time back")
    print("  - show trip time")
    print("  - exit")

    guard let rawCommand = readLine() else { break }

    let command = Command.from(rawCommand)

    // Если команда не распознана, печатаем список
    guard let cmd = command else {
        print("❌ Неизвестная команда. Попробуйте одну из:")
        print("  - show route")
        print("  - calculate total")
        print("  - calculate arrival time")
        print("  - calculate arrival time back")
        print("  - show trip time")
        print("  - exit")
        continue
    }

    switch cmd {
    case .showRoute:
        for (i, loc) in route.enumerated() {
            print("\(i + 1). \(loc.name) – \(loc.distanceFromPrevious) км")
        }

    case .calculateTotal:
        print(String(format: "💰 Общая стоимость поездки: %.2f руб", totalCostTrip))

    case .calculareArrivalTime:
        let time = totalDistanceThere() / averageSpeed
        let arrival = calcArrivalTime(departure: departureElita, travelHours: time)
        print("🚗 Прибытие в Кемерово: \(arrival)")

    case .calculareArrivalTimeBack:
        let time = totalDistanceBack() / averageSpeed
        let arrival = calcArrivalTime(departure: departureKemerovo, travelHours: time)
        print("🚗 Прибытие в Элиту: \(arrival)")

    case .addLocation:
        print("Введите название города:")
        let name = readLine() ?? ""
        print("Введите расстояние от предыдущего города (км):")
        guard let dist = Double(readLine() ?? "") else {
            print("❌ Неверное расстояние")
            continue
        }
        let lastDist = route.last?.distanceFromPrevious ?? 0
        let new = Location(name: name, distanceFromPrevious: lastDist + dist)
        route.append(new)
        print("✅ Город \(name) добавлен!")

    case .showTripTime:
        let timeThere = totalDistanceThere() / averageSpeed
        let timeBack  = totalDistanceBack()  / averageSpeed
        print("⏰ Время в пути туда: \(formatTravelTime(timeThere))")
        print("⏰ Время в пути обратно: \(formatTravelTime(timeBack))")

    case .exit:
        print("До свидания! 🚕💨")
        break gameLoop
    }
}
