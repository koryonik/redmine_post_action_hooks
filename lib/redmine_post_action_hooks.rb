require "uri"
require "net/https"

# See list of hooks: http://www.redmine.org/projects/redmine/wiki/Hooks_List

class RedminePostActionHooks < Redmine::Hook::Listener
  @@dispatch_url = nil
  @@ssl_verify_none = nil

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
    if @@dispatch_url.nil? || @@ssl_verify_none.nil?
      options = YAML::load(File.open(File.join(Rails.root, 'config', 'redmine_post_action_hooks.yml')))
      @@dispatch_url = options[Rails.env]['url']
      @@ssl_verify_none = options[Rails.env]['ssl_verify_none']
    end
  end

  def dispatch(context)
    load_options
    
    if @@dispatch_url
      context[:user] = context[:user].attributes.except("auth_source_id", "salt", "hashed_password") if context[:user]
      context[:assignee] = context[:assignee].attributes.except("auth_source_id", "salt", "hashed_password") if context[:assignee]

      begin
        uri = URI.parse(@@dispatch_url)
        
        http = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == "https"
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE if @@ssl_verify_none
        end

        post = Net::HTTP::Post.new(uri.request_uri)
        post.set_form_data({ "payload" => context.to_json(:root => false) })

        res = http.request(post)
        RAILS_DEFAULT_LOGGER.warn "Plugin redmine_post_action_hooks: Failed to dispath information, server returned status #{res.code}: #{res.msg}" unless res === Net::HTTPSuccess
      rescue Exception => e
        RAILS_DEFAULT_LOGGER.warn "Plugin redmine_post_action_hooks: Caught an Exception: #{e.class} with message \"#{e.message}\""
      end

    else
      RAILS_DEFAULT_LOGGER.warn("Plugin redmine_post_action_hooks: Unable to read URL from #{Rails.root}/config/redmine_post_action_hooks.yml")
    end
  end
end
