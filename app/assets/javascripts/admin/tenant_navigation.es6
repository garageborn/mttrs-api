$(document).on('turbolinks:load', () => {
  let select = $('.header-tenant select')
  select.change((e) => {
    let route = Routes.admin_stories_path({ tenant_name: select.val() })
    Turbolinks.visit(route)
  })
})
