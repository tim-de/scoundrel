package main
import "core:fmt"
import "cards"

main :: proc() {
    deck := cards.setup_deck()
    room := Room{}

    cards.shuffle(&deck)

    fill_room(&deck, &room)
    fmt.println(room)
    for ix in (0..<deck.len) {
        fmt.println(cards.peek(deck, ix).?)
    }
}
