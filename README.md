# Haskell Minesweeper

Classic Minesweeper implemented in **Haskell** with 2D graphics using the **Gloss** library. It includes a start menu to choose difficulty level and board size, a mine counter, and an overlay when you win or lose.

## Requirements

- **GHC** (Glasgow Haskell Compiler) and **Cabal**  
  - **macOS (Homebrew):** `brew install ghc cabal-install`  
  - **Other / official installer:** [GHCup](https://www.haskell.org/ghcup/) (download and run the installer from the site)

- Project dependencies (Cabal installs them when building): **gloss**, **random**, **mtl**, **array**, **containers**.

---

## How to run

```bash
# Build
cabal build

# Run the game
cabal run TP-BUSCAMINAS
```

The window opens at 800×800 pixels (title: *Haskell Minesweeper*). An **Exit** button is always visible to close the game.

---

## Objective

The board is a grid of cells. Some cells hide **mines**; the rest are safe. Your goal is to **reveal every safe cell without clicking on a mine**. You use the numbers on revealed cells to deduce where mines are, and you can mark suspected mines with flags (right click).

## How the cells work

When you left-click a cell that is **not** a mine, it shows a **number from 0 to 8**. That number is the **count of mines in the 8 cells around it** (up, down, left, right, and the four diagonals). So:

- **0** — none of the 8 neighbouring cells has a mine; they are all safe to reveal (you can use this to clear large areas).
- **1** — exactly one of the 8 neighbours is a mine.
- **2** — two neighbours have mines, and so on up to **8** if the cell is surrounded by mines.

You use these hints to decide which cells to reveal next and where to put flags. Reveal all non-mine cells to win; click a mine and you lose.

---

## How to play

- **Left click** on a cell: reveals it. If it’s a mine, you lose; otherwise you see the number of adjacent mines (0–8). Reveal all non-mine cells to win.
- **Right click** on a cell: places or removes a flag (marking a possible mine). The mine counter above the board shows how many mines remain to flag.
- On the **start menu** choose level (Easy / Medium / Hard), size (Small / Medium / Big), then press **Play** to start.
- When you **lose or win**, a message appears with two buttons: **Back to Menu** (return to the menu) or **End Game** (quit the application). The **Exit** button is always available.

---

## Levels and sizes

### Level (difficulty)

Difficulty sets **what percentage of the board is mines** (approximate):

| Level    | Mine percentage |
|----------|------------------|
| **Easy**   | 10 % |
| **Medium** | 20 % |
| **Hard**   | 30 % |

Higher levels mean more mines and less room for error.

### Board size

Size defines **how many rows and columns** the grid has (always a square grid):

| Size     | Rows × columns | Total cells |
|----------|----------------|-------------|
| **Small**  | 9 × 9   | 81  |
| **Medium** | 11 × 11 | 121 |
| **Big**    | 13 × 13 | 169 |

The number of mines is computed from level and size (percentage of total cells), with a **minimum of 10 mines** per game. In `Config.hs`, each size gives `(maxRow, maxCol)` so the grid has `(maxRow+1) × (maxCol+1)` cells (Small 9×9, Med 11×11, Large 13×13).

### Example mine counts per game

|            | Small (9×9) | Medium (11×11) | Big (13×13) |
|------------|-------------|----------------|-------------|
| **Easy**   | 10          | 12             | 16          |
| **Medium** | 16          | 24             | 33          |
| **Hard**   | 24          | 36             | 50          |

*(Approximate values; the game uses the configured percentage with a minimum of 10.)*

---

## License

BSD-3-Clause. See `LICENSE`.
