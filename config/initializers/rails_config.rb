RailsConfig.setup do |config|
  config.const_name = "Settings"
  RIGHTS_STATEMENTS = YAML.load_file("#{Rails.root.to_s}/config/rights_statements.yml")
end
