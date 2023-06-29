__includes ["distribution-utils.nls"]

patches-own [
  value
  weight
]

to colour-patches [value?]
  let mn min [ifelse-value value? [value] [weight]] of patches
  let mx max [ifelse-value value? [value] [weight]] of patches
  ask patches [
    set pcolor scale-color blue (ifelse-value value? [value] [weight]) mx mn
;    set plabel-color orange
;    set plabel ifelse-value value? [precision value 3] [precision weight 3]
  ]
end

to update-displays [value?]
  colour-patches value?
  set-current-plot "Distribution"
  set-current-plot-pen "histogram"
  set-plot-x-range floor min [value] of patches ceiling max [value] of patches
  set-plot-y-range 0 1
  set-histogram-num-bars 15
  histogram [value] of patches
end

; The MIT License (MIT)
;;
;; Copyright (c) 2021 David O'Sullivan
;;
;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without restriction,
;; including without limitation the rights to use, copy, modify, merge,
;; publish, distribute, sublicense, and/or sell copies of the Software,
;; and to  permit persons to whom the Software is furnished to do so,
;; subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included
;; in all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
;; OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
;; THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;; DEALINGS IN THE SOFTWARE.
@#$#@#$#@
GRAPHICS-WINDOW
12
10
420
419
-1
-1
5.0
1
10
1
1
1
0
1
1
1
0
79
0
79
0
0
1
ticks
30.0

SLIDER
617
13
804
46
number-of-draws
number-of-draws
0
1000
99.0
1
1
NIL
HORIZONTAL

SLIDER
617
51
804
84
probability
probability
0
1
0.1163
0.0001
1
NIL
HORIZONTAL

BUTTON
450
13
575
46
test-binomial
ask patches [\n  set value random-binomial number-of-draws probability\n]\nupdate-displays true
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
449
96
596
129
test-multinomial
ask patches [\n  set weight random-poisson multinomial-mean\n]\nlet weights map [p -> [weight] of p] sort patches\nlet values random-multinomial-int (count patches * number-of-draws) weights\n(foreach sort patches values [ [p v] ->\n  ask p [set value v]\n]) \nupdate-displays colour-by-value?\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
216
447
388
480
colour-by-value?
colour-by-value?
0
1
-1000

BUTTON
38
447
193
480
recolour-patches
colour-patches colour-by-value?
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
448
189
582
222
test-nbinomial
ask patches [\n  set value random-negative-binomial n-failures probability\n]\nupdate-displays true
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
619
186
791
219
n-failures
n-failures
1
100
48.0
1
1
NIL
HORIZONTAL

SLIDER
618
278
819
311
variance-mean-ratio
variance-mean-ratio
1
10
3.9
0.01
1
NIL
HORIZONTAL

BUTTON
447
231
583
264
test-nbinom-vmr
ask patches [\n  set value random-negative-binomial-with-mean-vmr mean-result variance-mean-ratio\n]\nupdate-displays true
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
619
237
791
270
mean-result
mean-result
1
100
24.96
0.01
1
NIL
HORIZONTAL

MONITOR
14
510
109
555
mean
mean [value] of patches
5
1
11

MONITOR
14
561
109
606
variance
variance [value] of patches
5
1
11

PLOT
119
489
441
690
Distribution
Value
Frequency
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"histogram" 1.0 1 -16777216 true "" ""

SLIDER
616
374
788
407
scale
scale
0.0001
10
1.274
0.0001
1
NIL
HORIZONTAL

BUTTON
449
330
565
363
test-cauchy
ask patches [\n  set value random-cauchy location scale\n]\nupdate-displays true
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
618
324
790
357
location
location
-100
100
0.0
0.1
1
NIL
HORIZONTAL

BUTTON
447
421
561
454
test-weibull
ask patches [\n  set value random-weibull scale the-shape 0 100\n]\nupdate-displays true
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
618
424
790
457
the-shape
the-shape
0
25
2.39
0.01
1
NIL
HORIZONTAL

