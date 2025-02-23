package main
import "core:fmt"
import "core:os"
import "core:strconv"

import "cards"

main :: proc() {

    // TODO:
    // Clean up this mess.
    // The gameplay loop wants to be in its own
    // function somewhere, and the control flow
    // is positively cursed.
    
    choicebuf := [256]byte{}
    game := setup_game()
    for !test_completion(&game) {
        if count_room(&game.room) == 1 {
            fill_room(&game.deck, &game.room)
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
        for !input {
            fmt.print("-> ")
            in_len, err := os.read(os.stdin, choicebuf[:])
            if err != nil {
                return
            }
            if choicebuf[0] == 'r' || choicebuf[0] == 'R' {
                if game.player.ran_last {
                    fmt.println("You cannot run, you have to fight!")
                    continue
                }
                run_from_room(&game.player, &game.room, &game.deck)
                break
            }
            choice, input = strconv.parse_int(string(choicebuf[:in_len-1]))
            if choice < 1 || 4 < choice {
                input = false
            }
            if !input {
                fmt.printfln("Invalid selection '%s'", string(choicebuf[:in_len-1]))
            } else {
                play_card(&game.player, &game.room, choice-1)
            }
        }
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
