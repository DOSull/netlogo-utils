# `distributions.nls` documentation
This document is intended to provide a guide to usage of the functions provided in the file `distributions.nls`.

## Purpose
`distributions.nls` is intended to provide convenient implementations of commonly used random probability distributions beyond `random`, `random-float`, `random-normal`, `random-poisson` and `random-gamma` as provided natively in NetLogo.

Because the random number reporters in `distributions.nls` are implemented in NetLogo, they are convenient to use, but more efficient implementations may require you to develop an extension to wrap a library such as CERN's COLT, or perhaps to use the extensive set of random generators available in _R_ via Netlogo's `r` extension. But before going to that trouble, you can use these and find out if you really need any of these distributions at all!

## Usage
Put `distributions.nls` in the same folder as your model. Then at the beginning of your model code do

```
__includes["distributions.nls"]
```

All the listed reporters and/or procedures will then be available in your model code.

## Reporters
### `random-binomial` _n_ _p_
Returns a random binomial deviate _B(n, p)_. For small numbers of random binomial deviates, you could use

    length filter [x -> x < p] n-values [x -> random-float 1]

but this approach slows down quickly since it is _O(n)_ and it is common to have _p_ << _n_, to be working with large _n_ and to be calling the reporter a lot. For _p_ relatively large, you can get away with `random-poisson (n * p)` as a quick hack, but if you're thinking about doing actual science with your model, this is probably best avoided.  

Instead, the reporter provided in `distributions.nls` implements the algorithm in

