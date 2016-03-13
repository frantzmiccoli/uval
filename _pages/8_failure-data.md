---
layout: page
title: Understanding failure data
permalink: /failure-data.html
---

The first thing you have to know about validation data is that validators have a
state, the state is reset everytime you call the `validate` method.

If the validate promise return says that the input is not valid, then you have
some failure data available, for those you can `getFailureData`, otherwise
nothing is guaranted about the content returned by `getFailureData`.

This is the kind of data you will get:

~~~javascript
{
  type: "validatorFailueType",
  configuration: { ... },
  input: "The input on which it has failed can be something else than" +
                " a string",
  subFailureData: {
    // can be an array as well
    // the items are other failure data
    ...
  }
}
~~~

If you implement a fully custom validator, you must follow and respect those
implement details.

type (string)
---

`type` is meant to tell you what went wrong, if you need to base your translation
messages on something that is probably `type`.

configuration (Array|Object)
---

Where the configuration of the validator is supposed to be represented.

input (anything)
---

`input` is whatever has been provided for validation.

context (anything)
---

`context` is whatever context has been provided for validation.

subFailureData (Array|Context)
---

Depending on the kind of validation system, there can be some `subFailureData`,
if you used an array validation or a chain of validator, this will be an
`Array`, if this was an object validation this will be an `Object`.

Items contained may be `undefined`, it means that this particular entry has not
reported a validation problem on the related validator.

For object validation, the `subFailureData` object's keys are the object keys.
