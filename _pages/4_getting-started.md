---
layout: page
title: Getting started with uval
menuTitle: Getting started
permalink: /getting-started.html
---

```

var registry = require('uval');

var urlValidator = registry['validator.isurl']();
urlValidator.validate('http://www.github.com').then(function(isValid) {
    console.log(isValid);
});

// curious about what else is available? just log the keys!
console.log(Object.keys(registry));
/*
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

```