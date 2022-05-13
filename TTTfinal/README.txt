Implementation notes:

1. Incorporated the suggested features:
    - grid sizes up to 9x9
    - more than 2 players (for grid sizes over 4x4)
    - opponents can be human or computer (including multiple computer opponents)
    - player can customize all names and player marks
    - player can select who plays first or can request random selection
    - 5 rounds per game
    - displays running game score
    - computer strategies: easy (random), offense/defense, and minimax

2. In addition:
    - player can accept default settings (3x3 grid, offense/defense computer
      strategy, default computer name, default computer and player marks)
      rather than customizing
    - grids larger than 3x3 show the square numbers within the grid for ease
      of selection
    - user prompts are loaded from a .yml file
    - there is a 1-second sleep after each computer move, which feels more
      natural, particularly when playing against more than one computer
      opponent.

Refactoring notes (after code review):

1. First turn applies to first game only, and then it rotates. (added
@players.rotate! after each game).

2. Strategies: Superclass is gone, and those attributes and methods are in
module Strategic, which is included in the three Strategy classes. This
rearrangement allows for minimax to be implemented at large grid sizes
(offense-defense strategy will be used until 9 or fewer spaces remain; the
minimax algorithm is too inefficient to calculate more than that many moves
ahead).

3. Long methods have been split up.

4. Configuration#initialize had too much going on (initialize should be
restricted to mainly variable initialization), so added a #configure method to
perform the configuration.
