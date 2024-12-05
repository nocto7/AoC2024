# day 5

[Day 5 - Advent of Code 2024](https://adventofcode.com/2024/day/5)

## Part One

Today the elves are having printer problems and of course it's the programmer's job to fix the printer.

We have data laid out like this
```
47|53
97|13
97|61
97|47
75|29
```
which specifies the rules which are that page 47 must be printed before page 53; page 97 must be printed before page 13 and so on. 

And then we have sets of ordered page numbers, for example
```
75,47,61,53,29
97,61,53,29,13
75,29,13
```
and the elves want to know if the orderings meet the rules. And then they want the middle page number of every correct ordering added together.

My first observation is that some of the rules give multiple constraints for the same page. Just the sample above shows that page 97  needs to come before page 13, page 61 and page 47. And it's not clear if there's one correct ordering of all the pages but I suspect there is not and going down the route of trying to put the numbers into a canonical order to check the subsets against will result in loopy madness.

So looking at the first data set, we want to look for any rules containing page 75 on the left hand side and check that each page after it either conforms to the rules or doesn't have a rule.

The instructions for the puzzle seem to have some redundancy in them, we only need to check one way through the ordering of pages. I don't think the checks I've crossed out are necessary as they've already been used.

>
> - `75` is correctly first because there are rules that put each other page after it: `75|47`, `75|61`, `75|53`, and `75|29`.
> - `47` is correctly second because ~~75 must be before it (`75|47`)~~ and every other page must be after it according to `47|61`, `47|53`, and `47|29`.
> - `61` is correctly in the middle because ~~75 and 47 are before it (`75|61` and `47|61`)~~ and 53 and 29 are after it (`61|53` and `61|29`).
> - `53` is correctly fourth because it is before page number 29 (`53|29`).
> - `29` is the only page left and so is correctly last.

On second thoughts I realise that these checks are backwards to how I'd do it. Thinking about the algorithm to do these checks.

It's informative to try an algorithm out on a case where it fails so let's look at the page numbers `75,97,47,61,53`

- `75` is the first page, just ignore this as a one page sequence can't be wrong
- `97` there are several rules about the placement of page `97`, one of which is `97|75` but since we've already seen page `75` printed this sequence of pages is incorrect.




### input wrangling

Today we have two separate sets of data separated by a blank line. So first I parse the input breaking it at the double newline character; then I *uncouple* the two separate pieces so I can handle them separately. The second one I parse to get an array of boxed strings representing the page orders; the first I want to turn into an array.

#### Parsing the rules.
It's (by now) simple to get the rules into this format with `⊜∘¬⊸⦷@\n°□`
```
╭─         
╷ "47|53"  
  "97|13"  
  "97|61"  
  "97|47"  
  "75|29" 
```

but using *partition* again to split out the `|` on each row doesn't work as I expect as `⊜□≠@|.` tries to split the whole array down the middle and gives me two very long numbers rather than lots of short ones. Writing this sentence out however makes me realise that I want to do this **on each row**. (This is (one of the reasons)why I take ridiculously verbose notes btw.) `⋕≡(⊜□≠@|).` *partitioning* the *rows* and then parsing them is what I want.

```
╭─       
╷ 47 53  
  97 13  
  97 61  
  97 47  
  75 29 
```

I could do something similar with the page numbers but since they are different lengths I suspect I'm better leaving them to parse as required.

I can certainly put this data into a better format to use later.

First of all I can `⍆` *sort* it, which makes it more human readable at least, the array then starts
```
╭─       
╷ 29 13  
  47 13  
  47 29  
  47 53  
  47 61  

```

This human can now see there are four different page numbers that need to come after page 47. What I want is to put them together so that I can check if all the pages that come after before any page 47 I find in the lists are in the list of pages that should only come after it.

I found it easiest to handle this data by transposing and uncoupling it to give two arrays representing the before and after page numbers:

```
[13 13 29 53 61 13 29 13 29 53 13 29 47 53 61 13 29 47 53 61 75]
[29 47 47 47 47 53 53 61 61 61 75 75 75 75 75 97 97 97 97 97 97]
```

And after the last couple of days problems it I could remember how to filter this using, eg
```
▽ ≠ 0 . × ⌕ 47
```
to find the pages that have to come after page 47, namely `[13 29 53 61]`.

Now I want to do that for every value in the left hand column, that is every page number that has a restriction on certain pages needing to not come before it. I use *keep unique* to get these; but the compiler advices me to `Prefer ◴ deduplicate over ▽◰`. Happy to oblige.

Now my stack has four items on it and this, appropriately, starts to feel like too many balls to juggle!
```
{"75,47,61,53,29" "97,61,53,29,13" "75,29,13" "75,97,47,61,53" "61,13,29" "97,13,75,29,47"}
[13 13 29 53 61 13 29 13 29 53 13 29 47 53 61 13 29 47 53 61 75]
[29 47 47 47 47 53 53 61 61 61 75 75 75 75 75 97 97 97 97 97 97]
[29 47 53 61 75 97]
```

For each item in the array on top of the stack (the 'top' is at the bottom of the listing here) I want to find the pages using the second and third items on the stack.

I turn the filter above into a function
```
FindAfterPages ← ▽ ≠ 0 . × ⌕
```
And then I'm back to the by now familiar problem of wanting to use an array for something that worked with a scalar.
Rather than `FindAfterPages n array` I want to use an array of `n`s. This was the pattern I saw yesterday where the advice was to use `≡F ⊙¤` where `F` is the function name.

*fix*ing my array `[29 47 53 61 75 97]` takes it from having a *shape* of `[6]` to a *shape* of `[1 6]`.

but `≡FindAfterPages ⊙¤` gives me an error `Cannot ≡ rows arrays with different number of rows, shapes [6] and [21]`. The rows bit should only be working on the 6 length array. So `FindAfterPages` is taking two arguments. 

Last time I played with uiua there was a *signature* function that would tell you how many arguments a function would take and return. That's now deprecated and the compiler suggests using `(⋅⊢)^!` instead. I'm not going to investigate how that works right now but I have used it and it tells me that `FindAfterPages` has a signature of `[3 1]`. It takes three things in and returns one. Yes, it's taking three things in the value to search for itself and the two uncoupled parts of the rules array.

Changing the function to take only two arguments seems to be the simplest way forward. I put the part that uncouples the rules array inside the function.
```
FindAfterPages ← □ ▽ ≠ 0 . × ⌕ ⊃(∘|°⊟⍉⍆⋅⊙)
```

But actually this doesn't help because I still need to do the bit where I find the pages with restrictions on what can come after them.

To get both things I need some more *fork*ing
```
≡FindAfterPages ⊙¤ ⊃(◌:◴ ?°⊟⍉⍆|∘)
```

Now this gives me the list of pages I want but I realise I've lost the essential info of what page they must come after!
```
{[13] [13 29 53 61] [13 29] [13 29 53] [13 29 47 53 61] [13 29 47 53 61 75]}
```

I haven't yet done much with the stack manipulation functions other than `:` *flip*. It turns out I want to preface my *rows* with `⟜` *[on](https://www.uiua.org/docs/on)* which calls a function but keeps its value on top of the stack. Now I have this on top of my stack.

```
{[13] [13 29 53 61] [13 29] [13 29 53] [13 29 47 53 61] [13 29 47 53 61 75]}
[29 47 53 61 75 97]
```
which is in the right format for a call to *[map](https://www.uiua.org/docs/map)* to 'just work' as I expect. 🎉
```
╭─                          
  29 → ⟦13⟧                 
  47 → ⟦13 29 53 61⟧        
  53 → ⟦13 29⟧              
  61 → ⟦13 29 53⟧           
  75 → ⟦13 29 47 53 61⟧     
  97 → ⟦13 29 47 53 61 75⟧  
						   ╯
```

### Applying the rules
Now I have the list of the pages that the elves gave me, and the map I've made of the rules.

So let's try and check a single set of pages starting with one we know will fail `"75,97,47,61,53"`

This is more input wrangling really, but I'm definitely getting the hang of it. *parse* what you get from *partition*ing what's *not equal* to *@,*. (Note to self: Why does it need the box in there? )
```
⋕⊜□≠@, . "75,97,47,61,53"
```
This gives us the array of page numbers in order: `[75 97 47 61 53]`

For each one we want to check, using our map, that none of the numbers before it are a problem. So `75` has no numbers before it so no problem. `97` has `75` before it which **is** in the list on the map with key `97` so it should fail.

For each number in the list I want to use the numbers before it. It occurs to me now that it makes sense to start at the end of the list. Split `53` off the end, check if any of `75 97 47 61` are not allowed to come before `53`. They are all fine. Discard the `53`. Split `61` off the end, check if any of `75 97 47` are not allowed to come before `61`. Also all fine. Etc. In this example it's not until we get to splitting `97` off the end and leaving `75` behind that we find `75` can't come before `97` but I don't think there's any reason the processing is better done forwards or backwards along the lists.


So if I *reverse* the list of numbers I can *unjoin* the last element to separate it. (Reversing? Would i be better off going forwards through the list? I feel like reversing something is necessary so I'll carry on this way for now.)

Now I want to grab the possible pages that can't come before `53` from our map, they are `[13 29]` and check none of the pages we actually have `[61 47 97 75]` are in that list. This is what *[memberof](https://www.uiua.org/docs/memberof)* does. So if I sum whatever I get out of that, if it's zero it means everything is ok. It'll be positive if the numbers were found.

I write a few tests just to check my understanding of *memberof* is correct:
```
IncorrectPage  ← >0/+∈

┌─╴Test
  ⍤⤙≍ 0 IncorrectPage [61 47 97 75][13 29]
  ⍤⤙≍ 1 IncorrectPage [61 47 97 75][17 61 29]
  ⍤⤙≍ 1 IncorrectPage [61][17 61 29]
  ⍤⤙≍ 1 IncorrectPage [17 61][17 61 29]
  ⍤⤙≍ 1 IncorrectPage [17 61 29][17 61 29]
  ⍤⤙≍ 0 IncorrectPage [17 61][]
  ⍤⤙≍ 0 IncorrectPage [][]
  ⍤⤙≍ 0 IncorrectPage [17 81 23][]
  ⍤⤙≍ 0 IncorrectPage [][17 81 23]
└─╴
```

`0` tells me there are no elements in common between the two arrays, `1` tells me there are matching elements which will mean I want to reject this set of pages.

Now I feel like this is an occassion where I actually want to loop. `⍢` *[do](https://www.uiua.org/docs/do)* "repeat a function while a condition holds" looks like what I want. If the result of checking for incorrect pages is 0, meaning no incorrect pages have been found, then we want to remove the last page and carry on checking the earlier pages.

Getting the details right here is important. We need to leave the stack with the same number of things on it as we started with.

The top two items on the stack are the list of pages I'm checking and the map. At the end of the loop I want to have a one shorter stack of pages and the map. And at the moment `IncorrectPage °⊂⇌ .` leaves an extra 0 on top of the stack. Which is what we're going to use to check if the loop is finished, so that'll get consumed and all is ok.

Once I've checked if the page is incorrect I need to pop it from the end of the stack if it's correct before going onto the next iteration of the loop.

So we want `do(loopFunction|condition)` and the if the condition is true the output is passed back to the loopFunction. Each time I want to remove an element from the end of the array if it was correct. So if I stick a 1 element back on the end if it's incorrect then those should be things I can test against.

First of all, I was getting ahead of myself there, I want to get the rules from the map to check against. On the stack I have the 
- page ordering (top)
- map (bottom)

So I *unjoin reverse* and then my stack is
- last page (top)
- rest of pages
- map (bottom)
I want to get the rule for the last page from the map, then run `IncorrectPage` on the rest of pages and the rule. And at the end of it I want to be back in a state with the  rest of pages and the map so I can check the next page in the same way.  So how to do this with stack manipulation...

if I do *dip over* then I have
- last page (top)
- map (duplicate copy)
- rest of pages
- map (bottom)

That's the right things on the top of the stack to use *get* to get the rule I want out of the map
- rule for last page (top)
- rest of pages
- map (bottom)

Now if I *flip over* I have
- rule for last page (top) (do I need to unbox this? yes, I do.)
- rest of pages (duplicate copy)
- rest of pages
- map

And I can call incorrect page on the top two items to get
- result of whether the page is correct or not
- rest of pages
- map

Now I want to do something depending on what this value is
- 0 pop it off the stack
- 1 add it to the start of the array

Handily that will work nicely with a *[switch](https://www.uiua.org/docs/switch)* statement. Switch uses the nth argument depending on what the value on the top of the stack is, then it consumes that value. So the 0th thing here is just the identity, I don't need to pop. And for the second argument I might as well just return a value that means things are wrong, eg `[-1]`.

```
⨬(∘|[¯1])
```
And then I *reverse* the rest of the pages to put them back in the correct order.

So, I have a CheckPage function that I can run multiple times in a row
```
CheckPage ← ⇌ ⨬(∘|1) IncorrectPage °□:,get⊙, °⊂ ⇌
```

I want to keep checking the pages until I get to an array with a single element in it. This'll either be the first page number, or a ¯1 showing that the ordering is wrong.

```
⟜⍢(CheckPage|¬≍1⧻)
```
*on* is used to do the repeated checks but keep the first argument on top of the stack.

so the stack is now
- original list of pages
- result of page checks, a 1 length array containing `[¯1]` or `[first page number]`
- map

*flip* the top two items
*reduce add* to get the single array item as a scalar (undoubtedly a better way to do this but my brain is giving up for today now)
check if it's *>0* to get a boolean
now use *switch* again to get 0 or the middle page number.

And now rather than just checking a single set of pages we want to check every set of pages we've been given. So I create a function 
```
GetScore ← (
  :⟜⍢(CheckPage|¬≍1⧻)
  ⨬(0|MiddlePageNumber) >0/+
)
```

For a single set of pages I get the correct result using
```
GetScore GetPages "75,47,61,53,29"
```

So to get the scores for all pages it's back to *rows* and *fix*ing things so that that works. Except, this time it's not.

My `GetPages` function has everything in boxes, I want to unbox each row, carry out `GetPages` and then rebox the results since they are all different lengths of array. This calls for `⍚` *[inventory - Uiua Docs](https://www.uiua.org/docs/inventory)* which is similar to *rows* but different in that it "Applies a function to each unboxed row of an array and re-box the results".

After this I have an array of lists of pages on the stack, followed by my map of rules. If we grab the first item, unbox it and try to `GetScore` it works as expected.

```
GetScore °□⊢
```

Yet again we just need to make this pervasive to get to our answer. But the GetScore function we created takes 3 inputs and gives back 2, which causes problems. It takes a page list and a map of rules, but hands back an answer, a page list and a map of rules. I don't think we need the page list because the function is already telling us the value of the middle page (or 0). So as the last thing in that function we flip the top two things on the stack and discard *pop* the list of pages. Which I can't get to work first time so I go and play with the easy thing I left myself for later. 

Working out the middle page number of an array. This finds the *length* of the array, divides it by 2, rounds it down with *floor* and *pick*s that element out of the array. Nice to find something I can write in uiua without thinking too hard!

```
MiddlePageNumber ← ⊡ ⌊ ÷ 2 ⧻ .
```

Time to debug to get over the final hurdle.

My stack looks like this:
```
╭─                          
  29 → ⟦13⟧                 
  47 → ⟦13 29 53 61⟧        
  53 → ⟦13 29⟧              
  61 → ⟦13 29 53⟧           
  75 → ⟦13 29 47 53 61⟧     
  97 → ⟦13 29 47 53 61 75⟧  
						   ╯
{[75 47 61 53 29] [97 61 53 29 13] [75 29 13] [75 97 47 61 53] [61 13 29] [97 13 75 29 47]}
```

- boxed array of page numbers on the top
- map of rules on the bottom
If I take the first element from the array of page numbers and unbox it I can run `GetScore` on it and get the right answer. The error message I'm getting when I try and use *inventory GetScore* is that the *get* call in `CheckPage` is looking at a value that's not a map. So my stack is wrong somewhere. I notice that the error message is
```
in CheckPage at part1.ua:12:7 ×2
```

is that `x2` telling me something? That's it's happening in the second iteration maybe? (no, it's not getting that far) I can get a stacktrace from just before the error and there's no sign of a map on the stack there. Hmmm.

The stack as the `GetScore` function is entered is 
```
├╴[13]

├╴[75 97 47 61 53]
```

which is the first element of the page order list, that's what I want, but also the first value in the map, which isn't what I want! I want the whole map to go into the function. So I do want *fix* but on the map, that will require a *flip fix flip* to get the second element on the stack fixed.

Now I can see my code getting further but I have a new error message: "Key not found in map" so there are page numbers here that don't have any restrictions on them. I'm going to need to do something to get past this. The docs has answers, I pick to do *fill 0* to get 0 back if the key is missing.

Finally it's time for *reduce add* to add up the middle page numbers and give the elves their answer.

### ⭐️ Solution
I should have taken all my stack traces out before running on the real input but I get the right answer first time.

I'm not trying Part Two yet.