# day 3

[Day 3 - Advent of Code 2024](https://adventofcode.com/2024/day/3)

## Part 1

The puzzles unlock at 5am in my timezone. I'm not a speedrunner - neither in general nor specifically in a language I'm only just getting the hang of - so I'm never going to be getting up early to get straight into the puzzles. If I happen to be lying in bed awake at 5am I might just pick up my iPad and have a scan through the new puzzle before trying to get a little extra sleep though...

So today's puzzle looks like a pretty simple regex problem. Everybody stand back... I know [regular expressions](https://www.explainxkcd.com/wiki/index.php/208:_Regular_Expressions)!  

Perhaps there's a more uiua-ish way to handle it but I'll take what I already know. I open up the [uiua online pad/editor](https://uiua.org/pad?src=0_14_0-dev_5__SW5wdXQg4oaQICJ4bXVsKDIsNCklJm11bFszLDddIUBeZG9fbm90X211bCg1LDUpK211bCgzMiw2NF10aGVuKG11bCgxMSw4KW11bCg4LDUpKSIKCnJlZ2V4ICJtdWxcXCgoXFxkKyksKFxcZCspXFwpIiBJbnB1dArijYkKwrDilqEK4oaYMQrii5UKwrDiip8Kw5cKLysK) and try it out. I fight with the [regex](https://www.uiua.org/docs/regex) function a bit because it wants double escaping and my brain doesn't like that but this works to find every instance of `mul(X,Y)` in the input string. The puzzle tells me we don't want to catch anything with spaces in or worry about things like the `do_not_mul(5,5)` bit (it counts because it's got `mul(5,5)` within it).
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

Then I run through this interactively. I want to find the multiple of each of the two numbers within the `mul` functions. To get the numbers I `⍉` *transpose* the data, then `°□` *unbox* it and `↘1` *drop* the first line because I don't need the `mul(X,Y)` bits. At this point I have:
```
╭─
 ⌜2⌟ ⌜5⌟ ⌜11⌟ ⌜8⌟
 ⌜4⌟ ⌜5⌟ ⌜8⌟ ⌜5⌟
				   ╯
```
Now I only have numbers I use `⋕` *parse* to turn them into actual numbers and `°⊟` *uncouple* them to give me two arrays:
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
One star obtained easily, and I need to go and do other things before trying part two.