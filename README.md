[![Build Status](https://secure.travis-ci.org/frantzmiccoli/uval.png)](http://travis-ci.org/frantzmiccoli/uval)


Intentions
===
Some validation utilities are provided in the node.js ecosystem, but we felt that nothing that handles a full validation chain with loose coupling was available.

**uval** tries to be this missing tool.

Features
===

* A generic validation system mostly represented by an abstract validation class, `uval/validator/Abstract`.
* A few validators available from known validation libraries available through the registry, `uval/registry`, you can add your own easily be using `uval/validator/Generic`.
* A few validation utilities that lets you:

    * Compose an object level validation `uval/validator/Object`.
    * Compose a validation chain `uval/validator/ValidationChain` which is ensuring that the input valids **all** the provided validators.
    * Make an **or** over a set of validators `uval/validator/Or` where the input must valid **at least one** validator.
    * Apply a validation over all elements of an array `uval/validator/Array`.

* A failure data retrieval logic that let you do whatever you want to handle the error and the translation through the usage of the `getFailureData()` method.
* Support a context for validation, the validate function takes a second `context` argument and broadcast it to all subvalidators when any.

What you won't find in uval
---
* No mechanism handling the translation is provided. You are supposed to do this by handling what comes out of `getFailureData()`. **Error identifiers are on purpose non english string**, a correct error handling should include a translation of the error message and maybe a retrieval of the input or the context, this is out of our scope.  
* uval is only node.js compatible right now, it could be easily modified to be available client side
* uval does not support promises, if someone feels like updating it, I have absolutely no problem with it. 

Sample code
===

Registry
---

The registry contains already available validators from other libraries wrapped in some `uval/validator/Generic` object. The registry is a dict, the first part of the key is identifying the source of the original validator:

* `validator.isurl` is coming from `node-validator` (that is usually imported through `require('validator')`
* `_.isarray` is coming from `node-underscore`

**The registry can be accessed either through `require('uval')` and `require('uval/registry')`**.

```
var registry = require('uval');

// Let's show what's in there
console.log(Object.keys(registry));

// The registry contains generator that return one validator, but they are supposed to be reusable
var urlValidator = registry['validator.isurl']();
console.log(urlValidator.validate('http://www.github.com'));

console.log(urlValidator.validate('what ?'));

console.log(urlValidator.getFailureData());

// This is true and getFailureData should be reset
console.log(urlValidator.validate('http://www.github.com'));
```

Array validation
---

```
var registry = require('uval/registry'),
    isNumericValidator = registry['validator.isnumeric'](),
    ArrayValidator = registry['uval.array'],
    arrayValidator = new ArrayValidator(isNumericValidator);
    
console.log(arrayValidator.validate([0, 1, 2, 3, 'nope']));
// The failure data for composed validator is a bit more complex
console.log(arrayValidator.getFailureData());

console.log(arrayValidator.validate([0, 12, -23]));
```

Optional parameters
---

```
var registry = require('uval/registry'),
    urlValidator = registry['validator.isurl'](),
    notSetValidator = registry['uval.isnotset'](),
    OrValidator = registry['uval.or'],
    nothingOrUrlValidator = new OrValidator([notSetValidator, urlValidator]);
    
console.log(nothingOrUrlValidator.validate(undefined)); // should pass
console.log(nothingOrUrlValidator.validate('Something that is not expected')); // should not pass
console.log(nothingOrUrlValidator.validate('http://anything.com')); // should pass
```

Validating a complex object
---

```
var registry = require('uval/registry'),
    urlValidator = registry['validator.isurl'](),
    setValidator = registry['uval.isset'](),
    ObjectValidator = registry['uval.object'],
    userValidator = new ObjectValidator();
    
userValidator.add('name', setValidator);
userValidator.add('url', urlValidator);

var user = {};

console.log(userValidator.validate(user));
// The failure data is different from the one expected for arrays.
console.log(userValidator.getFailureData());

user = {
        'name' : 'John',
        'url': 'http://john.com'
    };

console.log(userValidator.validate(user));
```

Similar projects 
===

Available as npm packages:

* [is-validation](https://www.npmjs.org/package/is-validation)
* [nod-validation](https://www.npmjs.org/package/nod-validation)
* [object-validation](https://www.npmjs.org/package/object-validation)

License
===

MIT
