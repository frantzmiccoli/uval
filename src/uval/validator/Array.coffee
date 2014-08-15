ValidatorAbstract = require 'uval/validator/Abstract'


###
  getFailureData().subFailureData contains an array of FailureData that can be
  undefined if the validation worked for the corresponding entry

###
class ArrayValidator extends ValidatorAbstract

  constructor: (@_validator, @_failureTypePrefix = 'uval/validator/Array/') ->
    super()
    @_failureData = []

  setValidator: (validator) =>
    @_validator = validator

  getFailureData: =>
    @_failureData

  _isValid: (input, context) =>
    @_failureData = @_getStandardFailureData(input, context)
    unless @_isArray(input)
      @_failureData.type = @_failureTypePrefix + 'notAnArray'
      return false

    valid = true
    for value in input
      unless @_validator.validate(value)
        valid = false
        @_failureData.subFailureData.push(@_validator.getFailureData())
      else
        @_failureData.subFailureData.push(undefined)

    unless valid
      @_failureData.type = @_failureTypePrefix + 'subValidatorFailure'

    valid

  _reset: =>
    @_failureData = {}

  _isArray: (input) =>
    typeIsArray = Array.isArray ||
      ( value ) -> return {}.toString.call( value ) is '[object Array]'
    typeIsArray(input)

  _getStandardFailureData: (input, context) =>
    failureData = super(input, context)
    failureData.configuration =
      validator: @_validator
    failureData.subFailureData = []
    failureData


module.exports = ArrayValidator