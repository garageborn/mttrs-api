Paloma.controller('Admin/Links', {
  index: () => {
    const publishersSelect = $('#links_publisher_slug')
    const categoriesSelect = $('#links_category_slug')
    const tagsSelect = $('#links_tag_slug')

    const filter = () => {
      const params = {
        publisher_slug: publishersSelect.val(),
        category_slug: categoriesSelect.val(),
        tag_slug: tagsSelect.val()
      }
      Turbolinks.visit(Routes.admin_links_path(params))
    }

    publishersSelect.change(filter)
    categoriesSelect.change(filter)
    tagsSelect.change(filter)
  },

  uncategorized: () => {
    const select = $('#uncategorized_links_publisher_id')
    select.change(() => {
      const route = Routes.uncategorized_admin_links_path({ publisher_slug: select.val() })
      Turbolinks.visit(route)
    })
  },

  untagged: () => {
    const publishersSelect = $('#untagged_links_publisher_slug')
    const categoriesSelect = $('#untagged_links_category_slug')

    const filter = () => {
      const params = {
        publisher_slug: publishersSelect.val(),
        category_slug: categoriesSelect.val()
      }
      Turbolinks.visit(Routes.untagged_admin_links_path(params))
    }

    publishersSelect.change(filter)
    categoriesSelect.change(filter)
  }
})
