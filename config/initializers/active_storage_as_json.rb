Rails.application.config.to_prepare do
  class ActiveStorage::Attachment < ActiveStorage::Record
    DEFAULT_OPTIONS = {
      only: [],
      methods: [ :id, :signed_id, :url, :name ]
    }

    def url(*args, **options)
      Rails.application.routes.url_helpers.rails_storage_proxy_path(self, only_path: true)
    end

    def serializable_hash(options = {})
      options.reverse_merge! DEFAULT_OPTIONS
      super(options)
    end
  end
end
