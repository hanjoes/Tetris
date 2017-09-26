import Foundation

/// PolyominoCreator
struct PolyominoCreator<Artifact: Polyomino> {
    
    let allPossible: [Artifact]
    
    init() {
        self.allPossible = Artifact.allPossible as! [Artifact]
    }
    
    /// Creates a polyomino for the given `cellNum`.
    ///
    /// - Parameter cellNum: number of cells in the polyomino created
    /// - Returns: the created polyomino with specified `cellNum`
    func makePolyomino(withCellNum cellNum: Int) -> Artifact {
        let index = Int(arc4random()) % allPossible.count
        return allPossible[index]
    }
}
