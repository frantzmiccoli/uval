
ValidatorAbstract = require 'uval/validator/Abstract'

###
The use case addressed by this validator is the need to combine validators.

For example, the user can be let with the option to left the field empty OR type
in a valid email.

This validator failureData is the last validator failureData. In the above
example if the field is set, but the email not validating it's logical to return
the failureData from the email validator.
###
class OrValidator extends ValidatorAbstract

  # coffeelint: disable=missing_fat_arrows
  constructor: (@_validators = []) ->
  # coffeelint: enable=missing_fat_arrows

  add: (validator) =>
    @_validators.push validator

  getFailureData: =>
    @_failureData

  _isValid: (input, context) =>
    if @_validators.length == 0
      return true
    lastFailureData
    for validator in @_validators
      isValid = validator.validate(input, context)
      if isValid
        return true
      lastFailureData = validator.getFailureData()
    @_failureData = lastFailureData
    return false

  _reset: =>
    @_failureData = undefined

  module.exports = OrValidator