BUTTON
446
491
564
524
test-gamma
ask patches [\n  set value random-gamma-with-mean-sd gamma-mean gamma-sd\n]\nupdate-displays true
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
618
488
790
521
gamma-mean
gamma-mean
0
10
5.0
0.01
1
NIL
HORIZONTAL

SLIDER
617
530
789
563
gamma-sd
gamma-sd
0
10
6.051
0.001
1
NIL
HORIZONTAL

MONITOR
14
613
107
658
sd
population-standard-deviation [ifelse-value colour-by-value? [value] [weight]] of patches
5
1
11

BUTTON
449
604
585
637
test-lognormal
ask patches [\n  set value random-lognormal log-mean log-sd\n]\nupdate-displays true
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
622
591
794
624
log-mean
log-mean
0.01
10
0.96
0.01
1
NIL
HORIZONTAL

SLIDER
625
643
797
676
log-sd
log-sd
0
2
0.39
0.01
1
NIL
HORIZONTAL

SLIDER
621
104
818
137
multinomial-mean
multinomial-mean
0.1
100
28.1
0.1
1
NIL
HORIZONTAL

BUTTON
451
143
605
176
test-multinomial-float
ask patches [\n  set weight random-exponential multinomial-mean\n]\nlet weights map [p -> [weight] of p] sort patches\nlet values random-multinomial (count patches * number-of-draws) weights true\n(foreach sort patches values [ [p v] ->\n  ask p [set value v]\n]) \nupdate-displays colour-by-value?\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
# distributions-utils.nls documentation
This document is intended to provide a guide to usage of the functions provided in the file `distribution-utils.nls`.


## Purpose
`distribution-utils.nls` provides convenient implementations of commonly used random probability distributions beyond `random`, `random-float`, `random-normal`, `random-poisson`, `random-exponential` and `random-gamma` provided natively in NetLogo.

