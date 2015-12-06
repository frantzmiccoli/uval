Promise = require 'bluebird'

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

    promises = []
    valid = true
    for validator in @_validators
      validationPromise = validator.validate(input, context).then (isValid) ->
        {isValid: isValid, validator: validator}

      promises.push(validationPromise)

    Promise.all(promises).then (validationResults) =>
      @_handleValidationResults(validationResults)

  _handleValidationResults: (validationResults) =>
    valid = true
    for validationResult in validationResults
      unless validationResult.isValid
        valid = false
        subFailureData = validationResult.validator.getFailureData()
        @_failureData.subFailureData.push(subFailureData)
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

