Promise = require 'bluebird'

ValidatorAbstract = require 'uval/validator/Abstract'

class GenericValidator extends ValidatorAbstract

  constructor: (@_validationFunction,
                @_failureDataType,
                @_extraValidationArguments...) ->

  getFailureData: =>
    @_failureData

  _isValid: (input, context) =>
    @_failureData = @_getStandardFailureData(input, context)
    extraArguments = @_extraValidationArguments
    if context?
      extraArguments.unshift(context)
    Promise.resolve(@_validationFunction(input, extraArguments...))

  _getStandardFailureData: (input, context) =>
    failureData = super(input, context)
    failureData.type = @_failureDataType
    failureData.configuration =
      validationFunction: @_validationFunction
      extraValidationArguments: @_extraValidationArguments
    failureData


module.exports = GenericValidator