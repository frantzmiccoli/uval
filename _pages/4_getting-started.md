---
layout: page
title: Getting started with uval
menuTitle: Getting started
permalink: /getting-started.html
---


~~~ javascript
var registry = require('uval');

var urlValidator = registry['validator.isurl']();
urlValidator.validate('http://www.github.com').then(function(isValid) {
    console.log(isValid);
});

urlValidator.validate('uhuhuh').then(function(isValid) {
    console.log(isValid);

    console.log(urlValidator.getFailureData());
});

// curious about what else is available? just log the keys!
console.log(Object.keys(registry));
/* This is what you could expect:
  'uval.isset': [Function],
  'uval.isnotset': [Function],
  'uval.or': [Function],
  'uval.array': [Function],
  'uval.validationchain': [Function],
  'uval.object': [Function],
  'validator.isurl': [Function],
  'validator.isnumeric': [Function],
  'validator.isfloat': [Function],
  'validator.isin': [Function],
  '_.isarray': [Function],
  '_.isboolean': [Function],
  '_.isstring': [Function]
*/

~~~