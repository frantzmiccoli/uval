{expect} = require 'chai'

registry = require 'uval/registry'
ArrayValidator = registry['uval.array']

validator = new ArrayValidator()

describe 'ArrayValidator', ->
  it 'should start empty', ->
    expect(validator._validator).to.be.undefined

  it 'should accept a validator generator', ->
    validator.setValidatorGenerator(registry['uval.isset'])
    expect(validator._validatorGenerator).to.not.be.undefined

  it 'should validate an array matching filters', ->
    input = ['aa', 'bbb']
    validator.validate(input).then (isValid) ->
      expect(isValid).to.be.true

  it 'should fail on an array not matching filters', ->
    input = ['aa', undefined, 'bbb']
    validator.validate(input).then (isValid) ->
      expect(isValid).to.be.false

  it 'should provide an array of validation message matching input', ->
    input = ['aa', undefined, 'bbb']
    validator.validate(input).then (isValid) ->
      expect(isValid).to.be.false

      messages = validator.getFailureData().subFailureData
      expect(messages.length).to.be.equal 3
      expect(messages[0]).to.be.undefined
      # messages[1] is the error message for the second element validation
      expect(messages[1]).to.not.be.undefined
      expect(messages[2]).to.be.undefined

  it 'should validate when provided with an empty array', ->
    validator.validate([]).then (isValid) ->
      expect(isValid).to.be.true

  it 'should fail on non array values', ->
    validator.validate('This is not an array').then (isValid) ->
      expect(isValid).to.be.false