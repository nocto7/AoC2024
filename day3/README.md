# day 3

[Day 3 - Advent of Code 2024](https://adventofcode.com/2024/day/3)

## Part 1

The puzzles unlock at 5am in my timezone. I'm not a speedrunner - neither in general nor specifically in a language I'm only just getting the hang of - so I'm never going to be getting up early to get straight into the puzzles. If I happen to be lying in bed awake at 5am I might just pick up my iPad and have a scan through the new puzzle before trying to get a little extra sleep though...

So today's puzzle looks like a pretty simple regex problem. Everybody stand back... I know [regular expressions](https://www.explainxkcd.com/wiki/index.php/208:_Regular_Expressions)! 

Perhaps there's a more uiua-ish way to handle it but I'll take what I already know. I open up the [uiua online pad/editor](https://uiua.org/pad?src=0_14_0-dev_5__SW5wdXQg4oaQICJ4bXVsKDIsNCklJm11bFszLDddIUBeZG9fbm90X211bCg1LDUpK211bCgzMiw2NF10aGVuKG11bCgxMSw4KW11bCg4LDUpKSIKCnJlZ2V4ICJtdWxcXCgoXFxkKyksKFxcZCspXFwpIiBJbnB1dArijYkKwrDilqEK4oaYMQrii5UKwrDiip8Kw5cKLysK) and try it out. I fight with the [regex](https://www.uiua.org/docs/regex) function a bit because it wants double escaping and my brain doesn't like that but this works to find every instance of `mul(X,Y)` in the input string. The puzzle tells me we don't want to catch anything with spaces in or worry about things like the `do_not_mul(5,5)` bit (it counts because it's got `mul(5,5)` within it).[^3]
```
Input ← "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

regex "mul\\((\\d+),(\\d+)\\)" Input
```

This gives me the data I want:
```
╭─
 ⌜mul(2,4)⌟ ⌜2⌟ ⌜4⌟
 ⌜mul(5,5)⌟ ⌜5⌟ ⌜5⌟
 ⌜mul(11,8)⌟ ⌜11⌟ ⌜8⌟
 ⌜mul(8,5)⌟ ⌜8⌟ ⌜5⌟
                      ╯
```

Then I run through this interactively. I want to find the multiple of each of the two numbers within the `mul` functions. To get the numbers I `⍉` *transpose* the data, then `°□` *unbox* it[^1] and `↘1` *drop* the first line because I don't need the `mul(X,Y)` bits. At this point I have:
```
╭─
 ⌜2⌟ ⌜5⌟ ⌜11⌟ ⌜8⌟
 ⌜4⌟ ⌜5⌟ ⌜8⌟ ⌜5⌟
                   ╯
```
Now I only have numbers I use `⋕` *parse* to turn them into actual numbers and `°⊟` *uncouple*[^2] them to give me two arrays:
```
[4 5 8 5]
[2 5 11 8]
```
which can simply be `×` *multiplied* and the result added together with our new best friend `/+` *reduce add* to give the example answer of 161.

### Altogether
this is the whole solution put together on one line, where 💾 is the input text.
```
📩 ← /+×°⊟⋕↘1°□⍉ regex "mul\\((\\d+),(\\d+)\\)" 💾
```

And I feel like this code can probably be compacted further.
### Actual input

I tried to get the actual input into the uiua pad to attempt to get an early answer but was first annoyed by my aging iPad's inability to select and paste correctly and then foxed by the pad not liking the line length so I gave up and got another couple of hours sleep.

Once I was awake I set the input file up with the real data. I did wonder if the multiple lines in the real data file would cause a problem but it all worked.

### ⭐️Solution
One star obtained easily 😃

### Afternotes
On looking more at my own solution and other people's too I noticed a few things which I've noted by footnotes which reduce the code to:
```
⏱️ ← /+/×⋕↘1⍉ regex "mul\\((\\d+),(\\d+)\\)"
```
And I also gave the function a different name ⏱️ in order to easily reuse it in part two.
## Part 2

For the second part of the puzzle we want to use the same data and handle it in the same way except we need to take note of `do()` and `don't()` instructions in the text.

The example text has changed slightly (but the real input text hasn't). Maybe someone forgot to update the first bit of example text when they were writing the puzzle, or maybe they just felt like throwing in some extra quotes to confuse people but it doesn't make any difference to anything.
```
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
```

### ignoring from `don't()` to `do()`

Anything after `don't()` should be ignored until the next time we see `do()`.

I could regex this again but let's try and do it in a uiua specific way instead. I want to ignore anything from a `don't()` instruction until the next `do()` instruction.

I can use `⦷` *[mask](https://www.uiua.org/docs/mask)* to split the string up at each instance of `don't()`; this follows the example in the docs to `⊜` partition a string by another string except that I need to box my results as the strings are different lengths. I've called this function `⛔️` as it's telling us what NOT to do.

```
⛔️ ← ⊜□∘¬⦷ "don't()" . 
```

⛔️💾 then gives (💾 is the input string read from the file)
```
{"xmul(2,4)&mul[3,7]!^" "_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"}
```

Now I want to partition each of these by `do()` and throw away the first part of each string. If there's more than one `do()` in the string it doesn't matter, I still only want to throw away the part before the first `do()`.

Let's practice this with the second element of our array. The function should be similar to the `⛔️` one
```
✅     ← ⊜□∘¬⦷ "do()" .
```

This gives us 
```
{"_mul(5,5)+mul(32,64](mul(11,8)un" "?mul(8,5))"}
```

I almost just went off and dropped the first element of the array. But that wouldn't work if we'd used the first element we had which didn't have a `do()` in it. We only want to drop the first element if there are at least two parts.

But hang on, at the end of the string we might have a `don't()` call with no `do()` call after it which will also result in a single element but that time we do want to drop the first and only element.

So do I need to make special cases of the first and last parts of the input or am I doing it backwards? If I first split on `do()` then I'll always want to do things I find first until I find a `don't()` in which case I can drop the rest of the string entirely. Yes, it makes more sense to do the partitioning that way around!

### selecting from `do()` to `don't()`
```
✅  ← ⊜□∘¬⦷ "do()" .
```

this will give us a string where we always want to do multiplications on the first part, and want to drop anything after the first `don't()` we find. At first we get:
```
{"xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)un" "?mul(8,5))"}
```

Then we want to use the same `⛔️` function as above but add `↙ 1` *[take](https://www.uiua.org/docs/take) 1* to just keep the first row. (But *keep* is a different uiua function that does something different!) 
```
⛔️ ← ↙ 1 ⊜□∘¬⦷ "don't()" .
```

 Now I use `≡◇⛔️✅💾` to run the ⛔️ function over each row of the result I get from ✅💾, *[content](https://www.uiua.org/docs/content)* unboxes the arguments to the ⛔️ function before calling it, and `≡` *[rows](https://www.uiua.org/docs/rows)* applies the function to every row of the array. The result from that is:
 ```
 ╭─                        
╷ ⌜xmul(2,4)&mul[3,7]!^⌟  
  ⌜?mul(8,5))⌟            
                         ╯
```
 
Now I can see I have the right bits of the input isolated and now need to run the ⏱️ function I wrote to run the `mul(X,Y)` function on each row of this.

This is an example of something that's really confusing me in uiua at the moment. It looks to me as if I have an array of boxed strings. So I think I want to use *rows content* again to send these to the ⏱️ function. But this tells me I'm trying to do the *regex* on a box rather than a string? Have I got two levels of boxing here? I mess around with combos of *rows*, *content*, and *inventory* without finding the answer. Time to head over to the uiua discord and ask for assistance!

*...A few minutes later...* (the uiua discord is very friendly and helpful btw, and also super responsive!)

My mistake was using `↙ 1` *[take](https://www.uiua.org/docs/take) 1* rather than `⊢` *[first](https://www.uiua.org/docs/first)* to get the first row of the array. When I switch to using `⊢` instead in the ⛔ function the result is 
```
{"xmul(2,4)&mul[3,7]!^" "?mul(8,5))"}
```
If you check the `△` [shape](https://www.uiua.org/docs/shape) of this array it's `[2]` showing that it has two rows, which is what I want. The `△` shape of the array I got with the `↙ 1` *take 1* version is `[2 1]`. This is because `↙` *take* can take more than one row so it gave me a two-dimensional box. Now I know what was wrong that seems obvious to me from the way uiua has printed out the strings but I'm not familiar enough with the notation to have noticed that yet.

Now I can do what I want to do and finish off the solution with `/+≡◇⏱️` to find the multiples using the content of each row and add them together.

### ⭐️⭐️ Solution

Happily that all worked with the real input and I have two gold stars for day 3.

[^1]: This unboxing was unnecessary and can be removed.
[^2]: It's not necessary to uncouple before multiplying either. I missed that you can use `/×` *reduce multiply* to multiply the rows of the array together.
[^3]: I missed that the puzzle mentioned that all the numbers to be multiplied were 1 to 3 digit numbers. The `+` in my regex is looking for series of one or more digits, fortunately the puzzle input wasn't tricksy enough to give any 4+ digit numbers so it all worked out. Replacing the `+` by `{1,3}` would have restricted the matches to only allowed numbers though.