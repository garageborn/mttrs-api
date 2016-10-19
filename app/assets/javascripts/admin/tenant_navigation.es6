$(document).on('turbolinks:load', () => {
  let select = $('.header-tenant select')
  select.change((e) => {
    let route = Routes.admin_stories_path({ tenantName: select.val() })
    Turbolinks.visit(route)
  })
})
