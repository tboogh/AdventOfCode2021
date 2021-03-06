import Foundation

public class Day_5 {

    init(input: String) {
        let lines = input
            .split(separator: "\n")
            .drop { $0.isEmpty }
            .map { $0.components(separatedBy: " -> ") }
            .compactMap { Line(input: $0) }
        graph = Day5Grid(lines: lines)
    }

    private let graph: Day5Grid

    func partOne() -> Int {
        return graph.computeAnswer(includedDiagonal: false)
    }

    func partTwo() -> Int {
        return graph.computeAnswer(includedDiagonal: true)
    }
}

class Day5Grid {

    init(lines: [Line]) {

        let xValues = lines.flatMap { [$0.start.x, $0.end.x] }
        let minX = xValues.reduce(0, { min($0, $1) })
        let maxX = xValues.reduce(0, { max($0, $1) })
        let yValues = lines.flatMap { [$0.start.y, $0.end.y] }
        let minY = yValues.reduce(0, { min($0, $1) })
        let maxY = yValues.reduce(0, { max($0, $1) })

        let graph = Array(repeating: Array(repeating: 0, count: maxX - minX + 1), count: maxY - minY + 1)

        self.graph = graph
        self.lines = lines
        self.minX = minX
        self.minY = minY
        self.maxX = maxX
        self.maxY = maxY
    }

    private let minX: Int
    private let maxX: Int
    private let minY: Int
    private let maxY: Int
    private var graph: [[Int]]
    private let lines: [Line]

    public func computeAnswer(includedDiagonal: Bool) -> Int {
        for line in lines {
            if includedDiagonal {
                if !line.isHorizontal &&
                    !line.isVertical &&
                    !line.isDiagonal
                {
                    continue
                }
            } else {
                if !line.isHorizontal && !line.isVertical {
                    continue
                }
            }

            if line.isDiagonal {
                drawDiagonalLine(line: line)
            } else {
                drawVerticalOrHorizontalLine(line: line)
            }
        }
        return graph.flatMap { $0 }.filter { $0 > 1 }.count
    }

    func drawDiagonalLine(line: Line) {
        let sortedPoints = [line.start, line.end].sorted { $0.x < $1.x }
        let minP = sortedPoints[0]
        let maxP = sortedPoints[1]
        
        let dx = maxP.x - minP.x
        let dy = maxP.y - minP.y

        for x in minP.x...maxP.x {
            let y = minP.y + dy * (x - minP.x) / dx
            graph[y][x] += 1
        }
    }

    func drawVerticalOrHorizontalLine(line: Line){
        let minX = min(line.start.x, line.end.x)
        let maxX = max(line.start.x, line.end.x)
        let minY = min(line.start.y, line.end.y)
        let maxY = max(line.start.y, line.end.y)
        for x in minX...maxX {
            for y in minY...maxY {
                graph[y][x] += 1
            }
        }
    }

    func debugPrint(graph: [[Int]]) {
        for rowindex in 0..<graph.count {
            let row = graph[rowindex]
            print("\(row.reduce("") { $0 + ($1 == 0 ? "." : "\($1)") })")
        }
    }
}

struct Point {

    init(input: String) {
        let data = input.components(separatedBy: ",")
        x = Int(data[0]) ?? 0
        y = Int(data[1]) ?? 0
    }

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    let x: Int
    let y: Int
}

struct Line {

    init(input: [String]) {
        start = Point(input: input[0])
        end = Point(input: input[1])
    }

    let start: Point
    let end: Point

    var isHorizontal: Bool {
        start.y == end.y
    }

    var isVertical: Bool {
        start.x == end.x
    }

    var isDiagonal: Bool {
        let xDiff = abs(end.x - start.x)
        let yDiff = abs(end.y - start.y)
        return xDiff == yDiff
    }
}
