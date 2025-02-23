package main

import "cards"

Weapon :: struct {
    type: cards.Card,
    last_monster: Maybe(cards.Card),
}

Player :: struct {
    life: int,
    weapon: Maybe(Weapon),
    ran_last: bool,
}

new_player :: proc() -> Player {
    return Player{
        life = 20,
        weapon = nil,
        ran_last = false,
    }
}

equip_weapon :: proc(player: ^Player, weapon: cards.Card) {
    player.weapon = Weapon{
        type = weapon,
        last_monster = nil,
    }
}

fight_monster :: proc(player: ^Player, monster: cards.Card) {
    damage := monster.value
    if weapon, equipped := player.weapon.?; equipped {
        if last_monster, used := weapon.last_monster.?; used {
            if last_monster.value > monster.value {
                damage -= weapon.type.value
                player.weapon = Weapon{
                    type = weapon.type,
                    last_monster = monster,
                }
            }
        } else {
            damage -= weapon.type.value
            player.weapon = Weapon{
                type = weapon.type,
                last_monster = monster,
            }
        }
    }
    damage = max(damage, 0)
    player.life = max(player.life - damage, 0)
}

use_potion :: proc(player: ^Player, potion: cards.Card) {
    player.life += potion.value
    player.life = min(player.life, 20)
}

play_card :: proc(player: ^Player, room: ^Room, choice: int) -> bool {
    assert(0 <= choice && choice < 4, "Invalid card selection")
    if card, ok := room[choice].?; ok {
        switch card.suit {
        case .Diamonds:
            equip_weapon(player, card)
        case .Hearts:
            use_potion(player, card)
        case .Clubs, .Spades:
            fight_monster(player, card)
        }
        room[choice] = nil
        return true
    } else {
        return false
    }
}

run_from_room :: proc(player: ^Player, room: ^Room, deck: ^cards.Deck) -> bool {
    if count_room(room) < 4 || player.ran_last {
        return false
    }
    cards.shuffle(room[:])
    for ix in (0 ..< 4) {
        cards.append(deck, room[ix].?)
        room[ix] = nil
    }
    fill_room(deck, room)
    player.ran_last = true
    return true
}
