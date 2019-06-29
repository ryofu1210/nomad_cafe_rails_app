CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['S3_REGION']
  }

  config.fog_directory  = ENV['BUCKET']
  config.asset_host = ENV['ASSET_HOST']
  config.cache_storage = :fog
end
