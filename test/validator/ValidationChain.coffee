{expect} = require 'chai'

registry = require 'uval/registry'
ValidationChain = registry['uval.validationchain']

validator = new ValidationChain()

describe 'ValidationChain', ->
  it 'should start empty', ->
    expect(validator._validators.length).to.equal 0

  it 'should accept new validators', ->
    validator.add(registry['uval.isset']())
    validator.add(registry['uval.isset']())
    validator.add(registry['uval.isset']())
    expect(validator._validators.length).to.equal 3

  it 'should fail on incorrect objects', ->
    validator.validate(undefined).then (isValid) ->
      expect(isValid).to.equal false

      subFailureData = validator.getFailureData().subFailureData
      expect(subFailureData.length).to.equal 3

  it 'should success correct object', ->
    validator.validate({}).then (isValid) ->
      expect(isValid).to.equal true

      validator.validate('a string')
    .then (isValid) ->
      expect(isValid).to.equal true

      validator.validate(42)
    .then (isValid) ->
      expect(isValid).to.equal true

      subFailureData = validator.getFailureData().subFailureData
      expect(subFailureData.length).to.equal 3
      expect(subFailureData[0]).to.be.undefined
      expect(subFailureData[1]).to.be.undefined
      expect(subFailureData[2]).to.be.undefined
