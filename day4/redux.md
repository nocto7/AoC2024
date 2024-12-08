# day 4 redux

Let's have another go at [this one](README.md) now uiua is feeling a bit less alien to me.

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

## Part Two

So can I bash out part two for another star without spending hours on it?

Now the elves want us to find all the bits of the grid that look like 
```
M.S
.A.
M.S
```
Yes, they want `MAS` in an X shape, not `XMAS` itself. 🤣

I think the `◫` *windows* function is what I need to do this. But uiua moves fast and it's now called `⧈` *[stencil](https://www.uiua.org/docs/stencil)* but in the version of uiua I updated a week ago it's still *windows* so, oh, it's *uiua update* time I guess (or actually *cargo install --git https://github.com/uiua-lang/uiua uiua* time but that's not so catchy)

Now on uiua v0.14.0-dev.7

Asking my shiny new *stencil* `⧈∘3_3` for 3x3 windows on the test input gives me some output that looks good but I can tell from the spacing that the shape is more complicated than I'm used to `[3 3 3 3]`. I think that's 3 characters in 3 lines on 3 rows in 3 columns? Maybe. My brain doesn't want to deal with 4 dimensional space so let's hope it doesn't need to.

In order to get a single window out of this I can do `⊢⊢` to get an example; I feel like that means I'll probably want *rows rows* in the near future but I'll save that thought for now.
```
╭─       
╷ "ABC"  
  "FHG"  
  "KLM"  
        ╯
```

I want to know if the diagonals of this are `MAS` in either direction. So let's switch back to the real test data.

```
╭─       
╷ "MMM"  
  "MSA"  
  "AMX"  
        ╯
```

I could use the word search code again but it's caused me enough problems, I'd rather write something new to deal with this simpler problem.

If the central character isn't an `A` then there's no way the square can have crossed `MAS`s in it. So let's filter for all the items we have with central `A`s.

`⊡ 1_1` *pick* the item at index `1_1`. That gives me `S` here, so I can reject this window. (I'm going to keep calling them windows even though the method that creates them has changed to *stencil*).

I make a function for this
```
IsCentralA ← =@A ⊡ 1_1
```

The example wordsearch grid is 10 by 10, so I should have 8 times 8 = 64 windows. Running `≡≡IsCentralA` on the windows gives me an 8 by 8 array that looks pretty good!

```
╭─                 
╷ 0 1 0 0 0 0 0 0  
  0 0 0 0 0 1 1 0  
  0 1 0 1 0 0 0 0  
  0 1 0 1 0 0 1 0  
  0 1 0 0 0 0 1 0  
  0 0 0 0 1 0 0 0  
  1 0 1 0 1 0 1 1  
  1 0 0 0 0 0 0 0  
                  ╯
```
I eyeball this against the example data and it looks pretty good! There's 17 windows there with a central `A` but the example tells us there are 9 that meet the crossed `MAS` criteria. We need to check the corners of these have opposed Ms and Ss.

First we just need to keep the items that have central As using the mask we've just created. Ah, my windows were a `[3 3 3 3]` shape, this is an `[8 8]` shape. What do I need to do to filter the windows?

Ah, if I use `⧈□3_3` I get my windows in boxes, now that's an `[8 8]` array straight away; and I can `♭` *flat* (aka *deshape*) it into a `[64]` one dimensional array. Since I don't care about the relationship of the locations to each other I can throw that info away and just deal with one dimension.

Now I can do `≡◇IsCentralA` on this array and get a mask of all the windows with a central A. (I feel like I shouldn't need the `≡◇` *rows content* bit? Like I have an extra layer of boxing maybe? But I can't work that out at the moment.)

Then I can use *keep* to apply the mask to the array of windows `▽ ≡◇IsCentralA .` and filter out all the windows without central As.

Now let's look at the other restrictions needed for the window to contain crossed MAS. 
- The corners need to be 2 Ss and 2Ms
- The Ms and the Ss need to be on opposing corners.

First let's get the characters from the corners. 
```
GetCorners              ← ⊡ [0_0 0_2 2_2 2_0]
```

`≡◇GetCorners` gives me a list of these:
```
╭─        
╷ "MSSM"  
  "MMSS"  
  "SSMM"  
  "MSSM"  
  "SMMS"  
  "SMMX"  
  "MSXM"  
  "MMMX"  
  "MSMM"  
  "XMSS"  
  "MXSM"  
  "SSMM"  
  "SSMM"  
  "SSMM"  
  "SSMM"  
  "XSMM"  
  "SXMM"  
         ╯
```

The correct ones are going to be "MMSS" or a rotation of it. I can't just sort them into order to check as "MSMS" would sort to "MMSS" but it isn't a match, it would be a grid where `SAS` crosses `MAM`.

So I want to rotate the array by 0 1 2 and 3, which is *range 4* and the *rows F dip fix* pattern comes in again to use this to create the four separate possible combinations of "MMSS". That's `≡↻ ⊙¤ ⇡4 "MMSS"`
```
╭─        
╷ "MMSS"  
  "MSSM"  
  "SSMM"  
  "SMMS"  
         ╯
```

I use *memberof* to check if the corners I have are in this set
```
CorrectCorners ← ∈ ≡↻ ⊙¤ ⇡4 "MMSS"
```

And then we're done, all but the *reduce add* on the mask we have to find out how many there are. I get 9 for the example.

### ⭐️⭐️ Solution

And now I have two gold stars for this puzzle as well. I'm delighted with how concise and elegant this solution feels:
```
💾              ← &fras "example.txt"
🗒️             ← ⊜∘¬⊸⦷@\n💾
IsCentralA     ← =@A ⊡ 1_1
GetCorners     ← ⊡ [0_0 0_2 2_2 2_0]
CorrectCorners ← ∈ ≡↻ ⊙¤ ⇡4 "MMSS"

♭ ⧈□3_3 🗒️
/+ CorrectCorners ≡◇GetCorners ▽ ≡◇IsCentralA .
```

I think it would be more elegant (and reusable) if the `GetCorners` code worked with the size of the window it's been given; and the `CorrectCorners` method using the length of the string it's been given. The second of these i can work out:

This makes `CorrectCorners` a character longer.
```
CorrectCorners ← ∈ ≡↻ ⊙¤ ⇡⧻ . "MMSS"
```

I still think needing to use *rows* probably means I've missed something though!