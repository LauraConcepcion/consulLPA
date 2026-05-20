set :branch, ENV["branch"] || 'feat/banner-presupuestos-2026-2027'

server deploysecret(:server), user: deploysecret(:user), roles: %w[web app db importer cron background]
