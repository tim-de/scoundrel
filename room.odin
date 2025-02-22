package main

import "cards"

Room :: [4]Maybe(cards.Card)

fill_room :: proc(deck: ^cards.Deck, room: ^Room) {
    for ix in (0 ..< 4) {
        if _, exists := room[ix].?; !exists {
            room[ix] = cards.draw(deck)
        }
    }
}
