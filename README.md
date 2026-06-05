# netlogo-utils
Netlogo utility 'packages', i.e., functions written in 'native' Netlogo, to 'extend' the language, with no need for extensions. To use any of these simply put `__includes[ "xxx-utils.nls" ]` at the top of your Netlogo code, and ensure the file is in the same folder as your model.

Code for lists and probability distributions is reasonably mature and documented as linked below:

+ [`list-utils.nls`](list-utils.md) for a variety of list reporters
+ [`distribution-utils.nls`](distributions-utils.md) for some random number generators that native Netlogo does not support

Additional utility packs remain 'under-development' although they should work OK, but are not yet documented.

+ `string-utils.nls` for simple string manipulations
+ `drawing-utils.nls` for drawing boundaries between patches with different values
+ `nlm-utils.nls` for neutral landscapes

The corresponding `*.nlogox` files test most of the procedures and reporters in the `.nls` files.