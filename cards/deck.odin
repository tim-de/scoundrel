package cards

import rand "core:math/rand"

Hand :: []Card
Deck :: struct{
    head, len: uint,
    data: [64]Maybe(Card)
}

draw :: proc(deck: ^Deck) -> Maybe(Card) {
    if deck.len == 0 {
        return nil
    }
    result := deck.data[deck.head]
    deck.head = (deck.head + 1) & 63
    deck.len -= 1
    return result
}

append :: proc(deck: ^Deck, card: Card) {
    tail := (deck.head + deck.len) & 63
    deck.data[tail] = card
    deck.len += 1
    assert(deck.len <=64, "Deck overfull!")
}

peek :: proc(deck: Deck, offset: uint) -> Maybe(Card) {
    if offset >= deck.len {
        return nil
    }
    ix := (deck.head + offset) & 63
    return deck.data[ix]
}

setup_deck :: proc() -> Deck {
    deck := Deck{}
    for suit in Suit {
        max := 14 if suit == .Clubs || suit == .Spades else 10
        for value in (2 ..= max) {
            append(&deck, Card{suit = suit, value = Value(value)})
        }
    }
    return deck
}

shuffle :: proc { shuffle_hand, shuffle_deck }

shuffle_hand :: proc(hand: Hand, repeats: uint = 64) {
    for reps in (0..<repeats) {
        for ix in (0..<len(hand)) {
            other_ix := rand.int_max(len(hand))
            hand[ix], hand[other_ix] = hand[other_ix], hand[ix]
        }
    }
}

shuffle_deck :: proc(deck: ^Deck, repeats: uint = 64) {
    for reps in (0 ..< repeats) {
        for offset in (0 ..< deck.len) {
            other_offset := uint(rand.int_max(int(deck.len)))
            ix := (deck.head + offset) & 63
            other_ix := (deck.head + other_offset) & 63
            deck.data[ix], deck.data[other_ix] = deck.data[other_ix], deck.data[ix]
        }
    }
}
