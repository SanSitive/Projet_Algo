import Foundation

struct Quarto : QuartoProtocol {

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
                        self.pieces[i] = (Piece(tall:t, dark:d, full:f, square:s))
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
        if(checkCoordinates(coord:coord) && checkPiece(piece:piece)) {
            self.plateau[coord.0][coord.1] = piece

            var i = 0
            var retire : Bool = false
            while i<self.pieces.count && !retire {
                if let p = self.pieces[i] {
                    if piecesEqual(p1:piece, p2:p) {
                        self.pieces[i] = nil
                        retire = true
                    }
                }
                i+=1
            }
        }
    }

    //S'assure de la conformité des coordonnées
	//Pré : _
	//Post : renvoie true si les coordonnées sont valides (0<=x,y<4 et (x,y) non occupé), false sinon
	func checkCoordinates(coord:Coordinate) -> Bool {
        return ((coord.0)>=0 && (coord.0)<5) && ((coord.1)>=0 && (coord.1)<5) && self.plateau[coord.0][coord.1] == nil
    }

	//S'assure de la conformité du choix de la pièce
	//Pré : _
	//Post : renvoie true si la pièce est disponible, false sinon
	func checkPiece(piece:Piece) -> Bool {
        var res = false
        var i = 0
        var dispo = self.getAvailablePieces()
        while i<dispo.count && !res {
            res = piecesEqual(p1:piece, p2:dispo[i])
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
        var res : (Coordinate,Coordinate)? = nil
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
        var res : (Coordinate,Coordinate)? = nil
        let ligne = coord.0
        var tabTall : [Bool] = [Bool](repeating:false, count:4)
        var tabDark : [Bool] = [Bool](repeating:false, count:4)
        var tabFull : [Bool] = [Bool](repeating:false, count:4)
        var tabSquare : [Bool] = [Bool](repeating:false, count:4)

        var c : Int = 0
        var caseVide = false
        while c<4 && !caseVide{
            if let p = self.plateau[ligne][c] {
                tabTall[c] = p.tall
                tabDark[c] = p.dark
                tabFull[c] = p.full
                tabSquare[c] = p.square
            }
            else {
                caseVide = true
            }
            c += 1
        }

        if !caseVide && existAlign(tabTall:tabTall, tabDark:tabDark, tabFull:tabFull, tabSquare:tabSquare){
            res = (Coordinate(ligne, 0), Coordinate(ligne, 3))
        }

        return res
    }

	//Vérifie l'alignement vertical. Renvoie aussi les coordonnées de l'alignement. Appelé dans checkAlignement
	//Pré : coordonnée valide et occupée
	//Post : nil s'il n'y a pas d'alignement. S'il existe un alignement, renvoie un tuple de coordonnée qui symbolise le début et la fin de l'alignement
	func verticalAlign(coord: Coordinate) -> (Coordinate, Coordinate)? {
        var res : (Coordinate,Coordinate)? = nil
        let colonne = coord.1
        var tabTall : [Bool] = [Bool](repeating:false, count:4)
        var tabDark : [Bool] = [Bool](repeating:false, count:4)
        var tabFull : [Bool] = [Bool](repeating:false, count:4)
        var tabSquare : [Bool] = [Bool](repeating:false, count:4)

        var l : Int = 0
        var caseVide = false
        while l<4 && !caseVide{
            if let p = self.plateau[l][colonne] {
                tabTall[l] = p.tall
                tabDark[l] = p.dark
                tabFull[l] = p.full
                tabSquare[l] = p.square
            }
            else {
                caseVide = true
            }
            l += 1
        }

        if !caseVide && existAlign(tabTall:tabTall, tabDark:tabDark, tabFull:tabFull, tabSquare:tabSquare){
            res = (Coordinate(0, colonne), Coordinate(3, colonne))
        }

        return res
    }

	//Vérifie l'alignement diagonal. Renvoie aussi les coordonnées de l'alignement. Appelé dans checkAlignement
	//Pré : coordonnée valide et occupée
	//Post : nil s'il n'y a pas d'alignement. S'il existe un alignement, renvoie un tuple de coordonnée qui symbolise le début et la fin de l'alignement
	func diagonalAlign(coord: Coordinate) -> (Coordinate, Coordinate)? {
        var res : (Coordinate,Coordinate)? = nil

        //Si la pièce n'est pas dans la diagonale, il ne peut pas d'avoir d'alignement en diagonale, si oui, on vérifie
        if(!(((coord.0 == 0 || coord.0 == 3) && (coord.1 > 0 || coord.1 < 3)) || ((coord.1 == 0 || coord.1 == 3) && (coord.0 > 0 || coord.0 < 3)))) {
            var tabTall : [Bool] = [Bool](repeating:false, count:4)
            var tabDark : [Bool] = [Bool](repeating:false, count:4)
            var tabFull : [Bool] = [Bool](repeating:false, count:4)
            var tabSquare : [Bool] = [Bool](repeating:false, count:4)

            var i : Int = 0
            var caseVide = false

            //Si sur la diagonale nord-ouest / sud-est
            if(coord.0 == coord.1) {
                while i<4 && !caseVide{
                    if let p = self.plateau[i][i] {
                        tabTall[i] = p.tall
                        tabDark[i] = p.dark
                        tabFull[i] = p.full
                        tabSquare[i] = p.square
                    }
                    else {
                        caseVide = true
                    }
                    i += 1
                }
                if !caseVide && existAlign(tabTall:tabTall, tabDark:tabDark, tabFull:tabFull, tabSquare:tabSquare){
                    res = (Coordinate(0, 0), Coordinate(3, 3))
                }
            }
            //Sinon sur la diagonale sud-ouest / nord-est
            else {
                while i<4 && !caseVide{
                    if let p = self.plateau[3-i][i] {
                        tabTall[i] = p.tall
                        tabDark[i] = p.dark
                        tabFull[i] = p.full
                        tabSquare[i] = p.square
                    }
                    else {
                        caseVide = true
                    }
                    i += 1
                }
                if !caseVide && existAlign(tabTall:tabTall, tabDark:tabDark, tabFull:tabFull, tabSquare:tabSquare){
                    res = (Coordinate(0, 3), Coordinate(3, 0))
                }
            }

        }
        return res
    }

    func existAlign(tabTall : [Bool], tabDark : [Bool], tabFull : [Bool], tabSquare : [Bool]) -> Bool {
        let boolTall = (tabTall[0] == tabTall[1]) && (tabTall[1] == tabTall[2]) && (tabTall[2] == tabTall[3])
        let boolDark = (tabDark[0] == tabDark[1]) && (tabDark[1] == tabDark[2]) && (tabDark[2] == tabDark[3])
        let boolFull = (tabFull[0] == tabFull[1]) && (tabFull[1] == tabFull[2]) && (tabFull[2] == tabFull[3])
        let boolSquare = (tabSquare[0] == tabSquare[1]) && (tabSquare[1] == tabSquare[2]) && (tabSquare[2] == tabTall[3])

        return boolTall || boolDark || boolFull || boolSquare
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
        for p in 0..<self.pieces.count {
            if let p = self.pieces[p] {
                res.append(p)
            }
        }
        return res
    }

	//Renvoie un itérateur sur le plateau
	//Pré : _
	//Post : _
	func makeIterator() -> QuartoIterator {
        return QuartoIterator(value:self.plateau)
    }

	//Renvoie une string qui représente une ligne du plateau de jeux
	//Pré : _
	//Post : _
	func printBoard(elt: [Piece?]) -> String {
        var txt : String = ""
        for i in 0..<4 {
            if let piece = elt[i] {
                if piece.tall { txt += "T" } //Tall
                else { txt += "P"} //Small (Petite)
                if piece.dark { txt += "D" } //Dark
                else { txt += "L" } //Light
                if piece.full { txt += "F" } //Full
                else { txt += "E" } //Empty
                if piece.square { txt += "S"} //Square
                else { txt += "R" } //Round

                txt += " | "
            }
            else {
                txt += "    | "
            }
        }
        return txt
    }
}

//Itère sur une ligne de quarto
struct QuartoIterator:IteratorProtocol, Sequence {
	
    let lignes : [[Piece?]]
    var current : Int

    //Renvoie une ligne du plateau de jeu
	//Pré : value : la représentation du plateau du quarto, c'est à dire un tableau à deux dimensions de Piece ou nil
	//Post : _
	init(value:[[Piece?]]) {
        self.current = 0
        self.lignes = value
    }

	//Renvoie une ligne du plateau de jeu
	//Pré : _
	//Post : _
	mutating func next() -> [Piece?]? {
        guard self.current + 1 == self.lignes.count else { return nil }
        self.current += 1
        return self.lignes[self.current - 1]
    }
}