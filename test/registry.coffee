{expect} = require 'chai'

registry = require 'uval/registry'

describe 'ValidatorRegistry', ->
  it 'should contains an uval.isset', ->
    expect(registry).has['uval.isset']

describe 'ValidatorRegistry\'s contained uval.isset validator', ->
  it 'should correctly test what is set', ->
    isSet = registry['uval.isset']()
    isSet.validate(undefined).then (isValid) ->
      expect(isValid).to.be.false

      isSet.validate('')
    .then (isValid) ->
      expect(isValid).to.be.false

      isSet.validate('123')
    .then (isValid) ->
      expect(isValid).to.be.true

describe 'ValidatorRegistry\'s contained ported validator', ->
  it 'should correctly implement validator.isurl', ->
    isUrl = registry['validator.isurl']()
    isUrl.validate('Something else').then (isValid) ->
      expect(isValid).to.be.false

      isUrl.validate('http://google.co.uk')
    .then (isValid) ->
      expect(isValid).to.be.true

      isUrl.validate('ftp://kenagard.com')
    .then (isValid) ->
      expect(isValid).to.be.true

  it 'should correctly implement validator.isnumeric', ->
    isNumeric = registry['validator.isnumeric']()
    isNumeric.validate('Something else').then (isValid) ->
      expect(isValid).to.be.false

      isNumeric.validate(12)
    .then (isValid) ->
      expect(isValid).to.be.true

      isNumeric.validate('123')
    .then (isValid) ->
      expect(isValid).to.be.true

      isNumeric.validate(42.7)
    .then (isValid) ->
      expect(isValid).to.be.false

  it 'should correctly implement validator.isfloat', ->
    isFloat = registry['validator.isfloat']()
    isFloat.validate('Something else').then (isValid) ->
      expect(isValid).to.be.false

      isFloat.validate(1)
    .then (isValid) ->
      expect(isValid).to.be.true

      isFloat.validate(42.7)
    .then (isValid) ->
      expect(isValid).to.be.true

      isFloat.validate('-42.7')
    .then (isValid) ->
      expect(isValid).to.be.true

  it 'should correctly implement validator.isin', ->
    isIn = registry['validator.isin'](['accepted', 'tolerated'])
    isIn.validate('Something else').then (isValid) ->
      expect(isValid).to.be.false

      isIn.validate('accepted')
    .then (isValid) ->
      expect(isValid).to.be.true