+ Devroye. L. 1960. Generating the maximum of independent identically
distributed random variables. _Computers and Mathematics with
Applications_ **6**, 305-315. DOI:[10.1016/0898-1221(80)90039-5](https://dx.doi.org/10.1016/0898-1221(80)90039-5)

and is _O(np)_ which will often be much quicker than the naive approach, and unlike the Poisson approach, is correct even for small values of _p_.

I originally found this as code from [this post](
https://stackoverflow.com/questions/23561551/a-efficient-binomial-random-number-generator-code-in-java#23574723), but later discovered an error and had to track down and check Devroye's paper to fix it! This is a neat little algorithm and certainly much easier to implement than the 'gold standard' algorithm of  

+ Kachitvichyanukul V and BW Schmeiser. 1988. Binomial Random Variate Generation. _Communications of the ACM_ **31**(2), 216-222. DOI:[10.1145/42372.42381](https://doi.org/10.1145/42372.42381)

To see just how much more complicated that algorithm is see the [_R_ implementation](https://github.com/SurajGupta/r-source/blob/master/src/nmath/rbinom.c). If you get around to implementing it in NetLogo, be sure to let me know!

### `random-cauchy` _location_ _scale_
Reports a Cauchy distributed random variate from Cauchy distribution with location parameter _location_ and scale parameter _scale_. See this wikipedia entry for the [Cauchy distribution](https://en.wikipedia.org/wiki/Cauchy_distribution).

### `random-gamma-with-mean-sd` _mn_ _sd_
Reports a Gamma distributed random variate from the the Gamma distributed with mean _mn_ and standard-deviation _sd_.

### `random-lognormal` _mn_ _sd_
Generates a lognormal distributed variate with mean _mn_ and standard deviation _sd_.

### `random-multinomial-float` _n_ _lst_ _simple-frequencies?_
See [`random-multinomial-int`](#random-multinomial-int) for an explanation of the basic operation of this reporter. This version of the multinomial generator allows floating-point relative frequencies. Depending on _simple-frequencies?_ the provided list of frequencies may be either simple relative frequencies (when _simple-frequencies?_ is `true`) or precomputed serial conditional probabilities (when _simple-frequencies?_ is `false`).

Serial conditional probabilities are the series of probability values provided to the binomial draw made at each step. For example a list `[1 3 2 4]` supplied as simple frequencies becomes the serial conditional probabilities

    0.1   = 1 / sum [1 2 3 4]
    0.333 = 3 / sum [2 3 4]
    0.333 = 2 / sum [2 4]
    1.0   = 4 / sum [4]

The serial conditional probabilities can be obtained from the helper reporter [`conditional-probabilities`](#conditional-probabilities). This is convenient if a large fixed set of relative frequencies will be repeatedly required.

### `random-multinomial-int` _n_ _lst_
Takes a list of frequencies _lst_ and generates a list of length _n_ where each item in the list represents the number of times that position has been drawn. For example `random-multinomial-int 100 [1 2 3 4]` might generate the result `[12 27 23 38]`.

This reporter works by making `length` _lst_ `random-binomial` draws. In the example above, the first such draw would be

    random-binomial 100 (1 / sum [1 2 3 4])

Say this gives us 9, as a result. The next draw would be

    random-binomial (100 - 9) (2 / sum [2 3 4])

Say this yields 22, the next draw would be

    random-binomial (100 - 9 - 22) (3 / sum [3 4])

Say this yields 34. The final draw will always have probabilty 1 and thus will yield the remaining total of 100 - 9 - 22 - 34 = 35. In this example the result would be `[9 22 34 35]`.

### `random-nbinomial` _r_ _p_
Reports a random negative binomial variate from N(r, p). Implementation is by a random Poisson parameterised with a Gamma distributed variate as described [here](https://en.wikipedia.org/wiki/Negative_binomial_distribution#Gamma%E2%80%93Poisson_mixture).

### `random-nbinomial-with-mean-vmr` _mn_ _vmr_
Reports a random negative binomial variate from a distribution with specified mean _mn_ and variance mean ratio _vmr_. _vmr_ must be 1 or greater. This provides an alternative to the Poisson distribution that is over-dispersed for situations where greater variability is required in a sequence of random integers.

### `random-weibull` _shp_ _scl_ _lower-limit_ _upper-limit_
Reports a Weibull distributed random variate with shape parameter _shp_ and scale parameter _scl_ bounded to the range from _lower-limit_ (inclusive) to _upper-limit_ (exclusive). This reporter will perform poorly if the lower and upper limits provided include only a low total probability, since the the limit is satisfied by repeated draws until a value meets the range criterion specified. See this wikipedia entry for the [Weibull distribution](https://en.wikipedia.org/wiki/Weibull_distribution).

## Helper reporters
These aren't really intended to be used by an end-user, but since there is no ability to make reporters 'private' in NetLogo, it's best to document them anyway.

### `conditional-probabilities` _frequencies_
This reporter returns a serial set of conditional probabilities derived from the supplied list of simple relative frequencies. The returned list will be a series of values [n_i / sum_i^N n_i]. For example

    conditional-probabilities [1 1 1 1 1]
    > [0.2 0.25 0.333333 0.5 1]
    conditional-probabilities [1 2 4 6 7]
    > [0.05 0.10526 0.23529 0.46154 1]

### `dists-cumulative-remainder` _L_
Reports a list of the sum of the remaining values in the _L_ at each position, that is `[sum_i^N x_i]` where N is the length of the list, for example:

    dists-cumulative-remainder [1 2 3 4 5]
    > [15 14 12 9 5]

### `dists-cumulative-sum` _L_
Reports a list of the cumulative sum of the supplied list _L_, that is `[sum_0^i x_i]`, for example:

    dists-cumulative-sum [1 2 3 4 5]
    > [1 3 6 10 15]

### `pack-zeros` _lst_ _n_ _post?_
Reports a list of length _n_ by packing the supplied list _lst_ with zeros either at the end (if _post?_ is `true`) or at the beginning (if _post?_ is `false`)

    pack-zeros [1 2 3] 5 true
    > [1 2 3 0 0]
    pack-zeros [1 2 3] 5 false
    > [0 0 0 0 0]

### `population-standard-deviation` _x_
Reports the population standard deviation of the list of values in _x_. (The native NetLogo reporter `standard-deviation` reports the sample SD.)

### `population-variance`
Reports the population variance of the list of values in _x_. (The native NetLogo reporter `variance` reports the sample variance.)
