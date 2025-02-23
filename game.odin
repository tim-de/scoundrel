package main

import "core:fmt"
import "cards"

Game :: struct {
    player: Player,
    room: Room,
    deck: cards.Deck,
    state: EndState,
}

EndState :: enum {
    Ongoing,
    Win,
    Lose,
}

setup_game :: proc() -> Game {
    game := Game {
        player = new_player(),
        room = {},
        deck = cards.setup_deck(),
        state = .Ongoing,
    }
    cards.shuffle(&game.deck)
    fill_room(&game.deck, &game.room)
    return game
}

test_completion :: proc(game: ^Game) -> bool {
    if game.deck.len == 0 {
        game.state = .Win
        return true
    }
    if game.player.life == 0 {
        game.state = .Lose
        return true
    }
    game.state = .Ongoing
    return false
}
