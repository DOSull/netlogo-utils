# `distributions.nls` documentation
This document is intended to provide a guide to usage of the functions provided in the file `distributions.nls`.

## Purpose
`distributions.nls` is intended to provide convenient implementations of commonly used random probability distributions beyond `random`, `random-float`, `random-normal`, `random-poisson` and `random-gamma` as provided natively in NetLogo.

Because the random number reporters in `distributions.nls` are implemented in NetLogo, they are convenient to use, but more efficient implementations may require you to develop an extension to wrap a library such as CERN's COLT, or perhaps to use the extensive set of random generators available in _R_ via Netlogo's `r` extension. But before going to that trouble, you can use these and find out if you really need any of these distributions at all!

## Usage
Put `distributions.nls` in the same folder as your model. Then at the beginning of your model code do

    __includes["distributions.nls"]

All the listed reporters and/or procedures will then be available in your model code.

## Reporters
### `random-binomial` _n_ _p_
Returns a random binomial deviate $B(n, p)$. For small numbers of random binomial deviates, you could use

    length filter [x -> x < p] n-values [x -> random-float 1]

but this approach slows down quickly since it is _O(n)_ and it is common to have _p_ << _n_,to be working with large _n_ and to be calling the reporter a lot. For _p_ relatively large, you can get away with `random-poisson (n * p)` as a quick hack, but if you're thinking about doing actual science with your model, this is probably best avoided.  

Instead, the reporter provided in `distributions.nls` implements the algorithm in

+ Devroye. L. 1960. Generating the maximum of independent identically
distributed random variables. _Computers and Mathematics with
Applications_ **6**, 305-315. DOI:[10.1016/0898-1221(80)90039-5](https://dx.doi.org/10.1016/0898-1221(80)90039-5)

and is _O(np)_ which will often be much quicker than the naive approach, and unlike the Poisson approach, is correct even for small values of _p_.

I originally found this as code from [this post](
https://stackoverflow.com/questions/23561551/a-efficient-binomial-random-number-generator-code-in-java#23574723), but later discovered an error and had to track down and check Devroye's paper to fix it! This is a neat little algorithm and certainly much easier to implement than the 'gold standard' algorithm of  

+ Kachitvichyanukul V and BW Schmeiser. 1988. Binomial Random Variate Generation. _Communications of the ACM_ **31**(2), 216-222. DOI:[10.1145/42372.42381](https://doi.org/10.1145/42372.42381)

To see just how much more complicated that algorithm is see the [_R_ implementation](https://github.com/SurajGupta/r-source/blob/master/src/nmath/rbinom.c). If you get around to implementing it in NetLogo, be sure to let me know!

### `random-multinomial-int` _list_ _simple-frequencies?_
More to follow...

## Helper reporters
These aren't really intended to be used by an end-user, but since there is no ability to make reporters 'private' in NetLogo, it's best to document them anyway.
