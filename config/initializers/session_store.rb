session_store  = Settings.session.store.to_sym

if :dalli_store == session_store
  require 'action_dispatch/middleware/session/dalli_store'
end

sesson_options = { key: Settings.session.key }
sesson_options.merge! Settings.session[session_store].to_hash if Settings.session[session_store]
DplaPortal::Application.config.session_store session_store, sesson_options