# day 6
[Day 6 - Advent of Code 2024](https://adventofcode.com/2024/day/6)

# Part One

Today we are trying to avoid the guard patrolling the lab. The guard is facing up, represented by `^` and walks forwards across the `.` of the grid until she reaches an obstacle `#`. Then she turns right and carries on. Eventually she'll leave the grid. How many positions does she reach before she leaves the grid?
```
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
```

### Input

By now it's cut'n'paste to get the input file loaded into an array.
```
💾  ← &fras "example.txt"
🗒️ ← ⊜∘¬⊸⦷@\n💾
```

### Finding the guard
We want to find where the guard, represented by `^` is located in the grid. Initially I go down a rabbit hole looking into the *[indexof](https://www.uiua.org/docs/index)* function but that's finding the row indices which isn't what I want. I discover, without too much palaver, that what I'm after is `⊚ ⌕ @^` *where find* which gives me the location 
```
╭─     
╷ 6 4  
	  ╯
```

I can use `⊡` *pick* to verify the character at that location is `^`.

It seems to me that the easiest way to do this puzzle is to keep updating the grid as the guard moves. 

So, ignoring obstacles for now, I want to do two things:
- replace that location, which has been visited by the guard with an `X` to show she's been there; 
- and also move the guard to the location in the row above.

#### replace the location
I find I can use `⍜⊡` *under pick* to replace the given location with an X. I get a little confused as to why that doesn't work directly with the output from the *where find* call above though. Then I realise that `[6 4]` has shape `[2]` and the *where find* result above has shape `[1 2]` so I need to *unfix* it before I can use it to *pick*. (Note to self: why?)
```
°¤ ⊚ ⌕ @^ . 🗒️
⍜⊡◌ ⊙⊙@X # replace guard location with X
```
this gives
```
╭─              
╷ "....#....."  
  ".........#"  
  ".........."  
  "..#......."  
  ".......#.."  
  ".........."  
  ".#..X....."  
  "........#."  
  "#........."  
  "......#..."  
			   ╯
```

I want to keep the guard's location on the stack so that I can update it though. This requires me to preface the call with `⟜` *on* "Call a function but keep its first argument on the top of the stack". The glyph for this one has the circle at the beginning showing, I guess, that you're keeping the first thing.
#### update the guard's location
To move the guard to a new location I first want to change the location indices. Going up in the grid means subtracting one from the first index and leaving the other intact, so I do the same kind of thing
```
⍜⊡ ◌ +[¯1 0]⊙⊙@^
```
which gives me
```
╭─              
╷ "....#....."  
  ".........#"  
  ".........."  
  "..#......."  
  ".......#.."  
  "....^....."  
  ".#..X....."  
  "........#."  
  "#........."  
  "......#..."  
			   ╯
```
Yay, we have moved the guard 😃.

#### repeat
Now let's ignore the obstacles and turning and repeat that until the guard falls off the edge of the map. First let's create some functions and check we can chain them:
```
Locate ← °¤ ⊚ ⌕ @^
X    ← ⟜⍜⊡◌ ⊙⊙@X
Move ← ⍜⊡ ◌ +[¯1 0]⊙⊙@^

Move X Locate . 🗒️
Move X Locate .
Move X Locate .
```
This moves the guard three steps forwards
```
╭─              
╷ "....#....."  
  ".........#"  
  ".........."  
  "..#.^....."  
  "....X..#.."  
  "....X....."  
  ".#..X....."  
  "........#."  
  "#........."  
  "......#..."  
			   ╯
```

So we want to put `Move X Locate .` into a *do* loop. But what condition are we going to use to show we've gone as far as we can? Maybe I should look at those obstacles first.

#### Finding obstacles

When we move the guard we want to check if she's trying to move into the space with an obstacle on it. So once we've found the location to move her too we should *pick* what is there and check it's not a `#`

At the point where we find the obstacle, we've moved several times after `X Locate .` we have a stack that looks like 
```
╭─              
╷ "....#....."  
  "....X....#"  
  "....X....."  
  "..#.X....."  
  "....X..#.."  
  "....X....."  
  ".#..X....."  
  "........#."  
  "#........."  
  "......#..."  
			   ╯
[1 4]
```

Before updating the guard to move to `[0 4]` we want to check what's in that space. I can pick what's at that location and check if it's a `#`
```
Check  ← =@# ⊡ +[¯1 0]
```
But this consumes all my arguments and the only thing i'm left with is whether the guard needs to turn. I want to preserve all the other arguments I had! this is what `◡` *[below](https://www.uiua.org/docs/below)* does.

So instead of always moving I can choose each step whether it's time to Move or Turn
```
Locate ← °¤ ⊚ ⌕ @^
X      ← ⟜⍜⊡◌ ⊙⊙@X
Move   ← ⍜⊡ ◌ +[¯1 0]⊙⊙@^
Turn   ← ∘
Check  ← =@# ⊡ +[¯1 0]

⨬(Move|Turn) ◡Check X Locate . 🗒️
⨬(Move|Turn) ◡Check X Locate .
⨬(Move|Turn) ◡Check X Locate .
⨬(Move|Turn) ◡Check X Locate .
⨬(Move|Turn) ◡Check X Locate .
```
Now I need to work out how to actually turn as the `Turn` function here is just a placeholder

#### Turning
So far I've hard coded the `[¯1 0]` vector that shows the guard is moving upwards. When she reaches an obstacle she turns to the right, which will put her on a `[0 1]` heading I think; then she'll turn down on `[1 0]` and finally head left on `[0 ¯1]`

To rotate through these I want to change flip the sign on the first index and then swap the elements over. I'm using *rotate* to swap the elements around (and feeling like I might be missing something but this works)

```
Turn   ← ↻ 1 × [¯1 1]

Turn . [¯1 0]
Turn .
Turn .
Turn .
Turn .
```

gives

```
[¯1 0]
[0 1]
[1 ¯0]
[¯0 ¯1]
[¯1 0]
[0 1]
```

So now I need to keep this, the guard's heading vector, on the stack as well and turn it when required. The heading vector is used by both the `Check` and `Move` functions so both need updating to find the value on the stack and leave it where they found it.

I'm getting the hang of the combo between planet notation and *fork* now, within the `Move` function those let me find that argument from the stack, then I need to keep it where it was.

After the manipulation I have some hairy looking planets but I'm definitely starting to understand how to combine them
```
Move   ← ⍜⊡ ◌ +⊃(⋅⋅⊙|⊙⊙@^)
Check  ← =@# ⊡ +⊃(⋅⋅⊙|⊙⊙)
Turn   ← ⊃(⋅⋅⊙|⊙⋅⋅) ↻ 1 × [¯1 1] ⊃(⋅⋅⊙|⊙⊙)

⨬(:⤙Move|Turn) 
```

I feel the *flip with* on Move can probably be handled by planets too but this is working ok for now.

Now my problem is that I'm overwriting the guard's location with `X` before I turn her; it would be better to do that after I've turned her so that I can find her location again without needing to store it.

What's going to go wrong with that is obvious when I get to this point without adding the `X` though
```
⨬(:⤙Move|Turn) ◡Check Locate .
```

I can't distinguish the guard's original location from her new one:
```
╭─              
╷ "....#....."  
  ".........#"  
  ".........."  
  "..#......."  
  ".......#.."  
  "....^....."  
  ".#..^....."  
  "........#."  
  "#........."  
  "......#..."  
			   ╯
```

Near-duplicating the `Locate` and `X` functions to mark the guards old location with `Y`
```
Locate  ← °¤ ⊚ ⌕ @^
LocateY ← °¤ ⊚ ⌕ @Y
X       ← ⟜⍜⊡◌ ⊙⊙@X
Y       ← ⟜⍜⊡◌ ⊙⊙@Y
```

But this feels like it's getting rather convoluted. I'm doing the thing where I bash through rather than think. Let's go back to the algorithm now we know more about the problems.

#### algorithm redux
- find the guard's location, where the `^` is in the grid
- check the position in front of the guard
	- if it's an obstacle, turn the guard, then go back and check what's in front of the guard again. That is, keep turning the guard until there is no obstacle in front of them, there is either an `X`, a `.` or they are at the edge of the grid.
	- if the guard is heading off the edge of the grid, stop and count up their visited locations
- move the guard forward in the direction they are heading
- X out the location the guard moved from
- go back to the start to handle their new location

The upshot of this is that basically what I really needed was to call the `X` function within the `Move` function. I only want to move the guard and `X` out their old position once i've ascertained that she can move in that direction.

Now everything looks good! This is what the grid looks like after a few repeats with the guard avoiding the obstacles.
```
╭─              
╷ "....#....."  
  "....XXXXX#"  
  "....X...X."  
  "..#.X...X."  
  "....X..#^."  
  "....X....."  
  ".#..X....."  
  "........#."  
  "#........."  
  "......#..."  
			   ╯
```

		
#### end conditions

We want to stop when the guard tries to move out of the grid.

To check how uiua handles the indexes going out of bounds I remove the top `#` from the grid for a moment.

After a few repeats I now see that the guard's path is wrapping around!
```
╭─              
╷ "....X....."  
  "....X....#"  
  "....^....."  
  "..#.X....."  
  "....X..#.."  
  "....X....."  
  ".#..X....."  
  "....X...#."  
  "#...X....."  
  "....X.#..."  
			   ╯
```
 When the guard has reach `[0 4]` the location has been changed to `[-1 4]` which has caused the guard to come back in at the bottom of the grid. I was expecting this to give an error.

So in my `Check` function, or perhaps after it, I also want to check whether the space in front of the guard is out of bounds.

#### out of bounds condition

I want to check if either index of the heading vector `[x y]` is <0 or >9.  Because of the pervasiveness of operations in uiua if I do `<0 [¯1 4]` then I get `[1 0]` which tells me that the first index fails the test. So to do both tests I *fork* then add up the results:
```
/++⊃(<0|>9) [¯1 4]
```

So when we start the `Move` part of the *switch* statement we've got the stack with
- guards location
- grid
- heading vector

Before we move we want to check the bounds, then we want to put the stack back in the same order in order to be able to move. Well that works using *below* the same as with my original `Check`.

#### getting out of the loop

So I need to put it together so it only moves if `CheckBounds` is true (which is `0` in this case); and if it's false `1` the loop ends so we can find the answer.

#### counting the Xs

Before I deal with ending loops let's have a break and solve an easier problem. At the end we want to count up the number of `X`s we've placed in the grid.

Here's the grid after 30 moves:
```
╭─              
╷ "....#....."  
  "....XXXXX#"  
  "....X...X."  
  "..#.X...X."  
  "..XXX^.#X."  
  "..X.X...X."  
  ".#XXXXXXX."  
  "........#."  
  "#........."  
  "......#..."  
			   ╯
```

In a very similar way to how we located the guard we can *mask* the locations containing `X`s and then add them up.

```
CountXs     ← /+/+⌕ @X
```
Which tells me that grid has 23 Xs in it. (The guard hasn't finished their walk yet though.)

Easy bit done so...

#### back to the loop

For an end condition I can check whether the grid has the guard in it. In exactly the same way as I've just counted the Xs, this time there should only be 0 or 1 guard though.
```
Present     ← /+/+⌕ @^
```

Now for my out of bounds check I want to X out the old position of the guard, but if the new position is out of bounds then I should just ignore it and not place the guard in the grid which will allow the loop to end.

Ah, I've just found something new, but not unexpected. uiua behaves differently when the index goes over the size of the array than it does when the index is negative. "Error: Index 10 is out of bounds of length 10 (dimension 0) in shape [10 × 10]". Not unexpected because I was expecting something like that to happen when I went below zero. What it means though is that my `Check` function isn't happy as soon as I try to check the position in front of the guard is off the grid.

So let's move the check on the bounds to within the `Check` function.

At the moment `Check` returns 0 if there is no obstacle in front of the guard, 1 if there is an obstacle in front of the guard. Let's add 2 if the location in front of the guard is off the grid.

THis will be easier if we separate the part out where we calculate where the guard would move to next:
```
Next        ← +⊃(⋅⋅⊙|⊙⊙)
```

Now I have each step of the guard's walk
```
 ⨬(:⤙Move|Turn) ⨬(◡Check|◡X) CheckBounds ◡Next Locate .
```

and after each step it leaves the heading vector and the grid on the stack.

I just need to sort out the bit where the guard moves off the grid on the last step.

After we've done a successful check we have
- 0 the check result
- guard's location
- grid
- heading vector

So after an unsuccessful check let's leave the stack in the same condition only this time the guard isn't in the grid.

Right, this is almost there:
```
⍥(⨬(⨬(:⤙Move|Turn) ◡Check|◌X) CheckBounds ◡Next Locate .)53
```
After 54 repeats I have the stack with 
- grid with guard
- heading vector
After 55 repeats I have the stack with
- grid without guard
- heading vector

So finally in a *do* loop 
```
⍢(⨬(⨬(:⤙Move|Turn) ◡Check|◌X) CheckBounds ◡Next Locate .
| Present .)
```

This finishes when the guard leaves the grid and I can `CountXs` to find the guard visited 41 squares as expected.

### ⭐️Solution

Well, I realise quickly with the real input that I've hard coded in `9` as the maximum index of the 10x10 test array but I decide to just change it to `129` for the 130x130 real array size. And that gives me the answer. I suspect there's a better way of doing the bounds check so I'm not going to mess about with that now.

## Part Two

I'm not going to solve this now but to send the guard in a loop I guess you need to find when she crosses her own track and try and send her in the same direction. When she comes across an `X` rather than a `.` in the grid you want to send her the same way she went before. Probably by marking which direction she's travelling in with different letters rather than Xs. 