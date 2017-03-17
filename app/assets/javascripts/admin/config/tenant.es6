const TENANT_NAMES = ['mttrs_us', 'mttrs_br']
const DEFAULT_TENANT = TENANT_NAMES[0]

class Tenant {
  static get current () {
    return this._current
  }

  static set current (tenantName) {
    this._current = tenantName

    Routes.options.default_url_options.tenant_name = tenantName
  }

  static init () {
    let tenant = TENANT_NAMES.find((tenantName) => {
      return location.pathname.match(`/${ tenantName }`)
    })
    this.current = tenant || DEFAULT_TENANT
  }
}

$(document).on('turbolinks:load', () => { Tenant.init() })
Tenant.init()
