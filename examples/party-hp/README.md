# Party HP

A window listing your party with an HP bar under each monster.

It reads the party with `game.state("party")` and rebuilds the window whenever `party_changed`
fires. Rebuilding everything is simpler than updating each row, and a party is only six monsters.
