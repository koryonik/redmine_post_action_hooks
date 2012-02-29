require "net/https"

# See list of hooks: http://www.redmine.org/projects/redmine/wiki/Hooks_List

class RedminePostActionHooks < Redmine::Hook::Listener
  @@dispatch_url = nil

  def controller_issues_new_after_save(context = { })
    unless context[:issue].is_private
      context[:event] = "controller_issues_new_after_save"
      context[:url] = "#{Setting.protocol}://#{Setting.host_name}/issues/#{context[:issue].id}"
      context[:user] = context[:issue].author
      context[:assignee] = context[:issue].assigned_to
      context.reject! { |k,_| ![:event,:url,:project,:issue,:user,:assignee].index(k) }
      dispatch context
    end
  end
  
  def controller_issues_edit_after_save(context = { })
    unless context[:issue].is_private
      context[:event] = "controller_issues_edit_after_save"
      context[:url] = "#{Setting.protocol}://#{Setting.host_name}/issues/#{context[:issue].id}"
      context[:project] = context[:issue].project
      context[:user] = context[:journal].user
      context[:assignee] = context[:issue].assigned_to
      context.reject! { |k,_| ![:event,:url,:project,:issue,:journal,:user,:assignee].index(k) }
      dispatch context
    end
  end
  
  private

  def load_options
    unless @@dispatch_url
      options = YAML::load(File.open(File.join(Rails.root, 'config', 'redmine_post_action_hooks.yml')))
      @@dispatch_url = options[Rails.env]['url']
    end
  end

  def dispatch(context)
    load_options
    
    if @@dispatch_url
      context[:user] = context[:user].attributes.except("auth_source_id", "salt", "hashed_password") if context[:user]
      context[:assignee] = context[:assignee].attributes.except("auth_source_id", "salt", "hashed_password") if context[:assignee]
      res = Net::HTTP.post_form(URI.parse(@@dispatch_url), { "payload" => context.to_json })
      RAILS_DEFAULT_LOGGER.warn "Plugin redmine_post_action_hooks: Failed to dispath information, server returned status #{res.code}: #{res.msg}" unless res.class == Net::HTTPSuccess
    else
      RAILS_DEFAULT_LOGGER.warn("Plugin redmine_post_action_hooks: Unable to read URL from #{Rails.root}/config/redmine_post_action_hooks.yml")
    end
  end
end