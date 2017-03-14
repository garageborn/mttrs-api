Paloma.controller('Admin/Stories', {
  edit: () => {
    const addedClassName = 'story-form-link--added'
    const removedClassName = 'story-form-link--removed'
    const buttonSelector = 'a.story-form-link-button'
    const form = $('form.edit_story')
    const addedInputName = 'story[added_links][]'
    const removedInputName = 'story[removed_links][]'

    const clear = (tr) => {
      tr.removeClass(removedClassName).removeClass(addedClassName)
      form.find(`input[name='${ addedInputName }'][value=${ tr.data('id') }]`).remove()
      form.find(`input[name='${ removedInputName }'][value=${ tr.data('id') }]`).remove()
    }

    const add = (tr) => {
      clear(tr)
      tr.addClass(addedClassName).find(buttonSelector).text('remove')
      form.append(`<input type='text' name='${ addedInputName }' value=${ tr.data('id') }>`)
    }

    const remove = (tr) => {
      clear(tr)
      tr.addClass(removedClassName).find(buttonSelector).text('add')
      form.append(`<input type='text' name='${ removedInputName }' value=${ tr.data('id') }>`)
    }

    const toggle = (event) => {
      let button = $(event.target)
      let tr = button.parents('tr.story-form-link')
      button.text() === 'remove' ? remove(tr) : add(tr)
      return false
    }

    $(`tr.story-form-link ${ buttonSelector }`).click(toggle)
  }
})
