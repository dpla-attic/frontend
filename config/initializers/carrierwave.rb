CarrierWave.configure do |config|
  config.fog_credentials = Settings.fog.credentials.to_hash
  config.fog_directory = Settings.fog.directory
  # config.fog_public defaults to true, so we are not setting it here
end