Because the random number reporters in `distribution-utils.nls` are implemented in NetLogo, they are convenient to use, but more efficient implementations may require you to develop an extension to wrap a library such as [CERN's COLT](https://dst.lbl.gov/ACSSoftware/colt/api/index.html), or perhaps to use the random generators available in _R_ via Netlogo's `r` extension. But before going to that trouble, you can use these and find out if you really need any of these distributions at all!

### **Warning!**
I am not a statistician, mathematician, probability theorist, or numerical programmer. As such, the code for these utility reporters has been assembled from various sources (mainly wikipedia, but also others as specified below) and I cannot vouch for its strict numerical accuracy. The results _seem_ OK to me based on simple evaluations of histograms of results and similar 'tests'. If you need bullet-proof statistical distributions in your models, you may want to do more thorough checking of your own before using these utilities, or as suggested above incorporate _R_ code using the `r` extension. 

This warning is in addition to the usual disclaimers about random code you find on the internet (even if I am a professor).

Anyway, all that said...

## Usage
Put `distribution-utils.nls` in the same folder as your model. Then at the beginning of your model code include the line

```
__includes["distribution-utils.nls"]
```

All the listed reporters and/or procedures will then be available in your model code. Alternatively, just copy and paste the code you need into your model (if you do this, it would be nice to also include the license information in your model code).


## Reporters
### random-binomial
**random-binomial** _n_ _p_

Returns a random binomial deviate _B(n, p)_. For small numbers of random binomial deviates, you could use

    length filter [x -> x < p] n-values [x -> random-float 1]

but this approach slows down quickly since it is _O(n)_ and it is common to have _p_ << _n_, to be working with large _n_ and to be calling the reporter a lot. For _p_ relatively large, you can get away with `random-poisson (n * p)` as a quick hack, but if you're thinking about doing actual science with your model, this is probably best avoided.  

The reporter in `distribution-utils.nls` implements the algorithm in

+ Devroye. L. 1960. Generating the maximum of independent identically
distributed random variables. _Computers and Mathematics with
Applications_ **6**, 305-315. DOI:[10.1016/0898-1221(80)90039-5](https://dx.doi.org/10.1016/0898-1221(80)90039-5)

and is _O(np)_ which will often be much quicker than the naive approach, and unlike the Poisson approach, is correct even for small values of _p_.

If _p_ is less than 0, it will report 0, which is incorrect. If _p_ is greater than 1 then it will crash. Just make sure 0 &le; _p_ &le; 1!

I originally found this as code from [this post](
https://stackoverflow.com/questions/23561551/a-efficient-binomial-random-number-generator-code-in-java#23574723), but later discovered an error and had to track down and check Devroye's paper to fix it! This is a neat little algorithm and certainly much easier to implement than the 'gold standard' algorithm of  

+ Kachitvichyanukul V and BW Schmeiser. 1988. Binomial Random Variate Generation. _Communications of the ACM_ **31**(2), 216-222. DOI:[10.1145/42372.42381](https://doi.org/10.1145/42372.42381)

To see just how much more complicated that algorithm is see the [_R_ implementation](https://github.com/SurajGupta/r-source/blob/master/src/nmath/rbinom.c). If you get around to implementing it in NetLogo, be sure to let me know!

### random-cauchy
**random-cauchy** _location_ _scale_

Reports a Cauchy distributed random variate from Cauchy distribution with location parameter _location_ and scale parameter _scale_. See this wikipedia entry for the [Cauchy distribution](https://en.wikipedia.org/wiki/Cauchy_distribution).

### random-gamma-with-mean-sd
**random-gamma-with-mean-sd** _mean_ _sd_

Reports a Gamma distributed random variate from the Gamma distribution with mean _mean_ and standard-deviation _sd_.

### random-lognormal
**random-lognormal** _mean_ _sd_

Reports a lognormal distributed random variate with mean _mean_ and standard deviation _sd_.

### random-multinomial
**random-multinomial** _n_ _list_ _simple-frequencies?_

See [`random-multinomial-int`](#random-multinomial-int) for an explanation of the basic operation of this reporter. This version of the multinomial reporter allows floating-point relative frequencies. Depending on _simple-frequencies?_ the reported list of frequencies may be either simple relative frequencies (when _simple-frequencies?_ is `true`) or precomputed serial conditional probabilities (when _simple-frequencies?_ is `false`).

Serial conditional probabilities are obtained from the helper reporter [`conditional-probabilities-with-forcing`](#conditional-probabilities-with-forcing) which enforces the necessary condition that the last non-zero probability is equal to 1, a condition not guaranteed as a side-effect of imprecision in floating point arithmetic.

Use `random-multinomial`

+ when you cannot provide relative frequencies as a list of integers (`random-multinomial-int` is faster), or
+ when the list of frequencies is fixed across many calls to the function. In this case do, for example
```
let weights [weight] of sort patches
let cond-probs conditional-probabilities-with-forcing weights
repeat 1000 [
    (foreach (sort patches) random-multinomial n cond-probs false [
        [p n] ->
        ask p [ do-something-with n ]
    ])
]
```
There are some situations requiring multinomial distributions where the functions in the [NetLogo `rnd` extension](https://ccl.northwestern.edu/netlogo/docs/) may be preferable to this lower-level reporter.

### random-multinomial-int
**random-multinomial-int** _n_ _frequencies_

Takes a list of frequencies _frequencies_ and generates a list of length _n_ where each item in the list represents the number of times that position has been drawn. For example `random-multinomial-int 100 [1 2 3 4]` might generate the result `[12 27 23 38]`.

This reporter works by making `length` _frequencies_ `random-binomial` draws where each draw has _n_ given by the number of items remaining and _p_ is based on a conditional probability. In the example above, the first such draw would be

    random-binomial 100 (1 / sum [1 2 3 4])

Say this gives us 9, as a result. The next draw would be

    random-binomial (100 - 9) (2 / sum [2 3 4])

Say this yields 22, the next draw would be

    random-binomial (100 - 9 - 22) (3 / sum [3 4])

Say this yields 34. The final draw will always have probabilty 1 and thus will yield the remaining total of 100 - 9 - 22 - 34 = 35. In this example the result would be `[9 22 34 35]`.

The required serial conditional probabilities are obtained by calling

    conditional-probabilities frequencies

The implementation uses [`dists-cumulative-remainder`](#dists-cumulative-remainder).

There are some situations requiring multinomial distributions where the functions in the [NetLogo `rnd` extension](https://ccl.northwestern.edu/netlogo/docs/) may be preferable to this lower-level reporter.

### random-negative-binomial
**random-negative-binomial** _r_ _p_

Reports a random negative binomial variate from _NBin(r, p)_. Implementation is by a random Poisson parameterised with a Gamma distributed variate as described [here](https://en.wikipedia.org/wiki/Negative_binomial_distribution#Gamma%E2%80%93Poisson_mixture).

### random-negative-binomial-with-mean-vmr
**random-negative-binomial-with-mean-vmr** _mean_ _vmr_

Reports a random negative binomial variate from a distribution with specified mean _mean_ and variance mean ratio _vmr_. _vmr_ must be strictly greater than 1. This provides an alternative to the Poisson distribution that is over-dispersed for situations where greater variability is required in a sequence of random integers.

### random-weibull
 **random-weibull** _shape_ _scale_ _lower-limit_ _upper-limit_

Reports a Weibull distributed random variate with shape parameter _shape_ and scale parameter _scale_ bounded to the range from _lower-limit_ (inclusive) to _upper-limit_ (exclusive). This reporter will perform poorly if the lower and upper limits provided include only a low total probability, since the the limit is satisfied by repeated draws until a value meets the range criterion specified. See this wikipedia entry for the [Weibull distribution](https://en.wikipedia.org/wiki/Weibull_distribution).


## Helper reporters specific to `distribution-utils.nls`
These aren't really intended to be used by an end-user, but since there is no ability to make reporters 'private' in NetLogo, it's best to document them anyway.

### conditional-probabilities
**conditional-probabilities** _frequencies_

This reporter returns a serial set of conditional probabilities derived from the supplied list of simple relative frequencies. The returned list will be a series of values <i>n<sub>i</sub></i> / &Sigma;<i><sub>i</sub><sup>N</sup> n<sub>i</sub></i>. For example

    conditional-probabilities [1 1 1 1 1]
    > [0.2 0.25 0.333333 0.5 1]
    conditional-probabilities [1 2 4 6 7]
    > [0.05 0.10526 0.23529 0.46154 1]

Floating point division problems occasionally cause the final value in the list to not equal 1, when it always should do, so this expectation is enforced in the code, meaning that there may be small errors where very small marginal probabilities are involved.

### conditional-probabilities-with-forcing
**conditional-probabilities-with-forcing** _frequencies_

A version of [`conditional-probabilities`](#conditional-probabilities) suitable for floating point _frequencies_ when arithmentic inaccuracies may cause the last non-zero conditional probability not to be 1. This condition is enforced by this reporter.

### cumulative-remainder
**dists-cumulative-remainder** _list_

Reports a list of the sum of the remaining values in _list_ at each position, that is &Sigma;<i><sub>i</sub><sup>N</sup> x<sub>i</sub></i> where N is the length of the list, for example:

    dists-cumulative-remainder [1 2 3 4 5]
    > [15 14 12 9 5]

### last-positive
**last-positive** _list_

Reports the list index of the last occurrence of a positive (non-zero) value in the list _list_. Used by [`conditional-probabilities-with-forcing`](#conditional-probabilities-with-forcing).

### population-standard-deviation
**population-standard-deviation** _list_

Reports the population standard deviation of the values in _list_. (The native NetLogo reporter `standard-deviation` reports the sample SD.)

### population-variance
**population-variance** _list_

Reports the population variance of the values in _x_. (The native NetLogo reporter `variance` reports the sample variance.)


## Helper reporters also available in other `-utils.nls` files
These reporters are also provided in other utilties files, but a 'local' copy with the prefix `dists-` means you can include all the `.nls` files in a single model if you wish.

### dists-cumulative-sum
**dists-cumulative-sum** _list_

Reports a list of the cumulative sum of the supplied list _list_, that is &Sigma;<i><sub>0</sub><sup>i</sup> n<sub>i</sub></i>, for example:

    dists-cumulative-sum [1 2 3 4 5]
    > [1 3 6 10 15]

### dists-last-position
**dists-last-position** _x_ _list_

Reports the list index of the last occurrence of the value _x_ in list _list_.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
