---
layout: page
title: Building a validation system with uval
menuTitle: Building a validation system
permalink: /building-validation-system.html
---

Registry
---

Validators are not directly exposed by the registry, the registry exposes
generators that are providing actual validators once called. This is why you
will see below calls on the items of the registry like:

    var urlValidator = registry['validator.isurl']();

This is because:

* Validators have a state (mostly to manipulate failure data)
* Validators may need parameters.

The registry provides from validators from other libraries wrapped
in some `uval/validator/Generic` object. The registry is a dict, the prefix
of the key is identifying the source of the original validator:

* `validator.isurl` is coming from `node-validator` (that is usually imported through `require('validator')`
* `_.isarray` is coming from `node-underscore`

~~~javascript
var registry = require('uval');

// Let's show what's in there
console.log(Object.keys(registry));

// The registry contains generator that return one validator, but they are supposed to be reusable
var urlValidator = registry['validator.isurl']();
urlValidator.validate('http://www.github.com').then(function(isValid) {
    console.log(isValid);


    return urlValidator.validate('what ?')
}).then(function(isValid) {
    console.log(isValid);
    urlValidator.getFailureData();


    return urlValidator.validate('http://www.github.com');
}).then(function(isValid) {
    // This is true and getFailureData should be reset
    console.log(isValid);
});
~~~~

Array validation
---

~~~~javascript
var registry = require('uval/registry'),
    isNumericValidator = registry['validator.isnumeric'](),
    ArrayValidator = registry['uval.array'],
    arrayValidator = new ArrayValidator(isNumericValidator);

arrayValidator.validate([0, 1, 2, 3, 'nope']).then(function(isValid) {
    console.log(isValid);
    // The failure data for composed validators is a bit more complex
    console.log(arrayValidator.getFailureData());


    arrayValidator.validate([0, 12, -23])
}).then(function(isValid) {
    console.log(isValid);
});
~~~~

Optional parameters
---

~~~~javascript
var registry = require('uval/registry'),
    urlValidator = registry['validator.isurl'](),
    notSetValidator = registry['uval.isnotset'](),
    OrValidator = registry['uval.or'],
    nothingOrUrlValidator = new OrValidator([notSetValidator, urlValidator]);

nothingOrUrlValidator.validate(undefined).then(function(isValid) {
    // should pass
    console.log(isValid);


    return nothingOrUrlValidator.validate('Something that is not expected');
}).then(function(isValid) {
    // should not pass
    console.log(isValid);


    return nothingOrUrlValidator.validate('http://anything.com')
}).then(function(isValid) {
    // should not pass
    console.log(isValid);
});
~~~~

Validating a complex object
---

~~~~javascript
var registry = require('uval/registry'),
    urlValidator = registry['validator.isurl'](),
    setValidator = registry['uval.isset'](),
    ObjectValidator = registry['uval.object'],
    userValidator = new ObjectValidator();

userValidator.add('name', setValidator);
userValidator.add('url', urlValidator);

var user = {};

userValidator.validate(user).then(function(isValid) {
    console.log(isValid);
    // The failure data is different from the one expected for arrays.
    console.log(userValidator.getFailureData());


    user = {
        name: 'John',
        url: 'http://john.com'
    };
    return userValidator.validate(user);
}).then(function(isValid) {
    console.log(isValid);
});
~~~~

Creating a simple custom validator
---

~~~~javascript
var GenericValidator = require('uval/validator/Generic');

function isOdd(someNumber) {
    return (someNumber % 2) === 0;
}

var oddValidatorGenerator = function() {
    var validator = new GenericValidator(isOdd,
        'custom/message/to/be/returned/when/isOdd/returns/false'
    return validator;
};

uval['custom/odd'] = oddValidatorGenerator;

// later in any piece of code that has an access to uval
var oddValidator = uval['custom/odd']();

oddValidator.validate(2).then(function(isValid) {
    console.log('2 isValid ', isValid); // should not be
});

oddValidator.validate(3).then(function(isValid) {
    console.log('3 isValid ', isValid);
});
~~~~

Supporting promises and a context
---

This is still a pretty simple usage

~~~~javascript
var Promise = require('bluebird');

// Just to simulate a configuration coming from a promise (file or database
// access)
function getConfigPromise(key) {
    return Promise.resolve(100); // let's return always the same thing
}

var GenericValidator = require('uval/validator/Generic');

// the first argument is the input we validate
// the second argument is a context
// the validator will be use like validator.validate(input, context)
function validateUserCreditsIncrement(creditIncrement, user) {
    var role = user.role;
    getConfigPromise('user.' + role + '.maxCreditIncrement').then(
        function(maxCreditIncrement) {
            return creditIncrement <= maxCreditIncrement;
        }
    )
}

var userCreditsIncrementValidatorGenerator = function() {
    var validator = new GenericValidator(validateUserCreditsIncrement,
        'custom/message/to/be/returned/when/validation/fails'
    return validator;
};

uval['custom/userCreditsIncrement'] = userCreditsIncrementsValidatorGenerator;

// later in any piece of code that has an access to uval
var userCreditsIncrementValidator = uval['custom/userCreditsIncrement']();

var user = {role: 'manager'};
userCreditsIncrementValidator.validate(99, user).then(function (isValid) {
    console.log('99 isValid ', isValid);
});

userCreditsIncrementValidator.validate(101, user).then(function (isValid) {
    console.log('101 isValid ', isValid); // should not be
});
~~~~

Creating a more complex validator
---

### Multiple of 3 validator

To provide more than one failure message.

~~~~javascript
// Just because isValid needs to return a promise
var Promise = require('bluebird');

var ValidatorAbstract = require('uval/validator/Abstract');

function MultipleOf3Validator() {};

MultipleOf3Validator.prototype = ValidatorAbstract;

MultipleOf3Validator._isValid = function(input, context) {
    this._failureData = this._getStandardFailureData();

    if (isNaN(input)) {
        this._failureData.type = 'multipleOf3Validator/isNaN';
        return Promise.resolve(false);
    }

    var mod3 = input % 3;
    if (mod3 === 0)) {
        return Promise.resolve(true);
    }

    this._failureData.type = 'multipleOf3Validator/notAMultipleOf3';
    return Promise.resolve(false);
};
~~~~

### Maiden name validator

To use a context, note that context is also available as second argument of a
GenericValidator.

~~~~javascript
// Just because isValid needs to return a promise
var Promise = require('bluebird');

var ValidatorAbstract = require('uval/validator/Abstract');

function MaidenNameValidator() {};

MaidenNameValidator.prototype = ValidatorAbstract;

MaidenNameValidator._isValid = function(input, context) {
    this._failureData = this._getStandardFailureData();

    if ((typeof(input) === 'undefined') || (input === '')) {
        return Promise.resolve(true);
    }

    if (context.gender === 'male') {
        this._failureData.type =
            'maidenNameValidator/isMaleAndNotEmptyMaidenName';
        return Promise.resolve(false);
    }

    if (context.gender !== 'female') {
            this._failureData.type =
                'maidenNameValidator/unrecognizedGenderAndNotEmptyMaidenName';
            return Promise.resolve(false);
    }

    return Promise.resolve(true);
};
~~~~