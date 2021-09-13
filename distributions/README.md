# `distributions.nls` documentation
This document is intended to provide a guide to usage of the functions provided in the file `distributions.nls`.

## Purpose
`distributions.nls` is intended to provide convenient implementations of commonly used random probability distributions beyond `random`, `random-float`, `random-normal`, `random-poisson` and `random-gamma` as provided natively in NetLogo.

Because these random generators are implemented in NetLogo, they are convenient to use, but more efficient implementations may require you to develop an extension to wrap a library such as CERN's COLT, or perhaps to use the extensive set of random generators available in _R_ via Netlogo's `r` extension.

## Reporters

## Helper reporters
These aren't really intended to be used by an end-user, but since there is no ability to make reporters 'private' in NetLogo, it's best to document them anyway.
