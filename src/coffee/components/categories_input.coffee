z = require 'zorium'

module.exports = class CategoriesInput
  constructor: -> null

  render: ->
    z 'div.categories-input',
      z 'label.categories-input-checkbox-container',
        z 'input', type: 'checkbox', name: 'action'
        'Action'
      z 'label.categories-input-checkbox-container',
        z 'input', type: 'checkbox', name: 'puzzle'
        'Puzzle'
      z 'label.categories-input-checkbox-container',
        z 'input', type: 'checkbox', name: 'sports'
        'Sports'
      z 'label.categories-input-checkbox-container',
        z 'input', type: 'checkbox', name: 'strategy'
        'Strategy'
