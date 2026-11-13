import '@unocss/reset/tailwind.css'
import 'virtual:uno.css'
import 'tippy.js/dist/tippy.css'

import { createInertiaApp } from 'inertiax-svelte'
import Default from '~/layouts/default.svelte'
createInertiaApp({
  pages: "../pages",
  layout: () => Default,
  withApp(app, { ssr }) {
    if (ssr) return;
  }
})
