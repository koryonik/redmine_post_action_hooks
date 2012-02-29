# Redmine sample plugin
require 'redmine'
require_dependency 'redmine_post_action_hooks'

RAILS_DEFAULT_LOGGER.info 'Starting Redmine Post-Action Hooks'

Redmine::Plugin.register :redmine_post_action_hooks do
  name 'Redmine Post-Action Hooks'
  author 'Tonni Aagesen'
  url 'https://github.com/ta/redmine_post_action_hooks'
  description 'Sends a HTTP POST request with information about some action to a URL of your choice'
  version '0.0.1'
end
