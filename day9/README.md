# day 9

 [Day 9 - Advent of Code 2024](https://adventofcode.com/2024/day/9)

## Part One

### input

easy input today. it's just one line and I don't need more than the basic `&fras` function to obtain it; at least to start with.

### understanding the disk map

we're defragmenting hard disks. 
```
2333133121414131402
```

represents 
```
00...111...2...333.44.5555.6666.777.888899
```

the first `2` is two blocks of data, ID number `0`
the next `3` is three blocks of space
the next `3` is three blocks of data, ID number `1`
the next `3` is three blocks of space
the next `1` is one block of data, ID number `2` 
...
the third to last `4` is four blocks of data, ID number `8`
the second to last `0` is zero blocks of free space
the last `2` is two blocks of data, ID number `9`

etc.

We want to move file blocks, one at a time, from the end of the disk to free spaces at the beginning until we have a contiguously filled disk.

Into the first 3 long space between `00` and `11` we take the `899` from the end of the disk and reverse it.
```
00998111...2...333.44.5555.6666.777.888...
```

THen there's another three blocks of space to fill with the `888` from the end of the disk, and so on.

Finally we want to calculate the checksum of the result
```
0099811188827773336446555566..............
```
This simply involves multiplying the ID number of each file by it's position on the disk, started with `0*0` `1*0` `2*9` etc on the left, and adding the numbers up.

### representing the disk

I don't feel the example representation here with `.` for free space is a sensible way to represent the data.

Every alternate space marks blocks of data. The spaces in between them represent free space.

First of all, I want to separate out the digits of the string I've been given. The string is actually an array of characters and so `≡⋕ 💾` produces
```
[2 3 3 3 1 3 3 1 2 1 4 1 4 1 3 1 4 0 2]
```

Now I want to label every other one element of this which will tell me the ID numbers of the files there. This means I want to create an array like `[0 free 1 free 2 free 3 .... 8 free 9]`. The ID numbers are all going to be positive so let's use a negative number like `-1` to represent the free spaces on the disk.

Having checked that the example and real inputs both have odd numbers of digits I can get the number of files on the disk with `⌈ ÷ 2 ⧻ .` *ceiling divide 2 length*, ie, find the length of the input, divide it by 2 and round it up. Then I can use *range* to get a list of the ID numbers from 0 to 9 (in the example).

Now I want to intersperse `-1` between the elements of this array to represent the free spaces. We can create the array to intersperse with `↯ [9] ¯1` *reshape* - this gives us an array of 9 `-1`s. Before we go any further let's put these two functions together so they both use the length of the input. The array of `-1`s is one shorter than the array of IDs so we use *floor* instead of ceiling to round down:
```
⊃(↯ : ¯1 ⌊|⇡ ⌈) ÷ 2 ⧻ .
```

This gives us these two arrays on the stack (on top of  our original input)
```
[0 1 2 3 4 5 6 7 8 9]
[¯1 ¯1 ¯1 ¯1 ¯1 ¯1 ¯1 ¯1 ¯1]
```
I feel like interspersing these should be simple in uiua. And when I find out how to do it I've already made it more complicated than it needs to be! `/(⊂⊂)` *reduce join join* intersperses one array with another, repeating one array if it runs out, so all I need is:

```
/(⊂⊂) ¯1 ⇡ ⌈ ÷ 2 ⧻ .
```
to create 
```
[0 ¯1 1 ¯1 2 ¯1 3 ¯1 4 ¯1 5 ¯1 6 ¯1 7 ¯1 8 ¯1 9]
```

Then if I couple this with my input digits and transpose I get:
```
╭─      
╷  0 2  
  ¯1 3  
   1 3  
  ¯1 3  
   2 1  
  ¯1 3  
   3 3  
  ¯1 1  
   4 2  
  ¯1 1  
   5 4  
  ¯1 1  
   6 4  
  ¯1 1  
   7 3  
  ¯1 1  
   8 4  
  ¯1 0  
   9 2  
	   ╯
```
representing the disk structure.

### working through the algorithm
My query here is whether I try and rearrange the files into order or just calculate the checksum for them as I go. Let's think about what happens and work through the algorithm.

First file is ID 0, size 2. Checksum is `[0 1]`, that's the range of the size 2,  multiplied by ID `0`, and summed. That's *`/+ *` `ID` range `size`*. Then we're finished with the first file and can remove the element from the array; and just hold on to the sum of `0` and the fact that we've filled two blocks on the disk.

Now we have a space of 3. We know it's a space because the `ID` column is -1. We look at the last element of the array which is ID 9, size 2. Since 2 is less than 3 we can take the whole file to fill the first two of the three spaces.
The contribution to the checksum here will be `[2 3]` the range of the size 2, plus the position on the disk, multiplied by the file ID 9, and summed. That's going to be *`/+ * ID + position `range `size`* I think in uiua reverse operation order. We need to make sure we've accounted for having used up 2 of the 3 blocks of free space by changing the first element of the array to `[-1 1]`. Then we can remove the last element of the array `[9 2]` and just hold on to the sum we've calculated and the fact that we've filled four blocks of the disk now.

Now we have `[-1 1]` at the start of our array and look for a file to fill it with from the end. The last section of the disk now is `[-1 0]`, empty space so we can just ignore it. We look at `[8 4]` instead. This is a longer file than we can fit into our 1 space so we leave `[8 3]` behind at the end of the array and take `[8 1]` to replace our `[-1 1]` at the beginning of the array. Now we have file ID 8 in 1 block at position 4 (the fifth position) on the disk so the sum is `* 8 4`

Now I have a feel for the algorithm I'll start trying to put it into code.

### coding this up
To calculate the checksum I need to know the file ID, the size of the file, and the block position on the disk we start at. The file ID and size I already have in my array. Let's put the position on the stack above the disk representation array.

Let's deal with the first file by `°⊂` *unjoin*ing it from the representation of the disk. Then use the *`/+ * ID + position `range `size`* function to calculate it's checksum. For this I need the ID, position and size. The position is at the bottom of my stack, the ID and the size are coupled in the row I just unjoined from the big disk representation. Let's uncouple them so I have three variables on the stack as well as the disk representation.

My stack is now:
```
0
╭─      
╷ ¯1 3  
   1 3  
  ¯1 3  
   2 1  
  ¯1 3  
   3 3  
  ¯1 1  
   4 2  
  ¯1 1  
   5 4  
  ¯1 1  
   6 4  
  ¯1 1  
   7 3  
  ¯1 1  
   8 4  
  ¯1 0  
   9 2  
	   ╯
2
0
```

- 0 bottom of stack, position (4th)
- array representing rest of disk (3rd)
- size of file (2nd)
- id of file, top of stack (1st)

Let's bring the three items I need for the checksum calculation to the top of the stack, first the size, then the position, then the ID. These are the 2nd, 4th and 1st items on the stack, then we leave the 3rd item below them.
```
⊃(⋅⊙|⋅⋅⋅⊙|⊙|⋅⋅⊙)
```

Now we can do *range*, add on the position, multiply by the file id, add that all up.
```
/+×+⇡
```
which gives us the answer, zero, on top of the stack.

We want to hold onto two things, this answer and the position we're up to. I feel like thinking of these as variables is probably un-uiua-ish but can't see how else to do it at the moment. Let's make these always the bottom two things on our stack so they both start as 0, and update the position as we do the sum. This fork is now looking pretty alarming so I've added a comment to show the order of the elements in it
```
⊃(⋅⊙|⋅⋅⋅⊙|⊙|⋅⋅⊙|+⊃(⋅⋅⋅⊙|⋅⊙)) # size, pos, id, disk, updated pos
```

Now I want to update the checksum, which is at the very bottom of the stack below the updated position.
```
⊃(⋅⊙⊙|+⊃(∘|⋅⋅⋅⊙))
```

After this my stack has returned to the order it started in 
- checksum (bottom)
- position we're up to
- array representing rest of disk

Let's put this all into a function that processes the first file on the disk, after the first element has been unjoined and uncoupled:
```
ProcessFirst ← (
  ⊃(⋅⊙|⋅⋅⋅⊙|⊙|⋅⋅⊙|+⊃(⋅⋅⋅⊙|⋅⊙)) # size, pos, id, disk, updated pos
  /+×+⇡
  ⊃(⋅⊙⊙|+⊃(∘|⋅⋅⋅⊙))
)
```

Now we want to find out how much space we have at the beginning of the disk. As before we'll *unjoin* and *uncouple*. The first element is the `-1` telling us this is free space, for now we'll just *pop* it to remove it from the stack, leaving the control logic for later.

I also want the last row of the array to compare it to the available space. Let's flip the top two elements so my stack is
- checksum (bottom)
- position we're up to
- free space available in this section
- array representing rest of disk

Then I can use *under reverse unjoin* to get the last element of the disk array; and *uncouple* it to get the components on the stack separately.
- checksum
- position
- space
- array
- file size
- file id

Now I want to compare how much space I have to fill to the file I've just taken from the end. The file size is 2nd on the stack,the space is 4th on the stack. I want to end up with
- checksum
- position
- array
- remaining space (space - filesize)
- file size
- file id

This is `⊃(⊙⊙|-⊃(⋅⊙|⋅⋅⋅⊙)|⋅⋅⊙)` on the above stack. 


If the remaining space is positive I'll put the whole file into the space and put the remaining space back on the front of the array.
If the remaining space is zero, do nothing special.
If the remaining space is negative, I'll put the remains of the file back on the end of the array.

Remaining space is the third thing on the stack, let's pull it to the top. `⊃(⋅⋅⊙|⊙⊙)` rearranges 3rd to top.

Now this is where I'll *switch* on whether this is positive or negative. For now just test it and pop the test result from the top of the stack.

In this case the space is too big for the file. The test is positive.

I want to create the file to go onto  the front of the array, that'll be `[9 2]` and the leftover space I haven't filled `[-1 1]`.

My stack is:
- checksum
- position
- array
- file size
- file id
- leftover space

Put `-1` on the stack and couple it  `⊟ ¯1` to get `[¯1 1]` to put back on the front of the array.

So this is *join*ing the element on the top of the stack to the array that's now 4th on the stack. `⊂⊃(∘|⋅⋅⋅⊙)`, then this turns into  `⊃(⋅⊙⊙|⊂⊃(∘|⋅⋅⋅⊙))` as we keep the file id and file size on top of the stack.

Now we *couple* the file id and file size on top of the stack to get `[9 2]` and put those back onto the front of the array.

Now we are back in the same situation we had earlier with
- checksum
- position
- array

And our `ProcessFirst` function should be able to calculate the next bit of the checksum. This should add 2x9 and 3x9 to the sum. Yes, it adds 45, and updates the position of blocks used to 4. 🥳

My code at this point is looking a bit of a mess and I want to tidy it up before going any further
```
💾 ← &fras "example.txt"

Disk ← ⍉ ⊟ /(⊂⊂) ¯1 ⇡ ⌈ ÷ 2 ⧻ . ≡⋕
ProcessFirst ← (
  ⊃(⋅⊙|⋅⋅⋅⊙|⊙|⋅⋅⊙|+⊃(⋅⋅⋅⊙|⋅⊙)) # size, pos, id, disk, updated pos
  /+×+⇡
  ⊃(⋅⊙⊙|+⊃(∘|⋅⋅⋅⊙))
)

Disk 💾 0 0 # disk, pos, sum
ProcessFirst °⊟ °⊂

: ◌ ? °⊟ °⊂ # XXX pop because the first element is -1 representing space
⍜⇌ °⊂
°⊟
?
⊃(⊙⊙|-⊃(⋅⊙|⋅⋅⋅⊙)|⋅⋅⊙)
⊃(⋅⋅⊙|⊙⊙)
◌ ≤0 . # switch goes here
⊟ ¯1
⊃(⋅⊙⊙|⊂⊃(∘|⋅⋅⋅⊙))
⊂ ⊟
°⊟ °⊂
ProcessFirst
```

First of all at the point I've labelled XXX I pop the first element off the stack because it's a -1 representing free space. What I want to do here is *switch*. If the value is negative then this is free space, otherwise if it's positive I want to use my `ProcessFirst` function to update the checksum.

### time passes...

I did a lot of refactoring and debugging without taking any notes. 

I discovered you can subscript the stack operator to just look at the top n items on the stack. `?₂` 

Also made a lot of use of `&p "stuff"` to print out things to figure out where things were going wonky.

The algorithm seemed a lot simpler when I finally got all the pieces in place!

### ⭐️ Solution

Happy to be done with that, and though part two doesn't look super complicated at first glance I'm not going to try it yet.