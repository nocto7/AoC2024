# AoC2024

👩🏻‍💻 An attempt to learn [Uiua](https://www.uiua.org/) by working through the [Advent of Code 2024](https://adventofcode.com/2024) puzzles.

📀 Using [uiua v0.14.0-dev.5 ](https://github.com/uiua-lang/uiua#90b11407)

## ⭐️ [1 Historian Hysteria](day1)

The puzzle is pretty simple involving sorting lists of numbers. My rudimentary uiua is up to solving the problem with not much more than *sort*, *absolute value* and *reduce add*.  Most of my learning is how to handle the file input and turn it into the kind of arrays I want.

## ⭐️⭐️ [2 Red-Nosed Reports](day2)

Getting the input is much simpler now! This involves checking if the numbers in rows of the input meet certain criteria. I used *sign*, *unique* and *match*, figured out how to run tests with *assert with match* and used *fork* to do different things with the same bits of data. I use *tuples* in part two to get combinations of the data with one element missing but don't really figure out what it's doing yet. And realise I can use *content* to unbox the arguments to a function before calling it.

## ⭐️⭐️ [3 Mull It Over](day3)
We're looking through a stream of text looking for `mul(x,y)` commands. I use *regex* which feels a bit of a cheat as it's not really uiua at all. For the second part we need to ignore parts of the string and rather than doing more regex I use *partition* and *mask* to split the input and remove sections, in a very similar way to the way I usually handle the input. Finding the *shape* of arrays helped me debug.

## ⭐️⭐️ [4 Ceres Search](day4)
This is a wordsearch grid that only contains X, M, A and S and you are looking for how many times the word XMAS appears in it. Getting the horizontal and vertical words using *find*, *reverse* and *transpose*. I spend approximately forever trying to get the diagonals of the grid out. I use *keep* *pick*. I run into trouble trying to make a function that works on one element work with *rows* and get the advice to use *rows F dip fix* which I don't understand at the time. Eventually I get an answer but it's too low and I give up for now. I think I need to use a different approach than finding the diagonals as I'm clearly doing something wrong.

🆕I [came back to look at this](day4/redux.md) on the 7th and found I'd made an incorrect assumption which had resulted in me finding the same set of diagonals twice over; which worked on the test data but not on the real data. Then I found part two a much easier puzzle to solve than the first part.

## ⭐️ [5 Print Queue](day5)
We're figuring out if lists of numbers meet certain ordering rules. The data is more complicated to parse today with two separate sections and I start to find juggling the items on the stack a bit complicated. I use *on* to keep things on top of the stack when I call a function. I put the rules into a *map*.  I use *memberof* to check if the numbers meet the rules. I work out looping with *do* and *switch*.

The *signature* function has been removed from uiua and replaced with the macro `(⋅⊢)^!` which I'm putting (along with macros) on my list of things to look at later, but it's useful for debugging. I don't get around to trying out the second part of the puzzle.

## ⭐️ [6 Guard Gallivant](day6)
There's a guard walking round a room turning right every time she meets an obstacle. We need to figure out how many squares she visits before she walks off the grid. I trace the guards path in the grid replacing spaces she visits with Xs and then count them up at the end.I use *under pick* to replace locations in the grid though needing to do an *unfix* between this and the result of *where find* confuses me. Wrangling the stack is still causing me grief though I eventually feel like I'm working out how *fork* and *planet notation* go together.  I find *below* useful for keeping all the inputs to a function below its result on the stack. I struggle with the bounds check for the guard leaving the grid. Negative indices refer to rows at the end of the grid, only oversize numbers throw an error. 

I'm really pleased with getting the solution to part one and should have stopped there as I spend a lot of time on the second part before realising I've slightly misunderstood the question.

##  ⭐️⭐️ [7 Bridge Repair](day7)

This is the first day where I feel like I'm writing code in uiua rather than wrangling with slippery eels. My algorithm is not very efficient and takes a while to run but it works and I feel the code is reasonably clean and I'd know what it was doing if I looked back at it. I'm a lot clearer about what's going onto the stack and how to rearrange it. I used *subscripts* for the first time which don't work on everything but they are very neat when they do. I'm quite happy with how easily I got part two extrapolated from my part one solution too.

## ⭐️ [8 Resonant Collinearity](day8)

After a couple of days away from home I'm back to find 'antinodes' of rooftop antennae. The puzzle which involves handling another 2D grid seems fairly simple but I make a silly mistake combining rows together too many times and write some nasty filtering code I want to work out a better version of. Debugging and refactoring.


## ⭐️ [9 Disk Fragmenter](day9)

I don't really get why this puzzle about moving files around on disks took so long for me to get my head around! Having finished it I don't think it's that hard to understand but I made hard work of it. Mostly learnt a lot about refactoring and debugging.

## ⭐️⭐️ [10 Hoof It](day10)

This two dimensional grid puzzle was easy to visualise but I made hard work of moving things around in *box*es. The first time I've used *fold* to aggregate the answer. Part two turned out to be something I'd done on the way to part one so it was nice to get an easy second star!

## ⭐️ [11 Plutonian Pebbles](day11)

An obvious case of the naive algorithm isn't going to work for very long. I intended to do something better from the start but the simple solution worked for Part One. Attempts to do better for part two came to nowt. Mostly I got tangled up in rearranging boxes again. One to come back to later I think.

## ⭐️ [12 Garden Groups](day12)

Two dimensional partitioning is brilliant. I was all set to work this out in a much more complicated way! That ended up being quite straightforward (though I haven't tried part two yet).

## ⭐️ [13 Claw Contraption](day13)

Simultaneous equations cause me more trouble than I'd expect (not least not finding the correct part two answer), but nothing fancy new is needed to solve the puzzle.

## 📑bookmarked to look at further
- *tuples* how do the operators work?
- *rows F dip fix* (I've worked out why this works but not explained it here yet.)
- `(⋅⊢)^!` signature macro.
- *unfix* needed between *where find* and *under pick*. why?
- Out of bounds checks, is there an easy way?