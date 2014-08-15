{expect} = require 'chai'

ValidationChain = require 'uval/validator/ValidationChain'
registry = require 'uval/registry'

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
    expect(validator.validate(undefined)).to.equal false
    subFailureData = validator.getFailureData().subFailureData
    expect(subFailureData.length).to.equal 3

  it 'should success correct object', ->
    expect(validator.validate({})).to.equal true
    expect(validator.validate('a string')).to.equal true
    expect(validator.validate(42)).to.equal true
    subFailureData = validator.getFailureData().subFailureData
    expect(subFailureData.length).to.equal 3
    expect(subFailureData[0]).to.be.undefined
    expect(subFailureData[1]).to.be.undefined
    expect(subFailureData[2]).to.be.undefined
