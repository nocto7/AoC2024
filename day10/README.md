# day 10

After yesterday's one dimensional puzzle that I struggled to articulate in code today we have a two dimensional puzzle looking for reindeer hiking trails, otherwise known as orthogonal sequences of the digits 0 to 9 in a grid like this:

```
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
```

## algorithm

Fortunately I think this algorithm is easier to handle conceptually. I want to find all the zeroes in the grid. Then find each `1` orthogonal to them; Then find each `2` orthogonal to those, etc, until I find how many `9`s are orthogonal to the `8`s.

It only takes a second to find the `0`s in the grid.
```
💾  ← &fras "example.txt"
🗒️ ← ⊜∘¬⊸⦷@\n💾
⊚ ⌕ @0 🗒️
```

which gives me a list of zero-containing coordinates:
```
╭─     
╷ 0 2  
  0 4  
  2 4  
  4 6  
  5 2  
  5 5  
  6 0  
  6 6  
  7 1  
	  ╯
```

Now I want to look in all four directions from each of these looking for any `1`s that the reindeer can climb up to next. That means I want to look at the grid locations which are `[0_1 0_¯1 1_0 ¯1_0]` added to each element of this array.

Working with just the first `0`, or trailhead, at `[0 2]`, this is  this gives me

```
╭─      
╷  0 3  
   0 1  
   1 2  
  ¯1 2  
	   ╯
```

