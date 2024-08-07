import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  head: [['link', { rel: 'icon', href: '/favicon.ico' }]],
  base: "/LuminNet/",
  title: "LuminNet",
  titleTemplate: ":title - Lumin",
  description: "A simple and efficient networking library",
  lastUpdated: true,
  lang: 'en-us',
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      {
        text: 'Articles',
        items: [
          { text: 'Guides', link: '/guides/' },
          { text: 'Installation', link: '/installation' },
        ]
      },

      { text: 'API', link: '/api/' },
      { text: 'Changelog', link: '/changelog' },
    ],

    sidebar: {
      '/guides': [
        {
          text: 'Guides',
          items: [
            { text: 'Setup', link: '/guides/' },
            { text: 'Events', link: '/guides/events' },
            { text: 'Functions', link: '/guides/functions' },
            { text: 'Ratelimiting', link: '/guides/ratelimiting' },
            { text: 'Type Validation', link: '/guides/type-validation' },
          ]
        }
      ],

      '/api': [
        {
          text: 'API Reference',
          items: [
            { text: 'Net', link: '/api/' },

            {
              text: 'Client',
              collapsed: true,
              items: [
                { text: 'Interface', link: '/api/client/' },
                { text: 'Event', link: '/api/client/event' },
                { text: 'Function', link: '/api/client/function' }
              ]
            },
            {
              text: 'Server',
              collapsed: true,
              items: [
                { text: 'Interface', link: '/api/server/' },
                { text: 'Event', link: '/api/server/event' },
                { text: 'Function', link: '/api/server/function' }
              ]
            },
          ]
        },
      ],
    },

    outline: [2, 3],

    search: {
      provider: 'local'
    },

    editLink: {
      pattern: 'https://github.com/lumin-dev/LuminNet/edit/main/docs/:path'
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/lumin-dev/LuminNet' },
      { icon: 'discord', link: 'https://lumin-dev.github.io/link/discord' },
    ]
  }
})