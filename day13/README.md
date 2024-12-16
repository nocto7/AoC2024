# day13

## Part One

Whee. Simultaneous equations to solve in order to work out how many times you need to press the two buttons to move the claw to the prize location. 

Xa A + Xb B = Xt
Ya A + Yb B = Yt

A = (Xt - Xb B)/Xa
A = (Yt - Yb B)/Ya

 (Xt - Xb B)/Xa = (Yt - Yb B)/Ya
 Ya(Xt -Xb B) = Xa(Yt - Yb B) 

Ya Xt - Xb Ya B = Xa Yt - Xa Yb B

Ya Xt - Xa Yt = Xb Ya B - Xa Yb B

B = (Ya Xt - Xa Yt)/(Xb Ya - Xa Yb)
and similarly
A = (Xb Yt - Yb Xt)/( Xb Ya -Xa Yb)

We want solutions where A and B are both integers in the range 0 to 100. And where the divisor Xb Ya - Xa Yb isn’t zero. 

### input wrangling

I'm sure there's a much smarter way to remove all the non-digit characters and get the numbers out of the input but this works, and isn't regex.

```
💾  ← &fras "example.txt"
🗒️ ← ⊜□∘¬⊸⦷"\n\n"💾

ParseLine ← (
  ⍜⊜∘≡⋅"" ⊸⦷ "Button A: X+"
  ⍜⊜∘≡⋅" " ⊸⦷ ", Y+"
  ⍜⊜∘≡⋅" " ⊸⦷ "\nButton B: X+"
  ⍜⊜∘≡⋅" " ⊸⦷ "\nPrize: X="
  ⍜⊜∘≡⋅" " ⊸⦷ ", Y="
  ⊜□∘¬⊸⦷@ 
  ⋕
)

≡◇ParseLine 🗒️
```
 to give this for the example data:
 ```
 ╭─                         
╷ 94 34 22 67  8400  5400  
  26 66 67 21 12748 12176  
  17 86 84 37  7870  6450  
  69 23 27 71 18641 10279  
						  ╯
```


which is `[Xa Ya Xb Yb Xt Yt]` in each row.

To find the number of presses required for each row I 'simply' put all six of these values on the stack and then use planet notation to do the sums:

```
SolveEq ← (
  °⊟₆ # Xa Ya Xb Yb Xt Yt

  ⊃(- ⊃(× ⊃(⋅⋅⊙|⋅⊙)|× ⊃(⊙|⋅⋅⋅⊙))         #  Xb Ya - Xa Yb 
  | - ⊃(× ⊃(⋅⋅⊙|⋅⋅⋅⋅⋅⊙)|× ⊃(⋅⋅⋅⊙|⋅⋅⋅⋅⊙)) #  Xb Yt - Yb Xt 
  | - ⊃(× ⊃(⋅⊙|⋅⋅⋅⋅⊙)|× ⊃(⊙|⋅⋅⋅⋅⋅⊙))     #  Ya Xt - Xa Yt
  )

  ⊃(÷ ⊃(⊙|⋅⊙)  # A presses
  | ÷ ⊃(⊙|⋅⋅⊙) # B presses
  )
)
```

This 
```
≡◇ParseLine 🗒️
⍉ ⊟ ≡SolveEq
```
gives me the A and B presses required for each bit of the example data:

```
╭─                                       
╷  80                 40                 
  141.40454076367388 135.3952528379773   
   38                 86                 
  244.50163627863486  65.56989247311827  
										╯
```

Now I need to filter out any non-integer values.

I calculate the *floor* of each value, ie round it down, and check if it's the same. This is easiest done at the end of `SolveEq` where the A and B press values are on the stack. This checks if the floor is the same as the value (which'll give 1) or not (which'll give 0) and then multiplies the button presses by that. So non integer values will be zero as we want.

```
⊃(×=⌊.. ⊙|×=⌊.. ⋅⊙)
```

There are several checks that I put in and take out again as they turn out not to be required. Checking the values are in the range 0 to 100. Checking the divisor isn't zero. Checking there isn't one integer solution and one not.

### ⭐️ Solution

The first time I run on the input I get an answer that's too low. I never do figure out why that is but after checking through my calculations and realising (yet again) that things like `× ⊃(⊙|⋅⋅⋅⊙)` can be reduced to the much more readable `× ⊙⋅⋅⊙` I get the right answer.

### Part Two

Oh nice, looks like I've picked the right way to do this as this just requires increasing the prize coordinates by lots.

So I'm kind of bemused that my solution doesn't just fall out straight away, apparently I'm too high.

Hmm. One to come back to and reread later, I suspect I'm missing something minor.