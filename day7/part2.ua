💾  ← &fras "input.txt"
🗒️ ← ⊜□∘¬⊸⦷@\n💾

ParseRow ← □ ⋕ ⊜□∘¬⊸⦷@ ▽ ¬ ⦷@: . °□

ConCat ← (⋕ /◇⊂ °⋕ ⊟ :)

ProcessFirstCombo ← (
  ⊃(⊙⋅⊙|⋅∘) °⊂ : °⊂ # get first two elements, put on top of the stack
  ⊃(+|×|ConCat)     # get sum, product and concatenation of them
  ⊟₃
)

ProcessNextCombo ← (
  ⊃(⊙⋅⊙|⋅∘) °⊂ : # get next element of the set, put on top of stack with sum/product set next
  ⊃(+|×|≡ConCat) # get sum, product and concatenation of these with earlier ones
  ⊂ ⊂            # join 3 results into one set
  ◴
)

NumberLeft ← (
  ⊃(⊙⋅⊙|⋅∘) ⧻ . ⊃(⋅∘|⊙⋅⊙) # return number of elements left in set
)

CheckAnswer ← (
  ×⊃(>0/+∈ :|⋅⊙) ⊙⋅⊙ # find specified answer in the possible answer set
)

ProcessRow ← (
  °□
  :°⊂
  ProcessFirstCombo
  >0 NumberLeft
  ⨬(∘|⍢(ProcessNextCombo|>0 NumberLeft))
  CheckAnswer
)
≡ParseRow 🗒️
/+≡ProcessRow
