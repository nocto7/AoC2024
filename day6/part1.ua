# Experimental!

💾  ← &fras "example.txt"
🗒️ ← ⊜∘¬⊸⦷@\n💾

Locate      ← °¤ ⊚ ⌕ @^
X           ← ⟜⍜⊡◌ ⊙⊙@X
Move        ← ⍜⊡ ◌ +⊃(⋅⋅⊙|⊙⊙@^) X
Check       ← =@# ⊡ +⊃(⋅⋅⊙|⊙⊙)
Turn        ← ⊃(⋅⋅⊙|⊙⋅⋅) ↻ 1 × [¯1 1] ⊃(⋅⋅⊙|⊙⊙)
CheckBounds ← >0 /++⊃(<0|>9)
CountXs     ← /+/+⌕ @X
Present     ← /+/+⌕ @^
Next        ← +⊃(⋅⋅⊙|⊙)

[¯1 0] # Initial heading
🗒️     # Input

⍢(⨬(⨬(:⤙Move|Turn) ◡Check|◌X) ? CheckBounds ◡Next Locate .
| Present .)
CountXs .
