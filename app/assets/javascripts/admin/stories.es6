const addedClassName = 'story-form-link--added'
const removedClassName = 'story-form-link--removed'
const buttonSelector = 'a.story-form-link-button'
const formSelector = 'form.edit_story'
const addedInputName = 'story[added_links][]'
const removedInputName = 'story[removed_links][]'

class StoryFormLinksActions {
  constructor (tableSelector) {
    this.form = $(formSelector)
    this.toggle = this.toggle.bind(this)
    $(tableSelector).find(buttonSelector).bind('click', this.toggle)
  }

  clear (tr) {
    tr.removeClass(removedClassName).removeClass(addedClassName)
    this.form.find(`input[name='${ addedInputName }'][value=${ tr.data('id') }]`).remove()
    this.form.find(`input[name='${ removedInputName }'][value=${ tr.data('id') }]`).remove()
  }

  add (tr) {
    this.clear(tr)
    tr.addClass(addedClassName).find(buttonSelector).text('remove')
    this.form.find('div.story_added_links').append(`
      <input
        type='text'
        name='${ addedInputName }'
        value=${ tr.data('id') }
        class='text optional'
      >
    `)
  }

  remove (tr) {
    this.clear(tr)
    tr.addClass(removedClassName).find(buttonSelector).text('add')
    this.form.find('div.story_removed_links').append(`
      <input
        type='text'
        name='${ removedInputName }'
        value=${ tr.data('id') }
        class='text optional'
      >
    `)
  }

  toggle (event) {
    event.preventDefault()
    let button = $(event.target)
    let tr = button.parents('tr.story-form-link')
    button.text() === 'remove' ? this.remove(tr) : this.add(tr)
    return false
  }
}

class StoryAddSimilarLinks {
  constructor (selector) {
    this.container = $(selector)
  }

  run (query) {
    this.clear()

    let route = this.buildRoute(query)
    this.xhr = $.get(route, (data) => {
      let table = $(data)
      this.container.append(table)
      new StoryFormLinksActions(table)
    })
  }

  clear () {
    this.container.find('table').remove()
    if (this.xhr) this.xhr.abort()
  }

  buildRoute(query) {
    let storyId = $('#story_id').val()
    return Routes.similar_links_admin_story_path(storyId, {
      tenant_name: Tenant.current,
      query: query
    })
  }
}

class StoryFindSimilarLinks {
  constructor (selector) {
    this.handleQuery = _.debounce(this.handleQuery.bind(this), 2000)
    this.addSimilar = new StoryAddSimilarLinks(selector)
    this.input = $(selector).find('form input')
    this.input.keydown(this.handleQuery)
  }

  handleQuery () {
    this.validQuery ? this.addSimilar.run(this.query) : this.addSimilar.clear()
  }

  get query () {
    return this.input.val()
  }

  get validQuery() {
    return this.query.length > 3
  }
}

Paloma.controller('Admin/Stories', {
  edit () {
    new StoryFormLinksActions('.current-links table')
    new StoryAddSimilarLinks('.other-links').run()
    new StoryFindSimilarLinks('.find-links')
  }
})
