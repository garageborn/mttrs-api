const TENANT_NAMES = [
  'mttrs_us',
  'mttrs_br',
  'mttrs_ar',
  'mttrs_cl',
  'mttrs_mx',
  'mttrs_pt',
  'mttrs_us_es',
  'mttrs_au',
  'mttrs_ca',
  'mttrs_de',
  'mttrs_es',
  'mttrs_uk'
]
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
      const tenantPath = window.location.pathname.split('/')[2]
      return tenantName === tenantPath
    })
    this.current = tenant || DEFAULT_TENANT
  }
}

$(document).on('turbolinks:load', () => { Tenant.init() })
Tenant.init()
