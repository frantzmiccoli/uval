GenericValidator = require 'uval/validator/Generic'
OrValidator = require 'uval/validator/Or'
ArrayValidator = require 'uval/validator/Array'
ValidationChain = require 'uval/validator/ValidationChain'
ObjectValidator = require 'uval/validator/Object'

registry = {}

isSet = (input) =>
  if input
    return true
  false

registry['uval.isset'] = ->
  new GenericValidator(isSet, 'uval/validator/isset/notSet')

registry['uval.isnotset'] = ->
  new GenericValidator((input) ->
    !isSet(input)
  , 'uval/validator/isnotset/set')

registry['uval.or'] = (args...) ->
  new OrValidator(args...)

registry['uval.array'] = (args...) ->
  new ArrayValidator(args...)

registry['uval.validationchain'] = (args...) ->
  new ValidationChain(args...)

registry['uval.object'] = (args...) ->
  new ObjectValidator(args...)

nodeValidator = require 'validator'

registry['validator.isurl'] = ->
  new GenericValidator(nodeValidator.isURL, 'validator/isurl/notAnUrl')

registry['validator.isnumeric'] = ->
  new GenericValidator(nodeValidator.isNumeric,
    'validator/isnumeric/notNumeric')

registry['validator.isfloat'] = ->
  new GenericValidator(nodeValidator.isFloat, 'validator/isfloat/notFloat')

registry['validator.isin'] = (values) ->
  new GenericValidator(nodeValidator.isIn,
      'validator/isin/notInArray',
      values)

_ = require 'lodash'

registry['_.isarray'] = ->
  new GenericValidator(_.isArray, '_/isarray/notAnArray')

registry['_.isboolean'] = ->
  new GenericValidator(_.isBoolean, '_/isboolean/notABoolean')

registry['_.isstring'] = ->
  new GenericValidator(_.isString, '_/isstring/notAString')

module.exports = registry
