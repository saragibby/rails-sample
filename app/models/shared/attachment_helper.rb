module Shared
  module AttachmentHelper

    class << self
      def included(base)
        base.extend ClassMethods
      end
    end

    module ClassMethods
      def has_attachment(name, options = {})

        if Rails.env == 'test'
          # store images locally
          options[:path]  = ":rails_root/public/#{Rails.env}#{options[:path]}"
          options[:url]   = "#{Rails.env}#{options[:path]}"
        else
          options[:storage]         = :s3
          options[:s3_credentials]  = File.join(Rails.root, 'config', 's3.yml')          
        end

        # pass things off to paperclip.
        has_attached_file name, options
      end
    end
  end
end
