💾  ← &fras "input.txt"
🗒️ ← ⊜∘¬⊸⦷@\n💾

Grid        ← ≡≡⋕ 🗒️
Dirs        ← [0_1 0_¯1 1_0 ¯1_0]
Locate      ← ⊚ ⌕ ⊙Grid
FindAdj     ← + ⊙¤ Dirs
GridNum     ← ⊡ ⊙Grid
CountTrails ← /+≡◇⧻

GridFilter ← (
  ⍚▽ ⊸≥ 0
  ⍚▽ ⊸< ⧻ Grid
  ≡◇⧻ .
  ▽ = 2 # only keep coords with x & y inside grid
  ≡◇∘
)

ValFilter ← (
  ⊃(⊙|⊸≡◇GridNum ⋅⊙)
  ▽ =
)

FindAdjD ← ◴/⊂ ≡FindAdj

FindNext ← ⍚ValFilter ⊃(⊙|⍚GridFilter ⍚FindAdjD ⋅⊙)

∧FindNext +1 ⇡ 9 ≡□ ≡¤ Locate 0
CountTrails
