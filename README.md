[![Build Status](https://travis-ci.org/lena-pl/durak.svg)](https://travis-ci.org/lena-pl/durak)
[![Dependency Status](https://gemnasium.com/lena-pl/durak.svg)](https://gemnasium.com/lena-pl/durak)
[![Coverage Status](https://coveralls.io/repos/lena-pl/durak/badge.svg?branch=master&service=github)](https://coveralls.io/github/lena-pl/durak?branch=master)

# Durak (Fool)
A Ruby on Rails version of the Russian card game 'Durak'. The aim of the game is to be the first player to get rid of your cards.

Setup
---
The game is played with a deck of 36 cards (deck does not contain cards 2-5 or Jokers). At the start of each game, the deck is shuffled and 6 cards are dealt to each player. A random card is pulled out of the deck, turned face up and displayed at a 90 degree angle to the rest of the deck (as the last card to be drawn). This card represents the trump suit.

Ranking
---
The cards are ranked from lowest to highest 6-10, Jack, Queen, King, Ace.
Trump suit cards have the same ranking within the suit, but rank higher than all other ranks of other suits. Eg. A 6 of the trump suit beats an Ace of a non-trump suit.

Gameplay
---
Each turn involves an 'attacker' and a 'defender'. At the start of the game, the first attacker is the player with the lowest rank trump suit card in their hand. If no player has a trump suit card, the first attacker is assigned at random. All subsequent turns alternate, unless a player picked up from the table, in which case the attacker gets another turn.

When attacking, a player can place down any card they like. They can place down multiple cards if they are all of the same rank (eg a 10 of hearts and a 10 of spades). The defending player has to beat the cards one at a time, with card of higher rank or trump suit cars. A trump suit card of any rank beats all ranks of other suits. Trump suit cards can only be beaten by higher ranking trump suit cards. Once the cards on the table are beaten, the attacker can place down more cards, as long as they are all of a rank that already appears on the table (eg if a 6 was beaten with a 10, an attacker can place down another 6 or 10). The attacker can not place more cards on the table than the defender has in their hand.

The turn is over when either an attacker has no more cards to attack with (or no more cards they wish to attack with), or the defending player cannot beat the cards on the table. If the latter is the case, the defending player must pick up all the cards currently on the table. However, if all cards were beaten, all the cards are discarded and are no longer part of the game. This pile may not be examined by players for the rest of the game.

At the end of the turn, each player replenishes their hand from the deck until they are holding 6 cards once again. If the player picked up from the table during the previous turn, they may not need to replenish their hand. The attacker always has the opportunity to pick up first.

Winning/Losing
---
The game is finished when only one player has cards left in their hand and no more cards are in the deck. The player who got rid of their cards first is the winner. The player only wins once the last turn of the game is completed.

If the same players decide to play another game, the winner from the previous game gets to attack first regardless of what cards they are holding.
