package main
import "core:fmt"
import "cards"

main :: proc() {
    deck := cards.setup_deck()
    defer delete(deck)

    cards.shuffle_deck(&deck)

    for card in deck {
        fmt.println(card)
    }
}
