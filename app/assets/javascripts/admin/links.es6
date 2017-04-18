Paloma.controller('Admin/Links', {
  index: () => {
    let publishersSelect = $('#links_publisher_slug')
    let categoriesSelect = $('#links_category_slug')
    let tagsSelect = $('#links_tag_slug')

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
    let select = $('#uncategorized_links_publisher_id')
    select.change(() => {
      let route = Routes.uncategorized_admin_links_path({ publisher_slug: select.val() })
      Turbolinks.visit(route)
    })
  }
})
