{expect} = require 'chai'

registry = require 'uval/registry'
ObjectValidator = registry['uval.object']

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
    validator.validate(undefined).then (isValid) ->
      expect(isValid).to.equal false

  it 'should process correctly an empty object', ->
    validator.validate({}).then (isValid) ->
      expect(isValid).to.equal false

      subFailureData = validator.getFailureData().subFailureData
      expect(Object.keys(subFailureData).length).to.equal 3

  it 'should fail on incorrect objects', ->
    testObject = first_field: 12
    validator.validate(testObject).then (isValid) ->
      expect(isValid).to.equal false

      subFailureData = validator.getFailureData().subFailureData
      expect(Object.keys(subFailureData).length).to.equal 2

  it 'should succeed correct object', ->
    testObject =
      first_field: 'why snake case ?'
      secondField: 2
      thirdField: 3

    validator.validate(testObject).then (isValid) ->
      expect(isValid).to.equal true

      subFailureData = validator.getFailureData().subFailureData
      expect(Object.keys(subFailureData).length).to.equal 0
