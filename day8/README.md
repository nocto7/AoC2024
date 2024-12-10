# day 8
[Day 8 - Advent of Code 2024](https://adventofcode.com/2024/day/8#part2)

## Part One

Today's problem sees us trying to locate 'antinodes' created by antennae in a grid like 
```
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
```

Before worrying about what 'antinodes' are or how to find them let's do the easy bits.

### input
Getting the input is identical to previously:

```
💾  ← &fras "example.txt"
🗒️ ← ⊜∘¬⊸⦷@\n💾
```

### finding the nodes
First of all each different character has a different set of nodes so let's work out what the different characters we need to loop through are. Here, I *deshape* the grid, the *deduplicate* the elements, which quickly reduces this grid to `.0A`, then *keep* the elements that are *not equal* to a dot, or `@.` 

```
GetChars ← ▽ ≠@. . ◴ ♭
```

Now let's look at one of the characters and find where they all lie in the grid. There's less `A`s so let's start with those.

I discovered on day 6 that *where find* `⊚ ⌕` will pull out the indices of the matching elements in the grid. Sure enough I get
```
╭─     
╷ 5 6  
  8 8  
  9 9  
	  ╯
```

Nice when things are easy!

### finding an antinode

So what's an antinode? 

> an antinode occurs at any point that is perfectly in line with two antennas of the same frequency - but only when one of the antennas is twice as far away as the other.

"Frequency" here means the character representing an antenna in the grid.

So first we want to find the vector difference between each pair of antenna locations. Let's work with another grid from the example first.

```
..........
...#......
..........
....a.....
..........
.....a....
..........
......#...
..........
..........
```

If we find the locations of the `a`s  we get:
```
╭─     
╷ 3 4  
  5 5  
	  ╯
```

The convoluted wording of wanting one antenna to be twice as far away as the other from the antinode can be swizzled about, as is pretty obvious from looking at the `#` in the diagram, which represent the antinode locations, to be to find the vector that moves you from one node to the other, then add it from one and subtract it from the other.

So here we *uncouple* then *subtract* to find the vector difference between the antenna. Which is `[2 1]`

Keeping the two antenna locations *below* the difference on the stack means this is `◡-°⊟` and the stack looks like 
```
[5 5]
[3 4]
[2 1]
```

With three things on stack planet notation is the easy way to add the vector to the first and take it away from the other.
```
⊃(+⊙⋅⊙|-⊙⊙⋅)
```
This gives us both locations of the antinodes which we can couple together to get a single item to keep hold of:
```
╭─     
╷ 7 6  
  1 3  
	  ╯
```
We'll also need to check that the antinodes are still within the grid. But let's leave that for a minute.

I make this into a function 
```
FindAntinodes ← ⊟ ⊃(+⊙⋅⊙|-⊙⊙⋅) ◡-°⊟
```

and notice that I'm uncoupling at the beginning and coupling at the end, hold on, this is what `⍜` *[under](https://www.uiua.org/docs/under)* does! "Operate on a transformed array, then reverse the transformation".

```
FindAntinodes ← ⍜°⊟(⊃(+⊙⋅⊙|-⊙⊙⋅) ◡-)
```

### finding pairs of antennae
In the example featuring `A` above there were three antennae and each pair of them can produce two antinodes. So we need to find the coordinates of each pair.  The coordinates of the three were:
```
╭─     
╷ 5 6  
  8 8  
  9 9  
	  ╯
```

*tuples* is the tool for finding combinations, `⧅< 2` finds the unique combinations of 2 rows from an array, giving us
```
╭─     
╷ 5 6  
╷ 8 8  
	   
  5 6  
  9 9  
	   
  8 8  
  9 9  
	  ╯
```

and then using *rows* with our `FindAntinodes` function finds the antinodes of each.

```
╭─       
╷ 11 10  
╷  2  4  
		 
  13 12  
   1  3  
		 
  10 10  
   7  7  
		╯
```

That's six antinodes, but we can see that some of these will be off the grid. So we want to filter them for any where either index is less than zero or greater than the size of the grid.

Let's make sense of what's on the stack before trying to do the filtering.

This is the code at this point:
```
GetChars          ← ▽ ≠@. . ◴ ♭
FindAntinodes     ← ⍜°⊟(⊃(+⊙⋅⊙|-⊙⊙⋅) ◡-)
FindAntennaePairs ← ⧅< 2 ⊚ ⌕

GetChars . 🗒️

FindAntennaePairs @a 🗒️
≡FindAntinodes
```

But I'm not looking for the different antennae yet, just the `A`s. We need to work through the result of `GetChars` to find each different set.

These sets are all different lengths. This means we need to *box* the results to get them into an array together. We also need to use *dip fix* yet again to use the second argument (the grid) for each row of the first argument (the set of characters). For the original grid this results in:
```
╭─                 
  ╓─               
  ╟ 1 8            
  ╟ 2 5            
				   
	1 8            
	3 7   ╓─       
		  ╟ 5 6    
	1 8   ╟ 8 8    
	4 4            
			5 6    
	2 5     9 9    
	3 7            
			8 8    
	2 5     9 9    
	4 4         ╜  
				   
	3 7            
	4 4            
		╜          
				  ╯
```

The first element represents the pairs of `0` antennae, the second element represents the pairs of `A` antennae.

On each element of this we can do *rows content* and find the antinodes, but we need to *unbox* them before doing that and re*box* them after which is *inventory*
```
GetChars . 🗒️
⍚FindAntennaePairs⊙¤
⍚≡◇FindAntinodes
```
this results in a set of all the antinodes
```
╭─                     
  ╓─                   
  ╟  3  2              
  ╟  0 11              
					   
	 5  6              
	¯1  9   ╓─         
			╟ 11 10    
	 7  0   ╟  2  4    
	¯2 12              
			  13 12    
	 4  9      1  3    
	 1  3              
			  10 10    
	 6  3      7  7    
	 0  6           ╜  
					   
	 5  1              
	 2 10              
		  ╜            
					  ╯
```
If I duplicate my input grid again before finding the antenna, using *by* when I `GetChars` then at the end on the stack I have:
- possible antinode locations (top)
- original grid (bottom)

I don't care which type of antennae produced which antinodes so let's just get a list of the nodes without boxes. `/◇⊂` *reduce content join*

In fact I don't care about that already once I've found the pairs of antennae so let's do it earlier:
```
⊸GetChars . 🗒️
/◇⊂ ⍚FindAntennaePairs⊙¤
≡≡FindAntinodes
```

This gives us an array that still has more dimensions than we care about. The shape is `[9 2 2]`, there are 9 pairs of antinodes, each pair has two sets of coordinates, each set of coordinates has two values. The array is 
```
╭─     
╷ 1 8  
╷ 2 5  
	   
  1 8  
  3 7  
	   
  1 8  
  4 4  
	   
  2 5  
  3 7  
	   
  2 5  
  4 4  
	   
  3 7  
  4 4  
	   
  5 6  
  8 8  
	   
  5 6  
  9 9  
	   
  8 8  
  9 9  
	  ╯
```

Another *reduce join* (after using the pairs of antennae) 
```
⊸GetChars . 🗒️
/◇⊂ ⍚FindAntennaePairs⊙¤
/⊂≡≡FindAntinodes
```

takes us to the list of possible antinodes:
```
╭─       
╷ 15 ¯6  
   8 ¯1  
  15 ¯6  
  11 ¯1  
  15 ¯6  
   4  4  
   8 ¯1  
  11 ¯1  
   8 ¯1  
   4  4  
  11 ¯1  
   4  4  
   7  4  
   8  8  
   7  4  
   9  9  
   8  8  
   9  9  
		╯
```
which are on top of the stack with the original grid beneath them.

Now it's definitely time to filter the nodes using *keep*.

### filtering for out of grid antinodes

first let's find the elements where either index of the antinodes is below zero. I'm expecting ` ⌕ <0 .` *find* to work but it doesn't, not even if I just look at the *first* element `[15 ¯6]`. Nor does *mask*. What am I missing?

*find* isn't working with a function, just a value `⌕ ¯6` gives `[0 1]` as expected but `⌕ <0` gives `[0 0]`.

however *keep* works directly. `▽ >0` gives `[15]`. 

But I wanted to do the masking myself so I could throw away any rows with elements <0 or >size of grid, not just individual elements of the antinodes. The stack manipulation I do to get things to work this way feel very precarious:
```
⍚▽ >0 .
:, ⊃(⊙|⋅⊙) ⧻ ,
⍚▽ <
```

This results in 
```
{[] [8] [] [11] [] [4 4] [8] [11] [8] [4 4] [11] [4 4] [7 4] [8 8] [7 4] [9 9] [8 8] [9 9]}
```
The out of bounds elements have been removed from the coordinates. Only those with 2 elements will be inside the grid.
I can find the length of each of these elements and only keep those with length 2
```
≡◇⧻ .
▽ = 2
```
Which results in a nine element list:

```
{[4 4] [4 4] [4 4] [7 4] [8 8] [7 4] [9 9] [8 8] [9 9]}
```
And I can just use *length* to count those elements. 

It really feels like this filtering is done in a completely wonky way though! It's also not the right answer, which should be 14.

### where did I go wrong?

My list of eighteen possible antinodes definitely has nine inside the grid and nine without so it's not the dodgy filtering code to blame.

Example 3 should give me 6 antinodes, 4 of which are on the grid:
```
..........
..........
..........
....a.....
........a.
.....a....
..........
..........
..........
..........
```

This gives me six possible antinodes and then reduces them to four 
```
{[5 2] [5 2] [5 5] [5 5]}
```
These don't look right! They are repeating pairs.

I check the locations of the antennae, these look good:
```
│ ╭─     
├╴╷ 3 4  
│ ╷ 4 8  
│        
│   3 4  
│   5 5  
│        
│   4 8  
│   5 5  
│       ╯
```

But the locations of the antinodes are wrong:
```
│ ╭─      
├╴╷  5 2  
│   12 0  
│    5 2  
│    5 5  
│   12 0  
│    5 5  
│        ╯
```

The first pair `[3 4]` and `[4 8]` differ by `[1 4]`. 
- Adding `[1 4]` to `[4 8]` gives me an antinode at `[5 12]`; 
- Subtracting `[1 4]` from `[3 4]` gives me `[2 0]`. 

It looks like I've done something backwards here. I check what happens if I do this with the antennae reversed:
`[4 8]` and `[3 4]` differ by `[-1 -4]`
- Adding `[-1 -4]` to `[3 4]` gives me `[2 0]`
- Subtracting `[-1 -4]` from `[4 8]` gives me `[5 12]`.

As I thought originally the order of the antennae doesn't matter. What does matter is that when I find the difference vector by doing `d=y-x` I then find the antinodes by doing `d+y` and `x-d`.

Looking at this bit of my `FindAntinodes` function I see I'm doing `⊃(+⊙⋅⊙|-⊙⊙⋅) ◡-`

The stack contains `x y`; the `-` function will calculate `y - x`. The first value on the stack `y` is subtracted from the second `x`.

After `◡-` stack now is `d x y`. My forked planets now add  `d+y` and do `-dx` which is, yes, `x-d`. 

So my `FindAntinodes` function on 
```
╭─     
╷ 3 4  
  4 8  
	  ╯
```
is giving 
```
╭─      
╷ 5 12  
  2  0  
	   ╯
```
And these are right.

So I haven't made a mistake here either. Something must be going wrong when I join these together?

After this
```
⊸GetChars . 🗒️
/◇⊂ ⍚FindAntennaePairs⊙¤
≡FindAntinodes
```

I have 
```
╭─      
╷ 5 12  
╷ 2  0  
		
  7  6  
  1  3  
		
  6  2  
  3 11  
	   ╯
```

Which certainly looks like a set of six different antinodes as expected. Looking at my original code rather than just *reduce join*ing these together I've added an extra *rows* modifier!

So now this 
```
⊸GetChars . 🗒️
/◇⊂ ⍚FindAntennaePairs⊙¤
/⊂≡FindAntinodes
```
gives the set of six possible antinodes:
```
╭─      
╷ 5 12  
  2  0  
  7  6  
  1  3  
  6  2  
  3 11  
	   ╯
```
So far, so good.

That's not the only problem though! When I filter this I should remove just the two nodes with indexes >10. But I'm also removing the one with a zero index. That's curious. Ah...
```
FilterAntinodes ← (
  ⍚▽ >0 .
  :, ⊃(⊙|⋅⊙) ⧻ ,
  ⍚▽ <
  ≡◇⧻ .
  ▽ = 2
)
```
This horrendous function has `>0` where it should have greater than or equal to!

Now I get four distinct nodes for this example. Hurray!

But for the original example I get 15 nodes not the 14 I want.
```
{[3 2] [0 11] [5 6] [7 0] [4 9] [1 3] [6 3] [0 6] [5 1] [2 10] [11 10] [2 4] [1 3] [10 10] [7 7]}
```

Ah, `[1 3]` has an antinode placed at it by two different sets of antennae. Let's deduplicate. Now we have 14 **distinct** antinode locations.

# ⭐️Solution

With the debugging completed I get the correct answer on the full input.