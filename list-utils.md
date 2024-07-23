# list-utils.nls documentation
This document is intended to provide a guide to usage of the functions provided in the file `list-utils.nls`.

## Purpose
`list-utils.nls` provides convenient implementations of many functions for lists in NetLogo.

Because the reporters in `list-utils.nls` are implemented in NetLogo, they are convenient to use, but if you find yourself using any of the operations a lot, it might make sense to consider writing an extension.

## Usage
Put `list-utils.nls` in the same folder as your model. Then at the beginning of your model code include the line

```
__includes["list-utils.nls"]
```

All the listed reporters and/or procedures will then be available in your model code. Alternatively, just copy and paste the code you need into your model (if you do this, it would be nice to also include the license information in your model code).

## Reporters
### cumulative-sum
**cumulative-sum** _list_

Reports a list of the cumulative sums of _list_. For example

    cumulative-sum [0 0 4 6 9]
    > [0 0 4 10 19]

### insert-value-in-order
**insert-value-in-order** _list_ _x_

Reports a new list with the value _x_ inserted in the list _list_ in order. For example

    insert-value-in-order [0 0 4 9] 6
    > [0 0 4 6 9]

It is assumed that _list_ is already in ascending order (which can be ensured by only using `insert-value-in-order` or `insert-values-in-order` to maintain the list). This is convenient if it is necessary to maintain a sorted list of values because repeatedly calling the `sort` reporter can be slow.

### insert-values-in-order
**insert-values-in-order** _list1_ _list2_

Reports a new list with the values from _list1_ and _list2_ merged in order. It is assumed that the lists are already in ascending order (which can be ensured by only using `insert-value-in-order` or `insert-values-in-order` to maintain the lists).

### join-list _list_ _separator_
**join-list** _list_ _separator_

Reports a string formed by joining NetLogo string equivalents of the items in _list_ and inserting the string _seperator_ between items. For example

    join-list [0 2 6 6 7 9] ","
    > 0,2,6,6,7,9

### last-position
**last-position** _x_ _list_

Reports the last position of the value _x_ in list _list_. For example

    last-position 6 [6 0 9 6 7 2]
    > 3  

_list_ is **not** assumed to be in any order---the result is reported for the list as-is.  

### matches
**matches** _x_ _list_

Reports a list of booleans of the same length as _list_ where items are true if the corresponding position in _list_ equals the value _x_ and false otherwise.

    matches 6 [6 0 9 6 7 2]
    > [true false false true false false]

_list_ is **not** assumed to be in any order---the result is reported for the list as-is.

### matching-positions
**matching-positions** _x_ _list_

Reports a list of the index positions in _list_ where the item equals the value _x_.

    matching-positions 6 [6 0 9 6 7 2]
    > [0 3]

If no matches are found reports an empty list `[]`. _list_ is **not** assumed to be in any order---the result is reported for the list as-is.

### range-by
**range-by** _finish_ _by_

Convenience wrapper for [**range-from-to-by**](#range-from-to-by) _0_ _finish_ _by_.

### range-from-to-by
**range-from-to-by** _start_ _finish_ _step_

The **range-*** reporters are convenience wrappers for common usages of `n-values` to yield an evenly spaced sequence of values. The returned list starts with _start_, ends with the last value **strictly less than** _finish_, and proceed in steps of size _step_.

    range-from-to-by 0 6 2
    > [0 2 4]
    range-from-to-by 1 6 2
    > [1 3 5]
    range-from-to-by 0 -6 -2
    > [0 -2 -4 -6]

If the sign of the step is incorrect for the _start_ and _finish_ values a warning will be reported and an empty list reported.

The _exclusive_ end value behaviour demands close attention. The behaviour is similar to Python's `range()` function (hence the name of this reporter) and slicing operators, but _different_ from _R_'s `seq()` function.

### range-from-to
**range-from-to** _start_ _finish_

Convenience wrapper for [**range-from-to-by**](#range-from-to-by) _start_ _finish_ 1.

### rep-list 
**rep-list** _list_ _n_ _inline?_

Reports the list repeated _n_ times, either by  repeating the list _n_ times 'inline', or by repeating each list item _n_ times, i.e.,

    rep-list [1 2 3] 3 true
    > [1 2 3 1 2 3 1 2 3]
    rep-list [1 2 3] 3 false
    > [1 1 1 2 2 2 3 3 3]

`n` set to 0 will always return an empty list `[]`, and `n` set to 1 will return a copy of the original list. Negative values of `n` will cause an error. This reporter mimics base _R_'s `rep()` function (but with the sense of its boolean argument reversed). 

### split-list-at-value
**split-list-at-value** _list_ _value_

Reports a list of two lists, where all items in the first list are (strictly)  &lt; _value_ and all items in the second list are &ge; _value_. For example

    split-list-at-value [0 2 3 7 8] 6
    > [[0 2 3] [7 8]]
    split-list-at-value [0 2 3 7 8] 3
    > [[0 2] [3 7 8]]

It is assumed that _list_ is already in ascending order (which can be ensured by only using `insert-value-in-order` or `insert-values-in-order` to maintain the list).

### transpose _list_
**transpose** _list_

Takes a list of lists input _list_ and reports a 'transposed' list of lists, where each list consists of all the items at a given position in the lists in _list_. This is most easily understood by examples

    transpose [[0 1 2] [3 4 5]]
    > [[0 3] [1 4] [2 5]]
    transpose [[0 3] [1 4] [2 5]]
    > [[0 1 2] [3 4 5]]

The lists in _list_ are assumed to all be the same length as the first list. If any are longer, items beyond the length of the first list will be lost. If any list is shorter it will cause a crash.

Note that the effect of `transpose L` and of `zip item 0 L item 1 L` is identical. The difference is that [`zip`](#zip) is more convenient when only two lists are being combined.

### unzip
**unzip** _list_

This reporter reverses the effect of `zip` returning a list of the original two lists. `unzip` works by calling [`transpose`](#transpose) (it is effectively an alias for `transpose`).

### zip
**zip** _list1_ _list2_

Pairs corresponing items from _list1_ and _list2_ into a list of lists of length 2, where item 0 is from _list1_ and item 1 is from _list2_. For example

    zip [0 2 3 7 8] [0 2 5 12 20]
    > [[0 0] [2 2] [3 5] [7 12] [8 20]]

_list1_ and _list2_ must be the same length. The same effect can be obtained using [`transpose`](#transpose) by calling `transpose (list list1 list2)`, so `zip` is effectively a convenience wrapper for `transpose` when only two lists are involved.
