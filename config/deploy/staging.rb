set :branch, ENV["branch"] || 'issue/8971'

server deploysecret(:server), user: deploysecret(:user), roles: %w[web app db importer cron background]
