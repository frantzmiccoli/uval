{expect} = require 'chai'

ObjectValidator = require 'uval/validator/Object'
registry = require 'uval/registry'

validator = new ObjectValidator()

describe 'ObjectValidator', ->
  it 'should start empty', ->
    validatorsKeys = (Object.keys(validator._validators))
    expect(validatorsKeys.length).to.equal 0

  it 'should accept new validators', ->
    validator.add('first_field', registry['uval.isset']())
    validator.add('secondField', registry['uval.isset']())
    validator.add('thirdField', registry['uval.isset']())
    validatorsKeys = (Object.keys(validator._validators))
    expect(validatorsKeys.length).to.equal 3

  it 'should process correctly undefined', ->
    expect(validator.validate(undefined)).to.equal false

  it 'should process correctly an empty object', ->
    expect(validator.validate({})).to.equal false
    subFailureData = validator.getFailureData().subFailureData
    expect(Object.keys(subFailureData).length).to.equal 3

  it 'should fail on incorrect objects', ->
    testObject = first_field: 12
    expect(validator.validate(testObject)).to.equal false
    subFailureData = validator.getFailureData().subFailureData
    expect(Object.keys(subFailureData).length).to.equal 2

  it 'should succeed correct object', ->
    testObject =
      first_field: 'why snake case ?'
      secondField: 2
      thirdField: 3
    expect(validator.validate(testObject)).to.equal true
    subFailureData = validator.getFailureData().subFailureData
    expect(Object.keys(subFailureData).length).to.equal 0
