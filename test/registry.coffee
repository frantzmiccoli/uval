{expect} = require 'chai'

registry = require 'uval/registry'

describe 'ValidatorRegistry', ->
  it 'should contains an uval.isset', ->
    expect(registry).has['uval.isset']

describe 'ValidatorRegistry\'s contained uval.isset validator', ->
  it 'should correctly test what is set', ->
    isSet = registry['uval.isset']()
    expect(isSet.validate(undefined)).to.be.false
    expect(isSet.validate('')).to.be.false
    expect(isSet.validate('123')).to.be.true

describe 'ValidatorRegistry\'s contained ported validator', ->
  it 'should correctly implement validator.isurl', ->
    isUrl = registry['validator.isurl']()
    expect(isUrl.validate('Something else')).to.be.false
    expect(isUrl.validate('http://google.co.uk')).to.be.true
    expect(isUrl.validate('ftp://kenagard.com')).to.be.true

  it 'should correctly implement validator.isnumeric', ->
    isNumeric = registry['validator.isnumeric']()
    expect(isNumeric.validate('Something else')).to.be.false
    expect(isNumeric.validate(12)).to.be.true
    expect(isNumeric.validate('123')).to.be.true
    expect(isNumeric.validate(42.7)).to.be.false

  it 'should correctly implement validator.isfloat', ->
    isFloat = registry['validator.isfloat']()
    expect(isFloat .validate('Something else')).to.be.false
    expect(isFloat .validate(1)).to.be.true
    expect(isFloat .validate(42.7)).to.be.true
    expect(isFloat .validate('-42.7')).to.be.true

  it 'should correctly implement validator.isin', ->
    isIn = registry['validator.isin'](['accepted', 'tolerated'])
    expect(isIn.validate('Something else')).to.be.false
    expect(isIn.validate('accepted')).to.be.true
