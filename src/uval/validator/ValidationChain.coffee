ValidatorAbstract = require 'uval/validator/Abstract'

###
  getFailureData().subFailureData contains an array containing undefined when
  the related validator validated successfully and the getFailureData() of the
  subValidator if it failed
###
class ValidationChain extends ValidatorAbstract

  constructor: (@_failureTypePrefix = 'uval/validator/ValidationChain/') ->
    super()
    @_validators = []
    @_failureData = {}

  add: (validator) =>
    @_validators.push(validator)

  getFailureData: =>
    return @_failureData

  _isValid: (input, context) =>
    @_failureData = @_getStandardFailureData(input, context)
    valid = true
    for validator in @_validators
      validatorSuccess = validator.validate(input, context)
      valid &&= validatorSuccess
      if !validatorSuccess
        @_failureData.subFailureData.push(validator.getFailureData())
      else
        @_failureData.subFailureData.push(undefined)
    valid

  _reset: =>
    @_failureData = {}

  _getStandardFailureData: (input, context) =>
    failureData = super(input, context)
    failureData.type = @_failureTypePrefix + 'subValidatorFailure'
    failureData.configuration =
      validators: @_validators
    failureData.subFailureData = []
    failureData

module.exports = ValidationChain

