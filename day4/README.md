# day 4

[Day 4 - Advent of Code 2024](https://adventofcode.com/2024/day/4)

# Part 1

I realise I'm failing to include any Christmas flavour in these write ups. The flavour doesn't feel very strong yet this year, you're simply wandering about looking for someone and each room you poke your head into finds a problem for you to solve. Today's at least involves the word 'XMAS'.

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

It's a word search and you need to find all the occurrences of `XMAS` in it. Just like a standard word search the words can be placed up, down, left, right, or any way on the diagonals.

## finding XMAS
This definitely calls for `⌕` [find](https://www.uiua.org/docs/find). This finds the occurrences of one array in another. I love the magnifying glass glyph for this function.

```
🎄 ← /+⌕ "XMAS"
```
Find just marks the beginning of each of the terms we're searching for so the 🎄function finds each instance of the word "XMAS" in a string, then it's just `/+` *reduce add* to find how many instances were found.

A grid can be searched in eight directions, up/down/left/right and four different diagonals. These are four directions, down, left, and two orthogonal diagonals and their reverses. So if I search those four directions for `XMAS` backwards at the same time as I search forwards I've only got four sets of strings to search through.

I can use `⊃` *fork* to perform both these searches on the same value, and then add the two results together:
```
+⊃(/+⌕ "XMAS")(/+⌕ "SAMX")
```

But this can be simplified since `XMAS` and `SAMX` are the reverse of each other so I only need to give the string I'm looking for once, and tell one of the forks to `⇌` *[reverse](https://www.uiua.org/docs/reverse)* the first argument it was given.

```
🎄 ← +⊃(/+⌕)(/+⌕⇌)"XMAS"
```

Now all I need is the collection of strings to search through representing the left, right, and two diagonals of the grid.

## grid wrangling
Before playing with the confusing grid of repeated letters lets wrangle with an easier to understand grid of numbers for a moment.

Let's experiment a bit with a 5 by 5 grid which will be big enough to check things are working correctly but small enough to display. `↯ 5_5 ⇡ 25` *reshape* 5_5 *range* 25. This gives me an array of the numbers 0 to 24, and then puts them into a 5 by 5 square:
```
╭─                
╷  0  1  2  3  4  
   5  6  7  8  9  
  10 11 12 13 14  
  15 16 17 18 19  
  20 21 22 23 24  
				 ╯
```

I can *transpose* this to give me the array with the original columns going across the rows 
```
╭─              
╷ 0 5 10 15 20  
  1 6 11 16 21  
  2 7 12 17 22  
  3 8 13 18 23  
  4 9 14 19 24  
			   ╯
```

### finding the diagonal
Now I want to find a diagonal. I can see the result I want is `0`,`5 1`,`10 6 2`, ..., `24`. THere are 9 diagonals. These are the elements `[0 0]`, `[0 1] [1 0]`, `[0 2] [1 1] [2 0]`, ..., `[4 4]`. Each set has indices that add up to the same number from 0 to 8. 

Investigating how to get these out I find that I can use `⊡` *[pick](https://www.uiua.org/docs/pick)* to select items from the array, eg
```
⊡ [0_2 1_1 2_0] ↯ 5_5 ⇡ 25
```
selects `[2 6 10]`, the values I want for the 2nd (in a 0 based sense) diagonal; the ones where the indices add up to 2.

So the problem is now how to create the set of indices that add up to 0 to 8, so that I can *pick* each set of those from the grid.

I discovered on the docs page for *pick* that `°⊡` *unpick* can be used to enumerate the indices of the elements of an array. That makes sense, rather than picking an element of the array by its index, `°` *un* does it backwards so you get each element of the array to give you its index. So using 3 instead of 5 for brevity `°⊡ ↯ 3_3 ⇡ 9` we get this:
```
╭─     
╷ 0 0  
╷ 0 1  
  0 2  
	   
  1 0  
  1 1  
  1 2  
	   
  2 0  
  2 1  
  2 2  
	  ╯
```

Now I want to find the elements of that array that add up to 2. Which sounds like what you do with *mask*. But I need to add the indices together on each row before I can do that.

Uiua works row-wise, here I want to add columns together, so transpose and add them? My attempts at doing that don't work easily so let's think a bit.

The `△` *shape* of `°⊡ ↯ 5_5 ⇡ 25` is `[5 5 2]`, the *shape* of `↯ 5_5 ⇡ 25` was just `[5 5]`. We've introduced an extra dimension. Each element of the original `[5 5]` array now contain 2 elements. "5 big cells with 5 rows of 2 elements"  [cf Arrays](https://www.uiua.org/tutorial/arrays#output). It's the elements I want to add together. `∵` [each](https://www.uiua.org/docs/each) applies a function to each element of an array. The docs warn that you probably want a pervasive function or a table though. This is all not what I need at all.

But having thunk and messed with some other examples I realised my initial "transpose and add them" was right I just couldn't get the expression right. With `≡/+ ⍉ °⊡ ↯ 5_5 ⇡ 25` I get
```
╭─           
╷ 0 1 2 3 4  
  1 2 3 4 5  
  2 3 4 5 6  
  3 4 5 6 7  
  4 5 6 7 8  
			╯
```
which is the grid with the diagonals picked out for me. Now I can use `⌕` *find* to find the values on each diagonal (it worked out better than *mask* as it just gives me 1s on the diagonal and 0s elsewhere) eg `⌕ 2` gives
```
╭─           
╷ 0 0 1 0 0  
  0 1 0 0 0  
  1 0 0 0 0  
  0 0 0 0 0  
  0 0 0 0 0  
			╯
```

and a multiplication of this by the original array gives me one just containing the diagonal values.
```
╭─            
╷  0 0 2 0 0  
   0 6 0 0 0  
  10 0 0 0 0  
   0 0 0 0 0  
   0 0 0 0 0  
			 ╯
```

to get just the non zero values. I can use `♭` *flat* (also known as *[deshape](https://www.uiua.org/docs/deshape)* but it's a musical flat sign!) to flatten this to one dimension and the diagonal will stay in order. 
```
[0 0 2 0 0 0 6 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
```
now I just need to get rid of all those pesky zeroes, which is simple once you realise that `≠` [not equals](https://www.uiua.org/docs/not%20equals) is a function in it's own right (rather than doing `!0` or `not 0` as I was trying at first). Together with `▽` *[keep](https://www.uiua.org/docs/ke)* you just have `▽ ≠ 0` to give you `[2 6 10]`, the diagonal we've been searching for.[^1]

So altogether we find the 2th diagonal using 
```
Diag ← ▽ ≠ 0 . ♭ × ⌕ 2 ≡/+ ⍉ °⊡
```

We want to find all the diagonals though so we want to remove the hard coded 2 from the function and pass it in as an argument instead. If I call the function in the way `Diag n array` then the first thing I want to do in the function is flip to two arguments so the array gets used up first. This is the kind of thing that completely throws me in uiua. What uiua calls [Planet Notation](https://www.uiua.org/tutorial/advancedstack#planet-notation)  is one of those things that seems sensible when you read it but slips away from you as you try to use it! I finally figure out that *fork* is my friend here and eventually I figure this out:

```
Diagn ← ▽ ≠ 0 . ♭ × ⌕ ⊃(∘|≡/+ ⍉ °⊡ ⋅⊙)
```

There are two values on the stack at the start of the `Diagn` function, I want the first one left as it is so it can get fed to the find function afterwards; I want the second part of the fork to ignore the first argument and work on the second.

Right. Finally I feel like I'm getting there! I want to run this function to find all the diagonals of the array.

So pervasiveness will sort that out right? It doesn't seem to
```
+ 3 6
+ [3 4 5] 6

Diagn ← ▽ ≠ 0 . ♭ × ⌕ ⊃(∘|≡/+ ⍉ °⊡ ⋅⊙)

Diagn 3 ↯5_5 ⇡25
Diagn [3 4 5] ↯5_5 ⇡25
```

This is today's point where I give in and ask for help on the discord.

The answer I get back is use `rows F dip fix`. 

That still took me some thought to get it to work! I think I understand what's going on but could do with adding * dip fix* to a list of things to explore a bit more when I have time.

```
⬚0≡Diagn ⊙¤⇡9 °△5_5
```

This however spits out the diagonal values I'm after. Using *range 9* because number of diagonals in a matrix size n is `2n-1`.
```
╭─                
╷  0  0  0  0  0  
   1  5  0  0  0  
   2  6 10  0  0  
   3  7 11 15  0  
   4  8 12 16 20  
   9 13 17 21  0  
  14 18 22  0  0  
  19 23  0  0  0  
  24  0  0  0  0  
				 ╯
```

Now I want to get the 10x10 version of this to use with the test data. But I can ignore the first and last three diagonals as they can't have any four letter words in them by dint of having three or less characters in them.

Oh, and of course I need the second set of diagonals as well, the ones that include `[3 9] [2 8 14]` etc. I can get these just by *reversing* the original matrix.
## input wrangling

Uiua's `&fras` file read function gives me the input as one long string:
```
"MMMSXXMASM\nMSAMXMSMSA\nAMXSXMAAMM\nMSAMASMSMX\nXMASAMXAMM\nXXAMMXXAMA\nSMSMSASXSS\nSAXAMASAAA\nMAMMMXMMMM\nMXMXAXMASX"
```
I can use the 🎄 function to find that the word `XMAS` appears five times in the correct order in this string, three going left to right across the rows of the wordsearch, and two going backwards.

First we split the input by the newline characters, I keep coming across variations on this pattern so let's try this one today: *partition identity not by mask newline*
```
⊜∘¬⊸⦷@\n
```

this gives me an array with shape `[10 10]` straight away, calling `/+🎄` on that gives me the 5 occurrences of `XMAS` going left/right that I'm expecting.  I can transpose it to find another 3 occurences in the up/down rows.

Then the diagonals. Grrr. It's obvious that something's still not right. The shape of the array is `[19 100]` which means rather than having between 1 and 10 characters on each diagonal I'm putting whole rows in somehow to get up to 100 characters.

OK, time to test with a small alphabetical grid. I make up a 5 by 5 grid with the alphabet and work through creating the Diagonal function again. It turns out that multiplying a character by 0 or 1 doesn't work as I expected; both `* @a 0` and `* @a 1` give `@a` as the answer. I knew that `× @a ¯1` gave `@A` but it turns out I extrapolated that knowledge too far.

So the puzzle I have at the moment is how to combine these two arrays:
```
╭─           
╷ 0 0 1 0 0  
  0 1 0 0 0  
  1 0 0 0 0  
  0 0 0 0 0  
  0 0 0 0 0  
			╯
╭─         
╷ "ABCDE"  
  "FGHIJ"  
  "KLMNO"  
  "PQRST"  
  "UVWXY"  
		  ╯
```

to pull the KGC characters out of the alphabetical array. I'm going to flatten it so I could do that sooner, but that doesn't really help. After some messing about with character arithmetic I come up with this way to filter the array which seems nonsense (it changes the selected characters to lower case then removes the upper case characters, then puts them all back to upper case) but it works for now.

```
AlphaDiag ← × ¯1 ▽≥@a . ♭ × × ¯1 ⌕ ⊃(∘|≡/+ ⍉ °⊡ ⋅⊙)
```

and using that and a space to fill the empty, um, space, I get the diagonals as:

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
		  ╯
```

So, back to the test data. Let's test the diagonals. I find 5 `XMAS` on the first diagonal, and another 5 on the second set. Which means I've found the 18 `XMAS` to be found in the test grid.

I now need to change the code to figure out the size of the wordsearch itself.

### Final stretch of part one

I've now got the answer for the test data by running this and adding the results together so I'm pretty certain my algorithm is ok. Time to tidy up a bit.
```
/+🎄🗒️     # left/right
/+🎄 ⍉ 🗒️ # up/down
/+🎄⬚@ ≡AlphaDiag ⊙¤⇡19 🗒️   # first diagonals
/+🎄⬚@ ≡AlphaDiag ⊙¤⇡19 ⍉ 🗒️ # second diagonals
```

I can use some *fork*s to get the horizontal/vertical and diagonal lines and `⊂` *join* them together before running the 🎄wordsearch  function. (I like the way the *fork* and *join* glyphs mirror to make `⊂⊃`.)
```
/+🎄⊂⊃(∘|⍉) 🗒️
/+🎄⊂⊃(⬚@ ≡AlphaDiag ⊙¤⇡19|⬚@ ≡AlphaDiag ⊙¤⇡19 ⍉)🗒️
+
```

And then I can put those two lines together with another *fork*
```
/+🎄⊂⊃(⊂⊃(∘|⍉)|⊂⊃(⬚@ ≡AlphaDiag ⊙¤⇡19|⬚@ ≡AlphaDiag ⊙¤⇡19 ⍉))🗒️
```

At this point I finally start to feel like I'm writing tacit code rather than spewing nonsense.

A few things to sort out now:
- remove the hard coded 19, essential to running with real data.
- remove the repetition of `⬚@ ≡AlphaDiag ⊙¤⇡19` ?
- remove the repetition that both forks act on the array and its transpose

Dealing with the second point first, I create a function:
```
𒑳         ← ⬚@ ≡AlphaDiag ⊙¤⇡19
```
which takes the code down to 
```
```/+🎄⊂⊃(⊂⊃(∘|⍉)|⊂⊃(𒑳|𒑳⍉))🗒️
```

I can't see a way to only use the function once though, which means I can't deal with my third point either. But that'll do for now.

I can remove the hardcoded 19 by changing the function to first duplicate the array and then calculate `2n+1` from its *length*
```
𒑳         ← ⬚@ ≡AlphaDiag ⊙¤⇡ -1×2⧻ .
```

Finally I replace the name of my AlphaDiag function with an emoji. I pick the flag of the Bahamas 🇧🇸 because it's the first flag I find in alphabetical order that has the kind of pennant shape on it that this function makes of the data.

## Solution
Annoyingly I get the wrong answer the first time I try to solve with the real input. I get 2513, and therefore no gold star. It tells me my answer is too low so I'm missing some `XMAS`s. Hmmm.

I'm leaving this for now as I can see from other people's solutions that there are probably a lot simpler ways to solve it! Plus I think that coming back to this in a few days and reading it over will be good for testing my ability to read back uiua code. I've learnt a lot from trying to solve the problem this way even if I haven't helped the poor elf out.

I came back to look at this on the 7th and found the solution. Everything I did here was almost correct apart from this [one weird thing](redux.md). 
 
[^1]: I spotted a problem with this later as there's a zero in the array I'm playing with that gets removed as well so the first diagonal is missing an element but it won't be a problem with the real input data which is all characters so I ignore it.

