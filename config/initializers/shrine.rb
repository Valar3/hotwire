# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/file_system'
require 'shrine/storage/s3'
require 'shrine/storage/memory'

Shrine.storages =
  if Rails.env.development?
    {
      cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
      store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads')
    }
  elsif Rails.env.staging? || Rails.env.internal_qa?
    digital_ocean_opts = {
      bucket: Rails.application.credentials[:digital_ocean_bucket_staging],
      region: Rails.application.credentials[:digital_ocean_region],
      access_key_id: Rails.application.credentials[:digital_ocean_api_key],
      secret_access_key: Rails.application.credentials[:digital_ocean_api_secret],
      endpoint: Rails.application.credentials[:digital_ocean_endpoint]
    }

    {
      cache: Shrine::Storage::S3.new(prefix: 'cache', upload_options: { acl: 'public-read' }, **digital_ocean_opts),
      store: Shrine::Storage::S3.new(upload_options: { acl: 'public-read' }, **digital_ocean_opts)
    }
  elsif Rails.env.production?
    digital_ocean_opts = {
      bucket: Rails.application.credentials[:digital_ocean_bucket_production],
      region: Rails.application.credentials[:digital_ocean_region],
      access_key_id: Rails.application.credentials[:digital_ocean_api_key],
      secret_access_key: Rails.application.credentials[:digital_ocean_api_secret],
      endpoint: Rails.application.credentials[:digital_ocean_endpoint]
    }

    {
      cache: Shrine::Storage::S3.new(prefix: 'cache', upload_options: { acl: 'public-read' }, **digital_ocean_opts),
      store: Shrine::Storage::S3.new(upload_options: { acl: 'public-read' }, **digital_ocean_opts)
    }
  else
    {
      cache: Shrine::Storage::Memory.new,
      store: Shrine::Storage::Memory.new
    }
  end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :determine_mime_type
Shrine.plugin :validation_helpers, default_messages: {
  max_size: ->(max)  { I18n.t('shrine.errors.max_size', max: "#{max / (1024 * 1024)}MB") },
  min_size: ->(min)  { I18n.t('shrine.errors.min_size', min:) },
  max_width: ->(max)  { I18n.t('shrine.errors.max_width', max:) },
  min_width: ->(min)  { I18n.t('shrine.errors.min_width', min:) },
  max_height: ->(max)  { I18n.t('shrine.errors.max_height', max:) },
  min_height: ->(min)  { I18n.t('shrine.errors.min_height', min:) },
  max_dimensions: ->(dims) { I18n.t('shrine.errors.max_dimensions', dims:) },
  min_dimensions: ->(dims) { I18n.t('shrine.errors.min_dimensions', dims:) },
  mime_type_inclusion: ->(list) { I18n.t('shrine.errors.mime_type_inclusion', list: list.join(', ')) },
  mime_type_exclusion: ->(list) { I18n.t('shrine.errors.mime_type_exclusion', list: list.join(', ')) },
  extension_inclusion: ->(list) { I18n.t('shrine.errors.extension_inclusion', list: list.join(', ')) },
  extension_exclusion: ->(list) { I18n.t('shrine.errors.extension_exclusion', list: list.join(', ')) }
}

class Shrine
  def upload(io, **options)
    if io.is_a?(ActionDispatch::Http::UploadedFile)
      super(io, **options, close: false) # don't close after upload
    else
      super
    end
  end
end
