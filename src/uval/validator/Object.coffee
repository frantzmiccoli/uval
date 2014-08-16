ValidatorAbstract = require 'uval/validator/Abstract'

###
  getFailureData().validators contains the fields map to subValidator
  getFailureData().subFailureData is only filled if something as failed for the
  given field
###
class ObjectValidator extends ValidatorAbstract

  constructor: (@_failureTypePrefix = 'uval/validator/Object/') ->
    super()
    @_validators = {}
    @_failureData = {}

  add: (fieldName, validator) =>
    @_validators[fieldName] = validator

  getFailureData: =>
    return @_failureData

  _isValid: (input, context) =>
    @_failureData = @_getStandardFailureData(input, context)
    unless input
      @_failureData.type = @_failureTypePrefix + 'isUndefined'
      return false

    valid = true
    for fieldName, validator of @_validators
      validatorSuccess = validator.validate(input[fieldName], context)
      valid &&= validatorSuccess
      if !validatorSuccess
        @_failureData.subFailureData[fieldName] = validator.getFailureData()

    unless valid
      @_failureData.type = @_failureTypePrefix + 'subValidatorFailure'

    valid

  _reset: =>
    @_failureData = {}

  _getStandardFailureData: (input, context) =>
    failureData = super(input, context)
    failureData.configuration =
      validators: @_validators
    failureData.subFailureData = {}
    failureData


module.exports = ObjectValidator