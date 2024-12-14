# day 11

## Part One

Today we have a sequence of numbers which transform and threaten to grow to a frighteningly large amount of numbers!

Each number changes each blink according to rules:
- `0` is replaced by `1`
- even numbers are split by digits, eg `1000` become `10` and `00`, `00` is equivalent to `0`. 
- anything else is multiplied by `2024`

We only need to know the number of numbers there will be after 25 blinks, not exactly what any of the numbers are.

My thinking is that we need to follow the rules but when we see a number we've seen before we replace it with something that points to where we've seen it before so we only do the calculations once for each number. Also, despite the repeated emphasis on the numbers changing **simultaneously** in the text the numbers don't interact so we don't need to handle them all at the same time, nor in the correct order.

Our example sequence is simply `125 17`; hardly worth the hassle of reading from a file so I won't 😃 But let's ignore the example data for a moment and look at what happens to a zero.

```
ZeroRule ← (⨬(∘|1) = 0 .)

  ⍤⤙≍ 1 ZeroRule 0
  ⍤⤙≍ 4 ZeroRule 4
```

This function returns a 1 if it's given a zero, for anything else it gives the number back.

Now for the rule for an even number of digits. First we need to test the number of digits in a number. We can *unparse* it to turn it into a string and look at the length of that. If *mod 2* of this is 0 the number of digits is even, which is the opposite of what we want so we preface it with *not*.

```
IsEven      ← (¬◿ 2 ⧻°⋕)
```

I need a function to split the evenly digited numbers in two
```
SplitNumber ← ⋕ ↯ 2_∞ °⋕
```
I like this; *unparse* the number to turn it into a string, *reshape* it to put it in two evenly sized pieces, then *parse* it again to get the split numbers.

So I can have a rule to follow if the digits are even like:
```
EvenRule    ← ⨬(∘|SplitNumber∘) ⊸IsEven
```

Then I just need the default rule 
```
DefaultRule ← × 2024
```

Now I need to put these three rules together so we follow the first one that changes the number. THe last one will always change the number, unless it's zero, and if it's zero the first rule will already have been applied so that's an edge case we don't need to concern ourselves with.

Control structure in uiua is still feeling a little obtuse to me.  *switch* is basically the only option but that doesn't make things simple, the nesting gets me confused. just printing out which bit was being run on a number helped:

```
FollowRules ← (
  ⊸= 0
  ⨬(⨬(&p "is default"|&p "is even") IsEven|&p "is zero")
)
```

Then put the functions I have created mostly directly into this:
```
IsEven ← ¬◿ 2 ⧻°⋕
FollowRules ← (
  ⊸= 0
  ⨬(⨬(× 2024|⋕ ↯ 2_∞ °⋕) ⊸IsEven|1)
)

FollowRules 0
FollowRules 23
FollowRules 234
FollowRules 1200
```

And ascertain works correctly with a few examples.

Now I want to FollowRules for a number, then do it again on the result; that's *repeat* and I've discovered it can be subscripted: `⍥₃FollowRules 125` repeats 3 times to give `[512072 1]`. Trying to do it the 4th time however gives me an error `Cannot join rank 0 array with rank 2 array`. I need to flatten out the answers into a single array.

```
{1036288 [7 2] [20 24]}
/(◇⊂ ♭)
```

so reduce by flatten and then joining the content of the rows together. It takes me a while to realise that I also need to unbox but after that I have a system that works to figure out which rules to follow when and then count the values in the end.

```
IsEven      ← ¬◿ 2 ⧻°⋕
FollowRules ← ⨬(⨬(× 2024|⋕ ↯ 2_∞ °⋕) ⊸IsEven|1) ⊸= 0

⍥(°□ /(◇⊂ ♭) ⍚FollowRules)25 [28 4 3179 96938 0 6617406 490 816207]
⧻
```

I'm kind of annoyed with this as a solution because it's calculating the values of all the numbers then counting them. I haven't done anything to just do calculations once like I said I was going to! 

### ⭐️ Solution

But this naive solution works on even the real input and only takes a moment (1.3 seconds on my MacBook).

### Part Two

OK, this is as expected really,  run it for three times as many times, which might as well say "find a better method".

On the test input, the 25 blinks take 0.4s, 30 blinks take 3 seconds, 35 blinks take 25 seconds.... I'm not going to try 75 blinks on the real input until those times are faster!

```
kirsty@velox day11 % /usr/bin/time uiua part1.ua
3604697
       25.34 real        24.29 user         0.62 sys
```

Something I've noticed in the uiua docs is *memo*.  Which caches the results of a calculation rather than rerunning it, intended for expensive calculations. I'm sure I'm rerunning a lot of calculations here. Simply sticking *memo* on my call to `FollowRules` shortens the runtime considerably:

```
3604697
        7.75 real         7.35 user         0.38 sys
```

That's an easy win but not a big enough one to get all 75 calculations done in sensible time.

