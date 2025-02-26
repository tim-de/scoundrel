package main
import "core:fmt"
import "core:os"
import "core:strconv"

import "cards"

main :: proc() {

    // TODO:
    // So the control flow is much fewer cursed
    // but the whole thing needs to be neater
    // Also could do with a gui
    
    game := setup_game()
    for !game_is_complete(&game) {
        if count_room(&game.room) == 1 {
            fill_room(&game.deck, &game.room)
            game.player.can_run = true
        }
        draw_room(game.room)
        fmt.printf("Life: %2d ", game.player.life)
        if weapon, wielding := game.player.weapon.?; wielding {
            fmt.printf(
                "| Weapon: %r.%r",
                cards.rune_of_value(weapon.type.value),
                cards.rune_of_suit(weapon.type.suit),
            )
            if monster, slain := weapon.last_monster.?; slain {
                fmt.printf(
                    "/%r.%r",
                    cards.rune_of_value(monster.value),
                    cards.rune_of_suit(monster.suit),
                )
            }
        } else {
            fmt.print("[No weapon]")
        }
        fmt.println("")
        input := false
        choice := 0
        move: Maybe(Move) = nil
        for actual_move, ok := move.?;
        !ok || !move_is_valid(&game, actual_move);
        actual_move, ok = move.? {
            move = get_move(game)
        }
        make_move(&game, move.?)
    }
    switch game.state {
    case .Win:
        fmt.println("You Win!")
    case .Lose:
        fmt.println("You Lose")
    case .Ongoing:
        fmt.println("How did you get here?")
    }
}

get_move :: proc(game: Game) -> Maybe(Move) {
    choicebuf := [8]byte{}
    in_len: int
    err: os.Error
    for in_len == 0 || err != nil {
        fmt.print("-> ")
        in_len, err = os.read(os.stdin, choicebuf[:])
        os.flush(os.stdin)
    }
    if rune(choicebuf[0]) == 'r' || rune(choicebuf[0]) == 'R' {
        if !game.player.can_run {
            fmt.println("You cannot run, you have to fight!")
            return nil
        } else {
            return .Run
        }
    }
    if 0x31 <= choicebuf[0] && choicebuf[0] <= 0x34 {
        return Move(choicebuf[0] - 0x31)
    } else {
        return nil
    }
}
