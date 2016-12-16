---
layout: page
title: What you will find and not find in uval
menuTitle: What you will find and not find
permalink: /what-you-will-find-not-find.html
---

Features
---

* A generic validation system mostly represented by an **abstract validation class**, `uval/validator/Abstract`.
* A few **validators available from known validation libraries** available through the registry, `uval/registry`, you can add your own easily be using `uval/validator/Generic`.
* A few validation utilities that lets you:

    * Compose an **object level validation** `uval/validator/Object`
    * Compose a validation chain `uval/validator/ValidationChain` which is ensuring that the input valids **all** the provided validators
    * Make an **or** over a set of validators `uval/validator/Or` where the input must valid **at least one** validator
    * Apply a **validation over** all elements of **an array** `uval/validator/Array`

* A failure data retrieval logic that let you do whatever you want to handle the error and the translation through the usage of the `getFailureData()` method.
* Support a context for validation, the validate function takes a second `context` argument and broadcast it to all subvalidators when any.
* Handle asynchronous validation since everything is made of promise (after version 1.0.0)

What you will not find in uval
---

* No mechanism handling the translation is provided. You are supposed to do this by handling what comes out of `getFailureData()`. **Error identifiers are on purpose non english string**, a correct error handling should include a translation of the error message and maybe a retrieval of the input or the context, this is out of our scope.
* uval can be use in anything that supports require (e.g.: node backend developement or front end through browserify).

Similar projects
---

Available as npm packages:

* [is-validation](https://www.npmjs.org/package/is-validation)
* [nod-validation](https://www.npmjs.org/package/nod-validation)
* [object-validation](https://www.npmjs.org/package/object-validation)
