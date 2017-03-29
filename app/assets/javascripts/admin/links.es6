Paloma.controller('Admin/Links', {
  index: () => {
    let publishersSelect = $('#links_publisher_slug')
    let tagsSelect = $('#links_tag_slug')

    publishersSelect.change(() => {
      let route = Routes.admin_links_path({ publisher_slug: publishersSelect.val() })
      Turbolinks.visit(route)
    })

    tagsSelect.change(() => {
      let route = Routes.admin_links_path({ tag_slug: tagsSelect.val() })
      Turbolinks.visit(route)
    })
  },

  uncategorized: () => {
    let select = $('#uncategorized_links_publisher_id')
    select.change(() => {
      let route = Routes.uncategorized_admin_links_path({ publisher_slug: select.val() })
      Turbolinks.visit(route)
    })
  }
})
