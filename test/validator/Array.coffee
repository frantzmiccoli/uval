{expect} = require 'chai'

registry = require 'uval/registry'
ArrayValidator = registry['uval.array']

validator = new ArrayValidator()

describe 'ArrayValidator', ->
  it 'should start empty', ->
    expect(validator._validator).to.be.undefined

  it 'should accept a validator', ->
    validator.setValidator(registry['uval.isset']())
    expect(validator._validator).to.not.be.undefined

  it 'should validate an array matching filters', ->
    input = ['aa', 'bbb']
    expect(validator.validate(input)).to.be.true

  it 'should fail on an array not matching filters', ->
    input = ['aa', undefined, 'bbb']
    expect(validator.validate(input)).to.be.false

  it 'should provide an array of validation message matching input', ->
    input = ['aa', undefined, 'bbb']
    expect(validator.validate(input)).to.be.false
    messages = validator.getFailureData().subFailureData
    expect(messages.length).to.be.equal 3
    expect(messages[0]).to.be.undefined
    # messages[1] is the error message for the second element validation
    expect(messages[1]).to.not.be.undefined
    expect(messages[2]).to.be.undefined

  it 'should validate when provided with an empty array', ->
    expect(validator.validate([])).to.be.true

  it 'should fail on non array values', ->
    expect(validator.validate('This is not an array')).to.be.false