And then I can use these coordinates to pick out the values at those locations:
`⊢ ⊡ + ⊙¤ [0_1 0_¯1 1_0 ¯1_0]` gives `1914`. Oops, I've forgotten that negative indices wrap around in uiua. I did filtering for out of bounds grid coordinates on day 8 so let's reuse the code from there (I wasn't happy that this was particularly great code but I know it works)
```
FilterOoB ← (
  ⍚▽ ≥0 .
  :, ⊃(⊙|⋅⊙) ⧻ ,
  ⍚▽ <
  ≡◇⧻ .
  ▽ = 2
)
```
Reusing the function I discover that it's returning me a *box*ed set of coordinates. I'm going to have to *box* things later because they'll be different lengths but I'd rather it wasn't boxed at this point where it's always going to be pairs of coordinates. So we *rows unbox* before we return the list of in bounds coordinates. Now we can *pick* the values at those coordinates which as `191`. 

Now we just want to keep the coordinates that are `1`s. This is `⊏ ⊚ ⌕ @1 ◡⊡` using the filtered coordinates.

```
╭─     
╷ 0 3  
  1 2  
	  ╯
```

These are the coordinates of the two `1`s next to the first `0` in the grid.

Now it feels like it should just be repeat this through to `9`, and then for each `0` trailhead I've found.

At this point it occurs to be that I'm using the grid as characters when it's all digits. Yesterday I figured out how to parse a string of digits into an array of numbers with *rows parse*, today it's the same but in two dimensions, so `≡≡⋕`.

I notice `⊃(⊙|⋅⊙)` in the `FilterOoB` function, changing the stack order from AB to AB... redundant! removed!

So, with digits rather than characters, my complete code to find the `1`s next to the first `0` is:

```
. ≡≡⋕ 🗒️
⊚ ⌕ 0
+ ⊙¤ [0_1 0_¯1 1_0 ¯1_0] ⊢
FilterOoB
⊏ ⊚ ⌕ 1 ◡⊡
```

Pull the bit where I find the adjacent coordinates and filter them into it's own function:
```
FindAdjacent ← FilterOoB + ⊙¤ [0_1 0_¯1 1_0 ¯1_0]

⊚ ⌕ 0 . ≡≡⋕ 🗒️
⊏ ⊚ ⌕ 1 ◡⊡ FindAdjacent ⊢
⊏ ⊚ ⌕ 2 ◡⊡ FindAdjacent ⊢
```

Obviously I want the near identical lines with just `1` and `2` changed to be another function

After just `1 ◡⊡ FindAdjacent ⊢` my stack contains
- `1` (top), the digit i'm searching for
- `[1 9 1]` the values at the neighbouring coordinates
- the neighbouring coordinates
- the grid (bottom)

Juggling the stack I come up with
```
FindAdjacent ← FilterOoB + ⊙¤ [0_1 0_¯1 1_0 ¯1_0]
FindNext     ← ⊏ ⊚ ⌕ ⊃(⋅⋅⋅⊙|⊙⊙⊙) ◡⊡ ⊃(⋅⊙⊙|⊙)

⊚ ⌕ 0 . ≡≡⋕ 🗒️

FindNext 1 FindAdjacent ⊢
FindNext 2 FindAdjacent ⊢
```

Now I can use *inventory* to get the adjacent 1s to every 0:
```
⍚FindNext 1 ⍚FindAdjacent⊙¤
```

```
╭─                                                                         
		  ╓─                                                               
  ╓─      ╟ 0 5   ╓─      ╓─      ╓─      ╓─      ╓─      ╓─      ╓─       
  ╟ 0 3     0 3   ╟ 1 4   ╟ 5 6   ╟ 5 3   ╟ 5 6   ╟ 6 1   ╟ 6 7   ╟ 7 0    
	1 2     1 4         ╜       ╜       ╜       ╜   7 0     5 6     6 1    
		╜       ╜                                       ╜       ╜       ╜  
																		  ╯
```

The list of coordinates is good; but I've done something wonky and my grid at the bottom of the stack is no longer correct. 

Hmmm.

I feel like I basically have the whole solution here, just need to repeat it nine times. But *box*es and *inventory*s are causing me immense problems!

I'm looking at other people's solutions by now and seeing lots of clever ways of dealing with the cardinal directions and rotating the grid to get the adjacent values but these aren't really my problem.

`fn A .` can be written `fn by A` so my Filter function is gradually looking better, though I've put the `Grid` in it itself for now.

```
Filter ← (
  °□
  ⍚▽ ⊸≥ 0
  ⍚▽ ⊸< ⧻ Grid
  ≡◇⧻ .
  ▽ = 2
  ≡°□
)
```


### refactoring

After some refactoring I have this
```
💾  ← &fras "example.txt"
🗒️ ← ⊜∘¬⊸⦷@\n💾

Grid    ← ≡≡⋕ 🗒️
Dirs    ← [0_1 0_¯1 1_0 ¯1_0]
Locate  ← ⊚ ⌕ ⊙Grid
FindAdj ← + ⊙¤ Dirs
GridNum ← ⊡ ⊙Grid

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

⍚FindAdj ? Locate 0
⍚GridFilter
⍚ValFilter 1
```

which gives me the coordinates of every one connected directly to a zero as before.
```
╭─                                                                         
		  ╓─                                                               
  ╓─      ╟ 0 5   ╓─      ╓─      ╓─      ╓─      ╓─      ╓─      ╓─       
  ╟ 0 3     0 3   ╟ 1 4   ╟ 5 6   ╟ 5 3   ╟ 5 6   ╟ 6 1   ╟ 6 7   ╟ 7 0    
	1 2     1 4         ╜       ╜       ╜       ╜   7 0     5 6     6 1    
		╜       ╜                                       ╜       ╜       ╜  
																		  ╯
```
For ease of stack manipulation I've taken the main grid out of the stack and read it in every time, I've got one function that filters on whether the coordinates are inside the grid, and another that filters on whether they have a given value.

Boxes are what are causing me trouble. When I first find the zero locations with `Locate 0` I have a single array, each row with the x y coordinates of a `0` in the grid. Now I have an array of boxes where each row has an array of x y coordinates of the `1`s in the grid.

If I *box* and *fix* my original set of `0` locations then they are in the same format as the `1`s will be. When I find the adjacent locations I want 9 sets of 4 coordinates.

However, what I want is the location of each `0` in it's own box in the array, then it'll actually be in the same format as the `1`s will be with each box in the row representing a start from a different `0`.

So `≡□ ≡¤ Locate 0` gives me
```
╭─                                                                         
  ╓─      ╓─      ╓─      ╓─      ╓─      ╓─      ╓─      ╓─      ╓─       
  ╟ 0 2   ╟ 0 4   ╟ 2 4   ╟ 4 6   ╟ 5 2   ╟ 5 5   ╟ 6 0   ╟ 6 6   ╟ 7 1    
		╜       ╜       ╜       ╜       ╜       ╜       ╜       ╜       ╜  
																		  ╯
```

My `FindAdj` function `FindAdj     ← + ⊙¤ Dirs` just wants a single grid coordinate.

I eventually twig that the second time I look for the next steps I have several rows in each of these boxes and need to find the adjacent points to each one, using *join rows* to find the adjacent poins to each row and then put them back into one array afterwards. I also want to deduplicate them as I only care about how many trailheads I can reach from each zero, not how many separate routes to them there are.

```
💾  ← &fras "example.txt"
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

≡□ ≡¤ Locate 0

⍚FindAdjD
⍚GridFilter
⍚ValFilter 1

# CountTrails
```

So that gets me all the 1s and I think it's in a state to loop through to get up to 9 now.

I need the index each time so rather than a *repeat* I think I want something pervasive here.

`+1 ⇡ 9` gives me the `[1 2 3 4 5 6 7 8 9]` I need.

I can rearrange this
```
⍚FindAdjD
⍚GridFilter
⍚ValFilter 1
```

to 
```
⍚ValFilter ⊃(⊙|⍚GridFilter ⍚FindAdjD ⋅⊙) 1
```

Which I can put in a function
```
FindNext ← ⍚ValFilter ⊃(⊙|⍚GridFilter ⍚FindAdjD ⋅⊙)
```

So my main code is just
```
≡□ ≡¤ Locate 0
FindNext 1
FindNext 2
FindNext 3
```

etc.

Just to check I get the next bit right, the result after 3 steps is:
```
╭─                                                                         
		  ╓─                                              ╓─               
  ╓─      ╟ 0 7   ╓─      ╓─      ╓─      ╓─      ╓─      ╟ 7 6   ╓─       
  ╟ 2 3     2 3   ╟ 2 3   ╟ 4 7   ╟ 6 2   ╟ 4 7   ╟ 5 0     4 7   ╟ 5 0    
		╜       ╜       ╜       ╜       ╜       ╜       ╜       ╜       ╜  
																		  ╯
```

*fold* is the modifier I want here. This gives me the same result as above.

```
∧FindNext [1 2 3] ≡□ ≡¤ Locate 0
```

```
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
```

### ⭐️ Solution

So after a lot of messing around with boxes I have the answer.

## Part Two

Oh! Now the reindeer want the number of distinct hiking trails! This is simple as I got it in Part One before I remembered to deduplicate the trails! I simply have to remove a single deduplicate character from my FindAdjD function to get the second answer.

### ⭐️⭐️ Solution

Quickest second star ever I think.