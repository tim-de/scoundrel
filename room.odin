package main

import "core:fmt"
import "core:slice"

import "cards"

Room :: [4]Maybe(cards.Card)

count_room :: proc(room: ^Room) -> int {
    return slice.count_proc(
        room[:],
        (proc(card: Maybe(cards.Card)) -> bool {
            _, ok := card.?
            return ok
        })
    )
}

fill_room :: proc(deck: ^cards.Deck, room: ^Room) {
    for ix in (0 ..< 4) {
        if _, exists := room[ix].?; !exists {
            room[ix] = cards.draw(deck)
        }
    }
}

draw_room :: proc(room: Room) {
    for ix in (0 ..< 4) {
        if card, exists := room[ix].?; exists {
            fmt.printf(
                " |%r %r| ",
                cards.rune_of_value(card.value),
                cards.rune_of_suit(card.suit),
            )
        } else {
            fmt.print(" |\\ /| ")
        }
    }
    fmt.println("")
    for ix in (0 ..< 4) {
        if _, exists := room[ix].?; exists {
            fmt.printf(" |   | ")
        } else {
            fmt.printf(" | X | ")
        }
    }
    fmt.println("")
    for ix in (0 ..< 4) {
        if card, exists := room[ix].?; exists {
            fmt.printf(
                " |%r %r| ",
                cards.rune_of_suit(card.suit),
                cards.rune_of_value(card.value),
            )
        } else {
            fmt.print(" |/ \\| ")
        }
    }
    fmt.println("")
}
