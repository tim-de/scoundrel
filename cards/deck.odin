package cards

import rand "core:math/rand"

Deck :: [dynamic]Card

setup_deck :: proc() -> Deck {
    deck := make(Deck)
    for suit in Suit {
        max := 14 if suit == .Clubs || suit == .Spades else 10
        for value in (2 ..= max) {
            append(&deck, Card{suit = suit, value = Value(value)})
        }
    }
    return deck
}

shuffle_deck :: proc(deck: ^Deck, repeats: uint = 64) {
    for reps in (0..<repeats) {
        for ix in (0..<len(deck)) {
            other_ix := rand.int_max(len(deck))
            deck[ix], deck[other_ix] = deck[other_ix], deck[ix]
        }
    }
}
