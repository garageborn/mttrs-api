$(document).ready(function() {
  var select = $('.header-tenant select')
  select.change(function(e){
    var tenant = select.val()
    Turbolinks.visit('/admin/' + tenant)
  })
})
