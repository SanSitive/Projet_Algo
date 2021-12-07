struct Piece : PieceProtocol {
    var tall:Bool
	var dark:Bool
	var full:Bool
	var square:Bool

    //Initialise la pièce avec les caractéristiques fournies
    init(tall:Bool, dark:Bool, full:Bool, square:Bool) {
        self.tall = tall
        self.dark = dark
        self.full = full
        self.square = square
    }
}