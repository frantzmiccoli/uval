{expect} = require 'chai'

registry = require 'uval/registry'
OrValidator = registry['uval.or']
orValidator = new OrValidator

registry = require 'uval/registry'
isNotSetValidator = registry['uval.isnotset']()
urlValidator = registry['validator.isurl']()

describe 'OrValidator', ->

  it 'should validate with no validators', ->
    expect(orValidator.validate()).to.be.true

  it 'should return validate if at least one validator passes', ->
    orValidator.add(isNotSetValidator)
    orValidator.add(urlValidator)
    expect(orValidator.validate()).to.be.true
    expect(orValidator.validate('http://www.google.fr/')).to.be.true

  it 'should return the last failed validator failure data', ->
    expect(orValidator.validate('That\’s unexpected')).to.be.false
    failureData = orValidator.getFailureData()
    urlFailureData = urlValidator.getFailureData()
    expect(failureData).to.be.equal urlFailureData

