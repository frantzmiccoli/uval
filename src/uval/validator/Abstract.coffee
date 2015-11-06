
###
Validator MUST be used by calling their validate() method and eventually
their getFailureData() method to get information about the failure.

FailureData have the following form:
```
{
  type: "validatorFailueType",
  configuration: { ... },
  input: "The input on which it has failed can be something else than" +
                " a string",
  subFailureData: {
    ...
  }
}
```
* type (string) : identifies the kind of validator failure this is.
  You can use it to automate the processing of the validation failure
  (their associated message for example). the path to the validator
  MAY be used as a prefix could be a good idea
* configuration (Array|Object): describes the validator configuration
* input (anything): contains a pointer to the validated input that failed
* context (anything): contains a pointer to the context provided with the input
* subFailureData (Array|Object): if this validator contain sub validator,
  their data is here. Those failure data MUST be cached during the execution of
  the validator to avoid to fail on the _reset() of a subvalidator

Every validator's state MUST be reseted through an override of _reset method.
###
class ValidatorAbstract

  validate: (input, context) =>
    @_reset()
    @_isValid(input, context)

  getFailureData: =>
    throw new Exception("getFailureData must be implemented by the subclass.")

  _isValid: (input, context) =>
    throw new Exception("_isValid must be implemented by the subclass.")

  _reset: =>
    # Override to implement object state reset

  _getStandardFailureData: (input, context) =>
    failureData =
      input: input
      context: context
    failureData

module.exports = ValidatorAbstract