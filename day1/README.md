
## day 1

[Day 1 - Advent of Code 2024](https://adventofcode.com/2024/day/1)

## example input
```
3   4
4   3
2   5
1   3
3   9
3   3
```

## Part 1
1. get left and right lists from the input
2. sort each list into numerical order
3. find the sum of the differences between each pair of numbers

### first, do the fun bit and solve the problem

#### sort each list into numerical order

if the input is
```
[3 4 2 1 3 3]
[4 3 5 3 9 3]
```

then we want to sort each array into order
`⍆:⍆` *sort flip sort*

which gives
```
[3 3 3 4 5 9]
[1 2 3 3 3 4]
```
(no need to flip back as we only care about differences)

#### find sum of the differences between each pair of numbers

then just subtract one array from the other, absolute value everything to get distances, and add up
`/+⌵-` *reduce add abs subtract*

### solution (without input)
 `📩 ← /+⌵-⍆:⍆`

### then, wrangle the input

#### 💾 (reads the file in)
- `&fras` file - read all to string

#### 📋 (get the data out of the file)
- `⊜□¬ ⊸⌕ "\n"` *partition box not by find "\n"*
- splits input into separate lines
- puts each line into a box
- result is `{"3   4" "4   3" "2   5" "1   3" "3   9" "3   3"}`

#### 🗒️ (parse one row of the input)
- given a single row of that array (eg `⊢` *first*) I can split it by spaces and parse it, use `⋕ ⊜□¬ ⊸⌕ " " °□` to turn it from `{"3   4"}` into `[3 4]`

#### ≡🗒️📋💾
- ≡ *rows* does the parsing on every line of the input 
- result is

```
╭─     
╷ 3 4  
  4 3  
  2 5  
  1 3  
  3 9  
  3 3  
	  ╯
```

#### reformat this into what we wanted
- `°⊟⍉` *uncouple* *transpose*
this gives the input in the form I wanted to start with, hurray!
```
[4 3 5 3 9 3]
[3 4 2 1 3 3]
```


### ⭐️ Solution
Using real input `📩°⊟⍉≡🗒️📋💾` gave the correct solution.
