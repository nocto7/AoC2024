## day 2

[Day 2 - Advent of Code 2024](https://adventofcode.com/2024/day/2)

## example input
```
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
```

## Part 1
1. get the input 
2. each row is safe if
	- numbers are strictly increasing or decreasing
	- no consecutive numbers differ by more than three
3. count safe levels

### input wrangling
From yesterday `⊜(⊜⋕⊸≠@ )⊸≠@\n` should get this input loaded again.
```
💾 ← &fras "example.txt"
📋 ← ⊜(⊜⋕⊸≠@ )⊸≠@\n
```

so 📋💾 gives the array:
```
╭─           
╷ 7 6 4 2 1  
  1 2 7 8 9  
  9 7 6 2 1  
  1 3 2 4 5  
  8 6 4 4 1  
  1 3 6 7 9  
			╯
```

### solving the puzzle

#### is a single row safe?
working on a single row of the array (eg ⊢ *first*) such as `[7 6 4 2 1]`)

pair up the consecutive terms using `◫2` *[windows](https://www.uiua.org/docs/windows)* 2 to give
```
╭─     
╷ 7 6  
  6 4  
  4 2  
  2 1  
	  ╯
```
then use `≡/-` *rows reduce subtract* to find the differences between each element to give
```
[¯1 ¯2 ¯2 ¯1]
```

so `📏  ← ≡/- ◫2` 

now we want to know if these are 
	a. all the same sign
	b. all have absolute value less than or equal to three

##### all the same sign?
`±` [sign](https://www.uiua.org/docs/sign) gives the numerical sign of each element of the array, so here it gives `[¯1 ¯1 ¯1 ¯1]`. These should all be the same.

`◰` [unique](https://www.uiua.org/docs/unique) masks the first occurence of items in an array, ie here it just gives `[1 0 0 0]` as all the elements after the first are the same as it.

so if we add those elements together with `/+` *reduce add* then we'll get `1` if the array is monotonic increasing or decreasing. use `≍ 1` *[match](https://www.uiua.org/docs/match) 1* to check this. 

altogether: `🤔 ← ≍ 1 /+◰±` tells us if the elements of the row are all increasing or decreasing

###### testing!
I remembered that testing exists and checked this function worked using `⍤⤙≍` *assert with match* (ok, I remembered testing existed when the first version I'd written didn't pass but it does now)

The first thing after `⍤⤙≍` should be the result you're expecting. Here I'm expecting the first two tests to give 1 because they are all positive or negative, and the third one should give 0 because the signs of the elements are mixed.
```
  ⍤⤙≍ 1 🤔 [1 2 1]
  ⍤⤙≍ 1 🤔 [¯1 ¯4 ¯1]
  ⍤⤙≍ 0 🤔 [1 ¯4 ¯1]
```
##### all <= 3
first take the `⌵` *absolute value* to turn everything into a positive number, then whilst I could have used `<=3` as you'd probably expect to check if they are all less than or equal to three it was actually going to be simpler if I checked if anything was `> 3` instead.

so `> 3 ⌵` gives `[0 0 0 0]`

then add up that array using `/+` *reduce add* and check it's zero using `≍ 0` *match 0*

altogether: `😍 ← ≍ 0 /+ > 3 ⌵`

###### testing!
again some tests using  `⍤⤙≍` *assert with match* to check this is working as expected:
```
  ⍤⤙≍ 1 😍 [1 ¯3 ¯1]
  ⍤⤙≍ 0 😍 [6 ¯3 ¯2]
  ⍤⤙≍ 1 😍 [3 3 1]
```
##### putting them together
`⊃` *[fork](https://www.uiua.org/docs/fork)* lets us call two functions on the same values so `⊃😍🤔` calls both of the above functions and puts their results onto the stack. since both answers should be `1` if we're to be safe so multiply them and check they are `1`

OK, at this point my penchant for emoji names is annoying even me so let's revert to using the alphabet
```
SafeRow ← ≍ 1 × ⊃😍🤔📏
```
SafeRow tells us if a single row of the input is safe

###### testing!
We might as well test this function works on every row of the test data before we go any further:
```
  ⍤⤙≍ 1 SafeRow [7 6 4 2 1]
  ⍤⤙≍ 0 SafeRow [1 2 7 8 9]
  ⍤⤙≍ 0 SafeRow [9 7 6 2 1]
  ⍤⤙≍ 0 SafeRow [1 3 2 4 5]
  ⍤⤙≍ 0 SafeRow [8 6 4 4 1]
  ⍤⤙≍ 1 SafeRow [1 3 6 7 9]
```

happily it does - well I'd made a couple of arse ups but they are now fixed.
#### multi row solution

now I try `≡SafeRow` to run  `SafeRow` on every row of the original input. I'm expecting the first and last rows to be safe and the others to be unsafe. 

`[1 0 0 0 0 1]`

hurray! this is as expected. 

now I just need to add these up using `/+` *reduce add* yet again to get the answer.

```
📩  ← /+≡SafeRow 📋💾
```

## Actual input

On finally looking at the real input I notice something critical that's different from the example input. **The rows aren't all the same length!**

The first few rows are 
```
73 75 78 81 80
81 82 83 86 89 89
66 67 68 71 75
66 67 69 70 72 74 77 83
```

which means the code I've written isn't happy and I get errors like `Error: Cannot combine arrays with shapes [5] and [8]`. 

The error is from input parser: `📋 ← ⊜(⊜⋕⊸≠@ )⊸≠@\n` which is code I cribbed from the uiua Discord yesterday as it seemed simpler than the version I had used.

In order to get the input loaded with different lengths of arrays we need to [box](https://www.uiua.org/docs/box) each row as we read it and then unbox it before we use it. Boxes are the thing uiua uses to make it so arrays can contain elements that aren't all the same shape and type. This means that these two functions change slightly to include `□` *box* and `°□` *unbox*

```
📋       ← ⊜(□⊜⋕⊸≠@ )⊸≠@\n
📏       ← ≡/- ◫2 °□
```

## ⭐️ Solution
Using real input 📩 gave the correct solution.

## Part 2

Now the additional thing is that if a row is found to be unsafe you need to check if removing a single element can make it safe. This happens with two rows of the original example input if you remove the second level, 3, from the fourth line and the third level, 4, from the fifth line. So we expect to get 4 really safe rows now. Let's set the tests up first:

```
  ⍤⤙≍ 1 ReallySafeRow [7 6 4 2 1]
  ⍤⤙≍ 0 ReallySafeRow [1 2 7 8 9]
  ⍤⤙≍ 0 ReallySafeRow [9 7 6 2 1]
  ⍤⤙≍ 1 ReallySafeRow [1 3 2 4 5]
  ⍤⤙≍ 1 ReallySafeRow [8 6 4 4 1]
  ⍤⤙≍ 1 ReallySafeRow [1 3 6 7 9]
```

So for the fourth row `[1 3 2 4 5]`, once we've found it's not safe by the initial criteria we want to try each of the possible options
```
[3 2 4 5]
[1 2 4 5]
[1 3 4 5]
[1 3 2 5]
[1 3 2 4]
```
and if any one of these is safe then we declare it safe.

Looking through the uiua docs for something that would give me this kind of combination I found an experimental feature that creates `⧅` *[tuples](https://www.uiua.org/docs/tup)* so let's live life on the edge and make use of it. `⧅< 4 [1 3 2 4 5]`. I'm really not quite with how that works but the docs say it'll give me unique combinations of 4 rows from the array and it gives me exactly what I want so I'm going to shoot first and ask questions later. This gives me:
```
╭─         
╷ 1 3 2 4  
  1 3 2 5  
  1 3 4 5  
  1 2 4 5  
  3 2 4 5  
		  ╯
```
which is exactly the same as above (except the rows are backwards which makes no odds). 

I need to add an `# Experimental!` comment to the top of the file before uiua lets me use the experimental function, acknowledging that I know this function might vanish in the future. I only want this code to work today so that's all fine with me.

So I need to find if any of these are a `SafeRow`

```
≡SafeRow ⧅< 4 [1 3 2 4 5]
```

gives me `[0 0 1 1 0]` showing that two of the options are safe. 

Let's test with another row that we know to not be able to be made safe by removing one element. `≡SafeRow ⧅< 4 [9 7 6 2 1]` gives an array of all zeroes showing that none of the possible combinations are safe.

So in order to find if there's at least one SafeRow out of the combinations I again `/+` *reduce add* and see if I've got a number greater than zero indicating that at least one of the new rows was safe.

This gives me `DampedSafeRow ← >0/+≡SafeRow ⧅< 4` 

So now I want to combine these and see if the row is either safe itself, or the damped version can be safe. I use *fork* again to test both for a `SafeRow` and a `DampedSafeRow` and then I find there's also a logical `∨` [or](https://www.uiua.org/docs/or) function in the experimental features so we may as well use that here too.

```
ReallySafeRow ← ∨ ⊃SafeRow DampedSafeRow
```

A quick run with the example data shows that the unboxing of each row is better moved into the functions:
```
SafeRow       ← ≍ 1 × ⊃😍🤔📏°□
DampedSafeRow ← >0/+≡SafeRow ⧅< 4 °□
```

That works on the example data but with the real data I get an answer that's too high. I look at some of the intermediate calculations using `?` to examine the [stack](https://www.uiua.org/docs/%3F) at various points and see arrays that are much longer than I'm expecting to see.

🤦🏻‍♀️Aarghhh! I have once again assumed there are 5 elements in each row and have hard coded in the `4` to the combination calculation! 

Instead of `4` we want to use one less than the length of the array. So that's `-1⧻` *subtract 1 length* and before we do that we want to duplicate the value on the stack with `.` so it isn't consumed by this calculation. Which changes the `DampedSafeRow` function to:

```
DampedSafeRow ← ?>0/+?≡SafeRow ?⧅< -1⧻. ?°□
```

## ⭐️⭐️ Solution
Now I have the second star for part two.

## Afternotes

I'm (probably) not going to get round to amending today's solutions to include things I realised later once I've got the solution entered but want to record them so I remember for future days.

 `◇` [content](https://www.uiua.org/docs/content) unboxes the arguments to a function before calling it, more readable/reusable to use that than unboxing as the first thing within the function itself.
 