package cards

Suit :: enum {
    Diamonds,
    Clubs,
    Hearts,
    Spades,
}

Value :: distinct u8

Card :: struct {
    suit: Suit,
    value: Value,
}
