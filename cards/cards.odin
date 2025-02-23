package cards

Suit :: enum {
    Diamonds,
    Clubs,
    Hearts,
    Spades,
}

Card :: struct {
    suit: Suit,
    value: int,
}

rune_of_suit :: proc(suit: Suit) -> rune {
    switch suit {
    case .Diamonds:
        return 'D'
    case .Clubs:
        return 'C'
    case .Hearts:
        return 'H'
    case .Spades:
        return 'S'
    }
    panic("Invalid card suit")
}

rune_of_value :: proc(value: int) -> rune {
    if 1 < value && value < 10 {
        return rune(value + 0x30)
    }
    switch value {
    case 10:
        return 'X'
    case 11:
        return 'J'
    case 12:
        return 'Q'
    case 13:
        return 'K'
    case 14:
        return 'A'
    case:
        panic("Invalid card value")
    }
}
