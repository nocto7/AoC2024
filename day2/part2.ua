# Experimental!
💾             ← &fras "input.txt"
📋             ← ⊜(□⊜⋕⊸≠@ )⊸≠@\n
📏             ← ≡/- ◫2 °□
🤔             ← ≍ 1 /+◰±
😍             ← ≍ 0 /+ > 3 ⌵
SafeRow       ← ≍ 1 × ⊃😍🤔📏°□
DampedSafeRow ← >0/+≡SafeRow ⧅< -1⧻. °□
ReallySafeRow ← ∨ ⊃SafeRow DampedSafeRow

📩 ← /+≡ReallySafeRow 📋💾

📩

┌─╴test
  ⍤⤙≍ 1 🤔 [1 2 1]
  ⍤⤙≍ 1 🤔 [¯1 ¯4 ¯1]
  ⍤⤙≍ 0 🤔 [1 ¯4 ¯1]
  ⍤⤙≍ 1 😍 [1 ¯3 ¯1]
  ⍤⤙≍ 0 😍 [6 ¯3 ¯2]
  ⍤⤙≍ 1 😍 [3 3 1]
  ⍤⤙≍ 1 SafeRow [7 6 4 2 1]
  ⍤⤙≍ 0 SafeRow [1 2 7 8 9]
  ⍤⤙≍ 0 SafeRow [9 7 6 2 1]
  ⍤⤙≍ 0 SafeRow [1 3 2 4 5]
  ⍤⤙≍ 0 SafeRow [8 6 4 4 1]
  ⍤⤙≍ 1 SafeRow [1 3 6 7 9]
  # ⍤⤙≍ 1 DampedSafeRow [1 3 2 4 5]
  # ⍤⤙≍ 0 DampedSafeRow [9 7 6 2 1]
  # ⍤⤙≍ 1 ReallySafeRow [7 6 4 2 1]
  # ⍤⤙≍ 0 ReallySafeRow [1 2 7 8 9]
  # ⍤⤙≍ 0 ReallySafeRow [9 7 6 2 1]
  # ⍤⤙≍ 1 ReallySafeRow [1 3 2 4 5]
  # ⍤⤙≍ 1 ReallySafeRow [8 6 4 4 1]
  # ⍤⤙≍ 1 ReallySafeRow [1 3 6 7 9]
└─╴
