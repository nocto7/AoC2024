# day 12

[Day 12 - Advent of Code 2024](https://adventofcode.com/2024/day/12)
## Part One

Today we're looking at garden plots represented by different characters in a grid like

```
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
```

and trying to find the area and perimeter of each of them. E.g. The R area at the top left contains 12 characters and has a perimeter of 18.

Hmmm. So how to represent this and calculate the values? 

### counting fences
Well the fencing seems simple, each plot needs a fence on each side where the crop in the next orthogonal plot is different to it's own. So we look at the crops in those neighbouring plots.

```
Dirs ← [0_1 1_0 0_¯1 ¯1_0]
⬚@.⊡ Dirs
```

This pulls out the adjacent crops to the top left R, which are `RR..` as I've filled the blanks with dots having discovered that *fill* works with pick to avoid the problem of negative indices wrapping around. So I can see this plot needs two fences at the edges and no others.

So let's try and do that for every plot with `R` growing in it. I can find the indices of these plots with:

```
⊚ ⌕ @R 
```

this gives me 
```
╭─     
╷ 0 0  
  0 1  
  0 2  
  0 3  
  1 0  
  1 1  
  1 2  
  1 3  
  2 2  
  2 3  
  2 4  
  3 2  
	  ╯
```

To get the four neighbouring plots to `[3 2]` I can do
```
+ Dirs¤[3 2]
```

And I can find the neighbours of all the `R` plots with
```
Rs ← ⊚ ⌕ @R 🗒️
Neighbours ← + Dirs¤
≡Neighbours Rs
```

And now I can pick out what's on those neighbouring plots
```
⬚@. ⊡ ≡Neighbours Rs 🗒️
```

which gives me these 12 values
```
╭─        
╷ "RR.."  
  "RRR."  
  "RRR."  
  "IRR."  
  "RV.R"  
  "RVRR"  
  "RRRR"  
  "IRRR"  
  "RRVR"  
  "RCRR"  
  "CCRI"  
  "CVVR"  
		 ╯
```

simply checking this for inequality with `@R` and adding up the 1s I get gives me `18` the correct value for the amount of fencing required for the plot containing `R`s. So I can do that for every type of plot here. Except this small example garden has no repeated crops. It's clear that the real input data does have repeated crops. 

So first I need to separate the crops into discontiguous regions.

### measuring plots

From above I know the indices of every plot with a certain crop in it, and I know what it's neighbours are and what's in those plots. I need to group the crops into ones that don't have a fence between them. For each of the plots in turn I need to look at it's neighbours and see if they have this crop. If they do I can group them together.

Let's use a smaller example where the Rs on in two different areas:

```
RRSSII
RRSSII
VVRRRC
VVRCCC
```

The `R` coordinates here are
```
╭─     
╷ 0 0  
  0 1  
  1 0  
  1 1  
  2 2  
  2 3  
  2 4  
  3 2  
	  ╯
```

I want to look to see whether each plot neighbours another.

So first checking with the `[0 0]` coordinate, against the list of all the neighbours which is shaped `[8 4 2]` there's 8 rows, one for each plot, each of which has 4 neighbours, each of which has 2 coordinates.

I can see `[0 0]` is a neighbour of the 2nd and 3rd of the eight plots. Using *index of `[0 0]`* gives me `[4 2 3 4 4 4 4 4]` which shows that elements 1 and 2 (ie the second and third) have this plot as a neighbour; the `4`s are the 'not found' indicator for *indexof* since they are out of range.

I feel like this will be simpler in a moment if I get rid of the out of bounds elements. So use -1 as the element to fill with and then get a mask of the neighbouring elements.
```
≠ ¯1 ⬚¯1 ⊗ [0 0]
```

Now I want to check each of these neighbouring elements for their neighbours.

Maybe partition the set into the ones adjacent to the first element and those not. Definitely need to recurse until the set doesn't change. Then calculate the area and the perimeter, work out the price and remove that group from the grid.

Is recursion definitely needed here? I hate using recursion when things can just be calculated. Don't want to do all the permutations though. 

Does *partition* already handle this?!

> Takes a function and two arrays.

> The arrays must be the same [`⧻ length`](https://www.uiua.org/docs/length).

> The first array is called the "markers". It must be rank `1` and contain integers.

> Consecutive rows in the second array that line up with groups of the same key in the markers will be grouped together.

> Keys [`≤`](https://www.uiua.org/docs/less%20or%20equal)`0` will be omitted.

OMG! Does this actually work??! Doing this on my small test array 

```
+1 ↯ 4_6 ⊛ ♭
```

gives me:
```
╭─             
╷ 1 1 2 2 3 3  
  1 1 2 2 3 3  
  4 4 1 1 1 5  
  4 4 1 5 5 5  
			  ╯
```

the array classified by the type of crops, I added one on to avoid having any zeroes. We can entirely discard the letters using this.

Then I can partition `⊜□ .` this by itself to get
```
{[1 1 1 1] [2 2 2 2] [3 3 3 3] [4 4 4 4] [1 1 1 1] [5 5 5 5]} 
```
It knows the two sets of `1`s(equating to our original `R`)are separate!

Now I need to partition the sets of coordinates rather than the values themselves.

Rooting around in the discord for an easy way to get all the indices, I discover `°⊡` *unpick* does this easily. I keep missing tricks with *un*!

Yay, I have partitioned sets of indices for each separate plot!

Now to calculate the price of each plot.

### pricing

My problem now is that I've lost the relationship between the crop in the field and its set of plots, so I don't know what to compare it to. This is my perimeter function with the 1 for the first element hard coded into it

```
Perimeter = /+♭ ≠ 1 ⬚0 ⊡ ≡Neighbours °□
```

I'm passing in the list of indices in this set of plots, and the original array in integer form, so I can calculate what the crop is just by picking out any of those coordinates in the original array.

```
Perimeter  ← /+♭ ≠ ⊃(⊡⊢|⬚0 ⊡ ≡Neighbours°□)
```

then 

```
≡◇Perimeter⊙¤
```
gives the perimeter of each set of plots in the order they were partitioned in.

The area is easy to calculate, it's just the number of coordinates in the set of plots. In fact we might as well just *fork* and calculate it at the same time.

```
Price      ← × ⊃(⧻|/+♭ ≠ ⊃(⊡⊢|⬚0 ⊡ ≡Neighbours°□))
```

Back to the original example and after once again being bemused at my ability to hard code in the size of the input, I get the correct answer for the example, `1930`. That's actually really easy to take out with a fork giving me the shape of the original array to reshape it into when I'm done.

```
💾           ← &fras "example.txt"
🗒️          ← ⊜∘¬⊸⦷@\n💾
Dirs        ← [0_1 1_0 0_¯1 ¯1_0]
Neighbours  ← + Dirs¤
Price       ← × ⊃(⧻|/+♭ ≠ ⊃(⊡⊢|⬚0 ⊡ ≡Neighbours°□))
CropNumbers ← +1 ↯ ⊃(△|⊛ ♭)
SplitPlots  ← ⊜□∘ : °⊡

/+ ≡◇Price⊙¤ SplitPlots . CropNumbers 🗒️
```

### ⭐️ Solution

This gets me the price for the real garden plots straight away.

Something I realise as soon as I've done it is that my fork to reshape after deshaping is a use for *under*, I want to classify the data while it's flattened out but put it back straight away.

```
# CropNumbers ← +1 ↯ ⊃(△|⊛ ♭)
CropNumbers ← +1 ⍜♭ ⊛
```

I also found an unneccessary *unbox* at the beginning of the Price function, the rows are being processed using *content* that unboxes them.