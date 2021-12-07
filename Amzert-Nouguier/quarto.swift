struct Quarto : QuartoProtocol {
    //coordonnées en (y,x)
    typealias Coordinate = (Int,Int)
	typealias Iterator = QuartoIteratorProtocol

    var pieces : [Piece?]
    var plateau : [[Piece?]]

    //Initialise le plateau, toutes les positions sont vides et initialise toutes les pièces disponibles
	//Pré : _
	//Post : _
    init() {
        self.plateau = [[Piece?]](repeating:Array(repeating:nil, count:4), count:4)
        self.pieces = [Piece?](repeating:nil, count:16)
        var i = 0
        for tall in 0..<2 {
            for dark in 0..<2 {
                for full in 0..<2 {
                    for square in 0..<2 {
                        let t = (tall > 0)
                        let d = (dark > 0)
                        let f = (full > 0)
                        let s = (square > 0)
                        self.pieces[i] = (Piece(tall:t, dark:d, full:f, square:s)
                        i+=1
                    }
                }
            }
        }
    }

    //Place une pièce sur le plateau
	//Pré : coordonnée valide et non occupée et pièce disponible
	//Post : Supprime de la liste des pièces et de la liste de coordonnées la pièce et coordonnée choisies
	mutating func place(piece:Piece, coord: Coordinate) {

    }

    //S'assure de la conformité des coordonnées
	//Pré : _
	//Post : renvoie true si les coordonnées sont valides (0<=x,y<4 et (x,y) non occupé), false sinon
	func checkCoordinates(coord:Coordinate) -> Bool {
        return ((coord.0)>=0 && (coord.0)<5) && ((coord.1)>=0 && (coord.1)<5) && self.checkPiece(coord:coord)
    }

	//S'assure de la conformité du choix de la pièce
	//Pré : _
	//Post : renvoie true si la pièce est disponible, false sinon
	func checkPiece(piece:Piece) -> Bool {
        var res = false
        var i = 0
        while i<self.pieces.count && !res {
            if let p = self.pieces[i] {
                res = piecesEqual(p1:piece, p2:p)
            }
            i+=1
        }
        return res
    }

    // Vérifie que 2 instances de pièces ont les mêmes attributs
    func piecesEqual(p1:Piece, p2:Piece) -> Bool {
        return p1.tall == p2.tall && p1.dark == p2.dark && p1.full == p2.full && p1.square == p2.square
    }

	//Vérifie l'alignement de la pièce placée avec les autres. Il y a alignement lorsque 4 pièces adjacente partage une même caractéristiques. L'alignement peut être horizontal, vertical ou en diagonale. Une variante consiste à avoir un carré de pièces adjacentes. Renvoie aussi les coordonnées de l'alignement
	//Pré : coordonnée valide et occupée
	//Post : nil s'il n'y a pas d'alignement. S'il existe un alignement, renvoie un tuple de coordonnée qui symbolise le début et la fin de l'alignement
	func checkAlignement(coord: Coordinate) -> (Coordinate, Coordinate)? {
        var res = nil
        res = horizontalAlign(coord:coord)
        if res == nil {
            res = verticalAlign(coord:coord)
            if res == nil {
                res = diagonalAlign(coord:coord)
                /*if res == nil {
                    res = squareAlign(coord:coord)
                }*/
            }
        }
        return res
    }

	//Vérifie l'alignement horizontal. Renvoie aussi les coordonnées de l'alignement. Appelé dans checkAlignement
	//Pré : coordonnée valide et occupée
	//Post : nil s'il n'y a pas d'alignement. S'il existe un alignement, renvoie un tuple de coordonnée qui symbolise le début et la fin de l'alignement
	func horizontalAlign(coord: Coordinate) -> (Coordinate, Coordinate)? {
        
    }

	//Vérifie l'alignement vertical. Renvoie aussi les coordonnées de l'alignement. Appelé dans checkAlignement
	//Pré : coordonnée valide et occupée
	//Post : nil s'il n'y a pas d'alignement. S'il existe un alignement, renvoie un tuple de coordonnée qui symbolise le début et la fin de l'alignement
	func verticalAlign(coord: Coordinate) -> (Coordinate, Coordinate)? {
        
    }

	//Vérifie l'alignement diagonal. Renvoie aussi les coordonnées de l'alignement. Appelé dans checkAlignement
	//Pré : coordonnée valide et occupée
	//Post : nil s'il n'y a pas d'alignement. S'il existe un alignement, renvoie un tuple de coordonnée qui symbolise le début et la fin de l'alignement
	func diagonalAlign(coord: Coordinate) -> (Coordinate, Coordinate)? {
        
    }

	//OPTIONNEL
	//Vérifie l'alignement en carré. Renvoie aussi les coordonnées de l'alignement. Appelé dans checkAlignement
	//Pré : coordonnée valide et occupée
	//Post : nil s'il n'y a pas d'alignement. S'il existe un alignement, renvoie un tuple de coordonnée qui symbolise le coin supérieur gauche et le coin inférieur droit
	//func squareAlign(coord: Coordinate) -> (Coordinate, Coordinate)?

	//Renvoie la liste des positions disponibles
	//Pré : _
	//Post : renvoie un tableau vide si pas de positions disponibles
	func getAvailablePositions() -> [Coordinate] {
        var res : [Coordinate] = []
        for l in 0..<self.plateau.count {
            for c in 0..<self.plateau[l].count {
                if self.plateau[l][c] == nil {
                    res.append((l,c))
                }
            }
        }
        return res
    }

	//Renvoie la liste des pièces disponibles
	//Pré : _
	//Post : renvoie un tableau vide si pas de pièces disponibles
	func getAvailablePieces() -> [Piece] {
        var res : [Piece] = []
        for p in 0..<self.piece.count {
            if self.pieces[p] != nil {
                res.append(self.pieces[p])
            }
        }
        return res
    }

	//Renvoie un itérateur sur le plateau
	//Pré : _
	//Post : _
	func makeIterator() -> Iterator {
        return QuartoIterator()
    }

	//Renvoie une string qui représente une ligne du plateau de jeux
	//Pré : _
	//Post : _
	func printBoard(elt: [Piece?]) -> String {
        
    }
}

//Itère sur une ligne de quarto
struct QuartoIterator:IteratorProtocol, Sequence {
	
	init() {

    }

	//Renvoie une ligne du plateau de jeu
	//Pré : _
	//Post : _
	mutating func next() -> [Piece?] {

    }
}