At this point I decide to have a look at the data after a few step, not 35, but 10 looks like it might be representative:
```
[42 45 13 76 94 94 98 88 2 8 6 7 6 0 3 2 80 96 2024 80 96 32772608 8096 1 8096 16192 2 0 2 4 8096 1 8096 16192 16192 1 18216 12144 8 0 9 6 20 24 8 0 9 6 3277 2608 40 48 2024 40 48 80 96 8 0 9 6 20 24 8 0 9 6 3277 2608 3277 2608 20 24 3686 9184 2457 9456 8096 1 8096 16192 32 77 26 8 24 57 94 56 28 67 60 32 24 57 94 56 2 0 2 4 12144 1 14168 4048 8096 1 8096 16192]
```

Lots of numbers, and lots of repeats.

We determined right at the start we don't need to keep our numbers in order. So let's sort these:

```
[0 0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 2 3 4 4 6 6 6 6 6 6 7 8 8 8 8 8 8 9 9 9 9 13 20 20 20 24 24 24 24 24 26 28 32 32 40 40 42 45 48 48 56 56 57 57 60 67 76 77 80 80 80 88 94 94 94 94 96 96 96 98 2024 2024 2457 2608 2608 2608 3277 3277 3277 3686 4048 8096 8096 8096 8096 8096 8096 8096 8096 9184 9456 12144 12144 14168 16192 16192 16192 16192 16192 18216 32772608]
```

Definitely many repeats! Surely we can handle this data better than just asking for the result for each number even if the computer is caching the results for us. 

I want to change this data into a format where it tells me there are seven `0`s, 6 `1`s, 6 `2`s... etc.

I find `°⊚⊛⟜◴` on the uiuaisms page which gives me

```
[0 1 2 3 4 6 7 8 9 13 20 24 26 28 32 40 42 45 48 56 57 60 67 76 77 80 88 94 96 98 2024 2457 2608 3277 3686 4048 8096 9184 9456 12144 14168 16192 18216 32772608]
[7 6 6 1 2 6 1 6 4 1 3 5 1 1 2 2 1 1 2 2 2 1 1 1 1 3 1 4 3 1 2 1 3 3 1 1 8 1 1 2 1 5 1 1]
```

I can *couple* and *transpose* this to get an array that starts:
```
╭─            
╷ 7        0  
  6        1  
  6        2  
  1        3  
  2        4  
  6        6  
  1        7  
  6        8  
  4        9  
  1       13  
  3       20  
```

Now I want to `FollowRules` for each element of the second column and act as if I've done that the number of times in the first column for the next repeat.

Let's go back to a smaller example to check everything is working as expected.

After 4 blinks with the sample data (`[127 17]`) I'm getting:
```
╭─        
╷ 1    0  
  2    2  
  1    4  
  1   72  
  1  512  
  1 2024  
  1 2867  
  1 6032  
		 ╯
```

and after 5 blinks there is:
```
╭─           
╷ 1       1  
  1       2  
  1       7  
  1      20  
  1      24  
  1      28  
  1      32  
  1      60  
  1      67  
  2    4048  
  1    8096  
  1 1036288  
			╯
```

What I realise is that once I have the results of sorting/counting the elements of the list on the stack I don't want to couple/transpose them, I can work quite happily with this:
```
[1 2 1 1 1 1 1 1]
[0 2 4 72 512 2024 2867 6032]
```

The row on top of the stack can be processed using `⍚FollowRules` to produce:
```
{1 4048 8096 [7 2] 1036288 [20 24] [28 67] [60 32]}
```

And now I want to combine this with the `[1 2 1 1 1 1 1 1]` row to get the input for the next blink.

If I *couple*, then *transpose* these then I get this monstrous pile of boxes:
```
╭─             
╷ □1       □1  
  □4048    □2  
  □8096    □1  
  ⟦7 2⟧    □1  
  □1036288 □1  
  ⟦20 24⟧  □1  
  ⟦28 67⟧  □1  
  ⟦60 32⟧  □1  
			  ╯
```

But if I have `[7 2]` on the stack and couple it with `[1 1]` and transpose it 
```
[7 2]
[1 1]
⍉ ⊟
```
then I get
```
╭─     
╷ 1 7  
  1 2  
	  ╯
```
which is what I want to go into the array above instead of `[⟦7 2⟧    □1`.

Can I split the monstrous pile of boxes into two arrays? One with single numbers in the first column and one with boxes? I don't want to split before because I don't want to destroy the relationship between the columns.

I can sort it which keeps the rows matched up and puts the single number rows above the two numbers in a box ones:
```
╭─             
╷ □1       □1  
  □4048    □2  
  □8096    □1  
  □1036288 □1  
  ⟦7 2⟧    □1  
  ⟦20 24⟧  □1  
  ⟦28 67⟧  □1  
  ⟦60 32⟧  □1  
			  ╯
```

