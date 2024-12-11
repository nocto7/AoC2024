💾 ← &fras "example.txt"

Disk ← ⍉ ⊟ /(⊂⊂) ¯1 ⇡ ⌈ ÷ 2 ⧻ . ≡⋕

# disk pos sum ? id size disk pos sum
ProcessFile ← (
  ⊃(⋅⊙⋅⊙|⊙⋅⊙|+⊃(⋅⋅⋅⊙|⋅⊙)) # size, pos, id, disk, updated pos
  /+×+⇡
  ⊃(⋅⊙⊙|+⊃(∘|⋅⋅⋅⊙))
)

# disk ? disk
TrimEndSpace ← (
  °⊟ ⍜⇌ °⊂
  <0 .
  ⨬(⊂ : ⊟|◌◌)
)

# for negative spaceleft put space between file and beginning of next file on disk
# disk ? spaceleft id size disk
AddFileWithSpace ← (
  ⊃(⊟ ¯1|⊟ ⊃(⋅⊙|⋅⋅⊙))
  ⊂ ⊃(⋅⊙|⊂⊃(⊙|⋅⋅⊙))
)

# for positive spaceleft put as much file as we can at start and rest back on the end
# disk ? spaceleft id size disk
SplitFile ← (
  ⊃(⊟ ⊃(⋅⊙|+⊙⋅⊙)|⊟ ⊃(⋅⊙|¯⊙))
  ⊂(⊂⊃(⊙|⋅⋅⊙|⋅⊙))
)

# disk  ? id size disk
RearrangeSpace ← (
  : ◌      # space, don't need the `1 
  °⊟ ⍜⇌ °⊂ # get last file info

  ⊃(⊙⊙|-⊃(⋅⊙⋅⊙)|⋅⋅⊙)
  ⊃(⋅⋅⊙|⊙⊙)

  <0 . # does file fits with space to spare?
  ⨬(AddFileWithSpace|SplitFile)
)

Disk 💾 0 0 # disk position checksum

⍢(°⊟ °⊂
  <0 .
  ⨬(ProcessFile|RearrangeSpace)
  TrimEndSpace
| > 1⧻
)

°⊂
°⊟
ProcessFile
