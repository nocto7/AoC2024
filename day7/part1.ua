# Experimental!

💾  ← &fras "input.txt"
🗒️ ← ⊜□∘¬⊸⦷@\n💾
🗒️

ParseRow ← □ ⋕ ⊜□∘¬⊸⦷@ ▽ ¬ ⦷@: . °□

# Combos ? SetofNumbers
FindCombos ← ◴ ⧅≠ ⧻ .

# SumAndProduct RestOfSet ? SetofNumbers
ProcessFirstCombo ← (
  ⊃(⊙⋅⊙|⋅∘) °⊂ : °⊂ # get first two elements, put on top of the stack
  ⊃(+|×)            # get sum and product of them
  ⊟
)

# SumAndProduct RestOfSet ? SetOfNumbers
ProcessNextCombo ← (
  ⊃(⊙⋅⊙|⋅∘) °⊂ : # get next element of the set, put on top of stack with sum/product set next
  ⊃(+|×)         # get sum and product of these with the earlier ones
  ⊂              # join into one set
  ◴
)

NumberLeft ← (
  ⊃(⊙⋅⊙|⋅∘) ⧻ . ⊃(⋅∘|⊙⋅⊙) ? # return number of elements left in set
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
≡ParseRow
# /+≡ProcessRow
/+≡ProcessRow
