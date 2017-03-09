Paloma.controller('Admin/Links', {
  index: () => {
    let select = $('#links_publisher_id')
    select.change(() => {
      let route = Routes.admin_links_path({ publisher_slug: select.val() })
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