My attempts to wrangle this into the format I want are long and convoluted and I eventually give up and ask the discord for assistance.

I get a couple of answers and `/◇⊂⍚(♭₂⍉⊟)` is what I need. 

Now after a couple more iterations I'm getting:
```
[1 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]
[2024 40 48 80 96 14168 4048 2097446912 2 0 2 4 2 8 6 7 6 0 3 2]
```
So I need to squish these up again by combining counts of elements that are the same.

*couple* *transpose* and *sort* again gives
```
╭─              
╷          0 1  
		   0 1  
		   2 1  
		   2 1  
		   2 1  
		   2 1  
		   3 1  
		   4 1  
		   6 1  
		   6 1  
		   7 1  
		   8 1  
		  40 2  
		  48 2  
		  80 1  
		  96 1  
		2024 1  
		4048 1  
	   14168 1  
  2097446912 1  
			   
```

I want to deduplicate the values on the left but add up the values on the right to go with them.

```
⟜(⍆⍉⊟)
⍆◴
```

this gives me the array above and a sorted list of deduplicated numbers on the top of the stack.

After a bit of messing about I find I can get the count of a certain number in that array using eg
```
Count       ← /+ ▽ : = 2 °⊟ ⍉
```
which gives me 2 because the 2 is hardcoded in there. So to be able to pass that in as well as the array above I need to put the number on the stack first, flip the stack to put the second element on top as soon as I enter the function so I can transpose and uncouple it then flip the stack back so I have the number I passed in on top to compare for equality. Except I've uncoupled the array so there's more items on the stack than I remembered about. So I need to get the 3rd item off the stack first. This works:

```
Count       ← /+ ▽ : = ? ⊃(⋅⋅⊙|⊙⊙) ? °⊟ ⍉ :
```

My Count function seems good with multiple numbers `≡Count⊙¤ [0 2 3 48]` gives me `[2 4 1 2]` which looks good with the above data. So give it all of the deduplicated numbers to count and rearrange the data a bit and I have:
```
╭─              
╷          0 2  
		   2 4  
		   3 1  
		   4 1  
		   6 2  
		   7 1  
		   8 1  
		  40 2  
		  48 2  
		  80 1  
		  96 1  
		2024 1  
		4048 1  
	   14168 1  
  2097446912 1  
			   ╯
```
which looks good.

```
IsEven      ← ¬◿ 2 ⧻°⋕
FollowRules ← ⨬(⨬(× 2024|⋕ ↯ 2_∞ °⋕) ⊸IsEven|1) ⊸= 0
Count       ← /+ ▽ : = ⊃(⋅⋅⊙|⊙⊙) °⊟ ⍉ :
:°⊚⊛⟜◴ ⍆ °□ /(◇⊂ ♭) ⍚memoFollowRules [125 17]
⍥(⟜≡Count⊙¤ ⍆◴ ⟜(⍆⍉⊟) °⊟⍉/◇⊂⍚(♭₂⍉⊟) ⍚memoFollowRules)34
/+:
```

This is 35 iterations; I'm at the point with this puzzle where working out how to put the first iteration in the same format is feeling like more trouble than it's worth though!

The important question is "is this faster?". Hmmm, it's a bit faster at 4.5 seconds compared to the 7.5 seconds it was before I started.

But it still doesn't scale nicely. 40 blinks takes 37 seconds on the sample input. But I can see there's really not that many distinct numbers after that many blinks:
```
[0 1 2 3 4 5 6 7 8 9 20 24 26 28 32 36 40 48 56 57 60 67 72 77 80 84 86 91 94 96 2024 2048 2457 2608 2867 2880 3277 3686 4048 6032 6072 8096 9184 9456 10120 12144 14168 16192 18216 20482880 24579456 28676032 32772608 36869184]
```

I take the `memo` result caching function out and it makes no difference to the time. I'm not asking it to do the same calculations many times over any more so this makes sense.

This is the number data along with their counts:
```
[1534038 1067117 1578344 397114 1686318 339488 1354291 792540 1641291 744251 527557 704409 293446 191774 428736 129932 657564 714048 233336 233336 296008 135290 160718 293446 765015 129932 129932 129932 233336 708531 711206 98066 383611 465358 227270 98066 465358 208756 1022235 227270 247671 1068674 208756 383611 208262 836033 492485 1041895 458282 134894 563555 323409 694595 315137]

[0 1 2 3 4 5 6 7 8 9 20 24 26 28 32 36 40 48 56 57 60 67 72 77 80 84 86 91 94 96 2024 2048 2457 2608 2867 2880 3277 3686 4048 6032 6072 8096 9184 9456 10120 12144 14168 16192 18216 20482880 24579456 28676032 32772608 36869184]
```

I suspect my code for finding the duplicate numbers and rejigging the array is what needs speeding up now.

But I'm leaving this one here, incomplete, for now.