{expect} = require 'chai'

registry = require 'uval/registry'
OrValidator = registry['uval.or']
orValidator = new OrValidator

registry = require 'uval/registry'
isNotSetValidator = registry['uval.isnotset']()
urlValidator = registry['validator.isurl']()

describe 'OrValidator', ->

  it 'should validate with no validators', ->
    orValidator.validate().then (isValid) ->
      expect(isValid).to.be.true

  it 'should return validate if at least one validator passes', ->
    orValidator.add(isNotSetValidator)
    orValidator.add(urlValidator)
    orValidator.validate().then (isValid) ->
      expect(isValid).to.be.true

      orValidator.validate('http://www.google.fr/')
    .then (isValid) ->
      expect(isValid).to.be.true

  it 'should return the last failed validator failure data', ->
    orValidator.validate('That\’s unexpected').then (isValid) ->
      expect(isValid).to.be.false
      failureData = orValidator.getFailureData()
      urlFailureData = urlValidator.getFailureData()
      expect(failureData).to.be.equal urlFailureData

