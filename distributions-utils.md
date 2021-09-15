# distributions-utils.nls documentation
This document is intended to provide a guide to usage of the functions provided in the file `distribution-utils.nls`.

## Purpose
`distribution-utils.nls` provides convenient implementations of commonly used random probability distributions beyond `random`, `random-float`, `random-normal`, `random-poisson`, `random-exponential` and `random-gamma` provided natively in NetLogo.

Because the random number reporters in `distribution-utils.nls` are implemented in NetLogo, they are convenient to use, but more efficient implementations may require you to develop an extension to wrap a library such as [CERN's COLT](https://dst.lbl.gov/ACSSoftware/colt/api/index.html), or perhaps to use the random generators available in _R_ via Netlogo's `r` extension. But before going to that trouble, you can use these and find out if you really need any of these distributions at all!

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

Reports a Gamma distributed random variate from the the Gamma distributed with mean _mean_ and standard-deviation _sd_.

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

    let weights [weight] of sort patches
    let cond-probs conditional-probabilities-with-forcing repeat 1000 [
      (foreach (sort patches) random-multinomial n cond-probs false [
        [p n] ->
          ask p [ do-something-with n ]
      ])
    ]

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

    conditional-probabilities _frequencies_

The implementation uses [`dists-cumulative-remainder`](#dists-cumulative-remainder).

There are some situations requiring multinomial distributions where the functions in the [NetLogo `rnd` extension](https://ccl.northwestern.edu/netlogo/docs/) may be preferable to this lower-level reporter.

### random-negative-binomial
**random-negative-binomial** _r_ _p_

Reports a random negative binomial variate from _NBin(r, p)_. Implementation is by a random Poisson parameterised with a Gamma distributed variate as described [here](https://en.wikipedia.org/wiki/Negative_binomial_distribution#Gamma%E2%80%93Poisson_mixture).

### random-negative-binomial-with-mean-vmr
**random-negative-binomial-with-mean-vmr** _mean_ _vmr_

Reports a random negative binomial variate from a distribution with specified mean _mean_ and variance mean ratio _vmr_. _vmr_ must be 1 or greater. This provides an alternative to the Poisson distribution that is over-dispersed for situations where greater variability is required in a sequence of random integers.

### random-weibull
 **random-weibull** _shape_ _scale_ _lower-limit_ _upper-limit_

Reports a Weibull distributed random variate with shape parameter _shape_ and scale parameter _scale_ bounded to the range from _lower-limit_ (inclusive) to _upper-limit_ (exclusive). This reporter will perform poorly if the lower and upper limits provided include only a low total probability, since the the limit is satisfied by repeated draws until a value meets the range criterion specified. See this wikipedia entry for the [Weibull distribution](https://en.wikipedia.org/wiki/Weibull_distribution).

---

## Helper reporters specific to `distribution-utils.nls`
These aren't really intended to be used by an end-user, but since there is no ability to make reporters 'private' in NetLogo, it's best to document them anyway.

### conditional-probabilities
**conditional-probabilities** _frequencies_

This reporter returns a serial set of conditional probabilities derived from the supplied list of simple relative frequencies. The returned list will be a series of values [n_i / sum_i^N n_i]. For example

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

Reports a list of the sum of the remaining values in _list_ at each position, that is `[sum_i^N x_i]` where N is the length of the list, for example:

    dists-cumulative-remainder [1 2 3 4 5]
    > [15 14 12 9 5]

### population-standard-deviation
**population-standard-deviation** _list_

Reports the population standard deviation of the values in _list_. (The native NetLogo reporter `standard-deviation` reports the sample SD.)

### population-variance
**population-variance** _list_

Reports the population variance of the values in _x_. (The native NetLogo reporter `variance` reports the sample variance.)

---

## Helper reporters also available in other `-utils.nls` files
These reporters are also provided in other utilties files, but a 'local' copy with the prefix `dists-` means you can include all the `.nls` files in a single model if you wish.

### dists-cumulative-sum
**dists-cumulative-sum** _list_

Reports a list of the cumulative sum of the supplied list _list_, that is `[sum_0^i x_i]`, for example:

    dists-cumulative-sum [1 2 3 4 5]
    > [1 3 6 10 15]

### dists-last-position
**dists-last-position** _x_ _list_
Reports the list index of the last occurrence of the value _x_ in list _list_.

### last-positive
**last-positive** _list_
Reports the list index of the last occurrence of a positive (non-zero) value in the list _list_. Used by [`conditional-probabilities-with-forcing`](#conditional-probabilities-with-forcing).
