💾  ← &fras "input.txt"
🗒️ ← ⊜□∘¬⊸⦷"\n\n"💾

ParseLine ← (
  ⍜⊜∘≡⋅"" ⊸⦷ "Button A: X+"
  ⍜⊜∘≡⋅" " ⊸⦷ ", Y+"
  ⍜⊜∘≡⋅" " ⊸⦷ "\nButton B: X+"
  ⍜⊜∘≡⋅" " ⊸⦷ "\nPrize: X="
  ⍜⊜∘≡⋅" " ⊸⦷ ", Y="
  ⊜□∘¬⊸⦷@ 
  ⋕
)

SolveEq ← (
  °⊟₆ # Xa Ya Xb Yb Xt Yt

  ⊃(- ⊃(×⋅⊙∘|× ⊙⋅⋅∘)    #  Xb Ya - Xa Yb 
  | - ⊃(×⋅⋅⊙⋅⋅∘|×⋅⋅⋅⊙∘) #  Xb Yt - Yb Xt 
  | - ⊃(×⋅⊙⋅⋅∘|×⊙⋅⋅⋅⋅∘) #  Ya Xt - Xa Yt
  )

  ⊃(÷ ⊙⊙  # A presses
  | ÷ ⊙⋅⊙ # B presses
  )

  ⊃(×=⌊.. ⊙|×=⌊.. ⋅⊙)
  # ⊃(× ≥0 . ⊙|× ≥0 . ⋅⊙)
  # ⊃(× <100 . ⊙|× <100 . ⋅⊙)
)

≡◇ParseLine 🗒️
≡SolveEq
/+ +×3 # tokens required 3 for B, 1 for A
