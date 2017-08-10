import Foundation


/// A tetrimino is a polyomino made of four cells.
protocol Polyomino {
    var cells: [Cell] { get set }
}
