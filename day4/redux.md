# day 4 redux

Let's have another go at this one now uiua is feeling a bit less alien to me.

We're trying to find all the `XMAS` in this word search grid.
```
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
```

This is the code from my previous attempt that I'm happy with.
```
💾  ← &fras "example.txt"
🗒️ ← ⊜∘¬⊸⦷@\n💾
🎄  ← /++⊃(/+⌕)(/+⌕⇌) "XMAS"

🎄≡⊂⊃(∘|⍉)🗒️
```
It reads in the file and splits it by newlines into the 🗒️.
The 🎄 function forks to find occurrences of "XMAS", or the reverse of "XMAS" in each line and adds the counts together.
Then I run this on the joined up rows of the grid and it's transpose which give me all the horizontal and vertical XMASs that can be found. 8 of them in the example. And 850 in the real input.

### diagonals again

I pull up my less confusing test matrix that I was using to calculate the diagonals and run my diagonal code again. I notice that one of the diagonals is different to the one I have written on paper on my desk.  I can see a CHK diagonal that's CGK on paper. It's because I've got the order of the alphabet wrong when typing it out!

```
ABCDE
FHGIJ
KLMNO
PQRST
UVWYZ
```

But that's a dumb typo not an algorithmic problem. However it draws my eye to the fact that further down the page the same combo appears... the result of doing `⊂⊃(𒑳|𒑳⍉)` on this grid is
```
╭─         
╷ "A    "  
  "BF   "  
  "CGK  "  
  "DHLP "  
  "EIMQU"  
  "JNRV "  
  "OSW  "  
  "TX   "  
  "Y    "  
  "A    "  
  "FB   "  
  "KGC  "  
  "PLHD "  
  "UQMIE"  
  "VRNJ "  
  "WSO  "  
  "XT   "  
  "Y    "  
		  ╯
```

I've not noticed that these are the same set of diagonals again! Just backwards!

So rather than trying another approach to find the diagonals it looks like my original approach is salvagable. 👩🏻‍🔧

Transposing the grid *didn't* give me a grid with a different set of diagonals (looking in the same direction) I just assumed it did (and honestly I should know better than to assume! One of the reasons I take ludicrous amounts of notes is so that I document all the assumptions.) A quick play with pen and paper tells me that I actually want to reverse the order of the rows. If I put the bottom row on the top and the top on the bottom then I get what I want.

`𒑳⇌ 🗒️` then gives me
```
╭─         
╷ "U    "  
  "VP   "  
  "WQK  "  
  "YRLF "  
  "ZSMHA"  
  "TNGB "  
  "OIC  "  
  "JD   "  
  "E    "  
		  ╯
```

which means that `⊂⊃(𒑳|𒑳⇌) 🗒️` gives me a set of diagonals and this time they're all different:

```
╭─         
╷ "A    "  
  "BF   "  
  "CHK  "  
  "DGLP "  
  "EIMQU"  
  "JNRV "  
  "OSW  "  
  "TY   "  
  "Z    "  
  "U    "  
  "VP   "  
  "WQK  "  
  "YRLF "  
  "ZSMHA"  
  "TNGB "  
  "OIC  "  
  "JD   "  
  "E    "  
		  ╯
```

### ⭐️ Solution
Finally with a one character change (on Dec 7th) I have a solution to the day 4 problem.