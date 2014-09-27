z = require 'zorium'

module.exports = class CategoriesForm
  constructor: -> null

  render: ->
    z 'div.categories-form',
      z 'div.categories-form-checkbox-container',
        z 'input#category-action', type: 'checkbox', name: 'action'
        z 'label', {for: 'category-action'}, 'Action'
      z 'div.categories-form-checkbox-container',
        z 'input#category-puzzle', type: 'checkbox', name: 'puzzle'
        z 'label', {for: 'category-puzzle'}, 'Puzzle'
      z 'div.categories-form-checkbox-container',
        z 'input#category-sports', type: 'checkbox', name: 'sports'
        z 'label', {for: 'category-sports'}, 'Sports'
      z 'div.categories-form-checkbox-container',
        z 'input#category-strategy', type: 'checkbox', name: 'strategy'
        z 'label', {for: 'category-strategy'}, 'Strategy'
