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

Move :: enum {
    Run = -1,
    Card0,
    Card1,
    Card2,
    Card3,
}
// Todo:
// - Give it some recognition for when a new room
// is entered

MoveInputFunc :: proc() -> Maybe(Move)
GameDrawFunc :: proc(game: Game)

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

game_is_complete :: proc(game: ^Game) -> bool {
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

move_is_valid :: proc(game: ^Game, move: Move) -> bool {
    switch move {
    case .Run:
        return game.player.can_run
    case .Card0, .Card1, .Card2, .Card3:
        _, exists := game.room[int(move)].?
        return exists
    }
    panic("Invalid move")
}

make_move :: proc {
    player_make_move,
    game_make_move,
}

game_make_move :: proc(game: ^Game, move: Move) -> bool {
    return make_move(&game.player, &game.room, &game.deck, move)
}
