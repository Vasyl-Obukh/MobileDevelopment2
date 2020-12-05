
import Foundation


let studentsStr = "Бортнік Василь - ІВ-72; Чередніченко Владислав - ІВ-73; Гуменюк Олександр - ІВ-71; Корнійчук Ольга - ІВ-71; Киба Олег - ІВ-72; Капінус Артем - ІВ-73; Овчарова Юстіна - ІВ-72; Науменко Павло - ІВ-73; Трудов Антон - ІВ-71; Музика Олександр - ІВ-71; Давиденко Костянтин - ІВ-73; Андрющенко Данило - ІВ-71; Тимко Андрій - ІВ-72; Феофанов Іван - ІВ-71; Гончар Юрій - ІВ-73"

var studentsGroups: [String: [String]] = [:]

for i in studentsStr.components(separatedBy: "; "){
	struct nameGroup {
		let name: String
		let group: String

		init(_ pairOfStrings: [String]) {
			name = pairOfStrings[0]
			group = pairOfStrings[1]
		}
	}
	let  getPair = nameGroup(i.components(separatedBy: " - "))
	if studentsGroups[getPair.group] == nil {
		studentsGroups[getPair.group] = [getPair.name]
		} else {
		studentsGroups[getPair.group]?.append(getPair.name)
		}
	}

for group in studentsGroups.keys {
		studentsGroups[group]?.sort()
	}


print(studentsGroups)
print()

let points: [Int] = [5, 8, 15, 15, 13, 10, 10, 10, 15]

func randomValue(maxValue: Int) -> Int {
    switch(arc4random_uniform(6)) {
    case 1:
        return Int(ceil(Float(maxValue) * 0.7))
    case 2:
        return Int(ceil(Float(maxValue) * 0.9))
    case 3, 4, 5:
        return maxValue
    default:
        return 0
    }
}

var studentPoints: [String: [String: [Int]]] = [:]

// Add your code here
for group in studentsGroups.keys {
	studentPoints[group] = [:]

	for name in studentsGroups[group]! {
		studentPoints[group]?[name] = []

		for point in points {
			studentPoints[group]?[name]?.append(randomValue(maxValue: point))
		}
	}
}

print(studentPoints)
print()

var sumPoints: [String: [String: Int]] = [:]

for group in studentPoints.keys {
	sumPoints[group] = [:]

	for name in studentPoints[group]!.keys {
		var sumPoint = 0

		for i in studentPoints[group]![name]! {
			sumPoint += i
		}
		sumPoints[group]![name] = sumPoint
	}
}


print(sumPoints)
print()

var groupAvg: [String: Float] = [:]

for group in sumPoints.keys {
	var sumGroup = 0
	for i in sumPoints[group]!.values {
		sumGroup += i
	}
	groupAvg[group] = Float(sumGroup)/Float(sumPoints[group]!.values.count)
}

print(groupAvg)
print()

var passedPerGroup: [String: [String]] = [:]

for group in sumPoints.keys {
	passedPerGroup[group] = []

	for name in sumPoints[group]!.keys {
		if sumPoints[group]![name]! >= 60 {
			passedPerGroup[group]!.append(name)
		}
	}
}



print(passedPerGroup)

enum Direction {
	case N
	case S
	case W
	case E
}

enum MyExceptions: Error {
	case wrongDeg
	case wrongSec
	case wrongMin
}

class CoordinateVO {
	var lat_direction, lon_direction: Direction
	var lon_minutes, lat_minutes, lon_seconds, lat_seconds: Int
	var lat_deg, lon_deg: Int

	init() {
		lat_direction = .S
		lon_direction = .W
		lat_deg = 0
		lon_deg = 0
		lon_minutes = 0
		lon_seconds = 0
		lat_minutes = 0
		lat_seconds = 0

	}

	init(_ lat_d: Int, _ lon_d: Int, _ lat_m: Int, _ lon_m: Int, _ lat_s: Int, _ lon_s: Int) throws {
		lat_deg = lat_d
		lon_deg = lon_d
		lat_seconds = lat_s
		lon_seconds = lon_s
		lat_minutes = lat_m
		lon_minutes = lon_m
		lat_direction = lat_deg < 0 ? Direction.S : Direction.N
		lon_direction = lon_deg < 0 ? Direction.W : Direction.E

		let lon_deg_range = -90...90
		let lat_deg_range = -180...180
		let minSec_range = 0...59

		if !lat_deg_range.contains(lat_deg) || !lon_deg_range.contains(lon_deg) {
			throw MyExceptions.wrongDeg
		}
		if !minSec_range.contains(lon_minutes) || !minSec_range.contains(lat_minutes) {
			throw MyExceptions.wrongMin
		}
		if !minSec_range.contains(lat_seconds) || !minSec_range.contains(lon_seconds) {
			throw MyExceptions.wrongSec
		}
	}

	func geoStyle() -> String {
		return "\(abs(lat_deg))°\(lat_minutes)\'\(lat_seconds)\"\(lat_direction), \(abs(lon_deg))°\(lon_minutes)\'\(lon_seconds)\"\(lon_direction)"
	}

	func degStyle() -> String {
		return "\(abs(lat_deg + lat_minutes/60 + lat_seconds/3600))°\(lat_direction), \(abs(lon_deg + lon_minutes/60 + lon_seconds/3600))°\(lon_direction) "
	}

	func middlePoint(_ other: CoordinateVO) -> CoordinateVO? {
		if lat_direction == other.lat_direction && lon_direction == other.lon_direction {
			return try! CoordinateVO(
				(lat_deg + other.lat_deg)/2,
				(lon_deg + other.lon_deg)/2,
				(lat_minutes + other.lat_minutes)/2,
				(lon_minutes + other.lon_minutes)/2,
				(lat_seconds + other.lat_seconds)/2,
				(lon_seconds + other.lon_seconds)/2
			)
		} else {
			return nil
		}
	}

	static func middlePoint(_ first: CoordinateVO, _ second: CoordinateVO) -> CoordinateVO? {
		if first.lat_direction == second.lat_direction && first.lon_direction == second.lon_direction {
			return try! CoordinateVO(
				(first.lat_deg + second.lat_deg)/2,
				(first.lon_deg + second.lon_deg)/2,
				(first.lat_minutes + second.lat_minutes)/2,
				(first.lon_minutes + second.lon_minutes)/2,
				(first.lat_seconds + second.lat_seconds)/2,
				(first.lon_seconds + second.lon_seconds)/2
			)
		} else {
			return nil
		}
	}
}

var coord1 = CoordinateVO()
var coord2 = try! CoordinateVO(-6, -6, 6, 6, 6, 6)

print(coord2.geoStyle())
print(coord2.degStyle())

var coordmid = coord2.middlePoint(coord1)
print(coordmid!.degStyle()+"\n"+coordmid!.geoStyle())

var coordmid2 = CoordinateVO.middlePoint(coord2, coord1)
print(coordmid2!.degStyle()+"\n"+coordmid2!.geoStyle())
