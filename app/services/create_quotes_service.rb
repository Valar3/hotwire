# frozen_string_literal: true

class CreateQuotesService
      def initialize(import_id) # , user, portal_form)
        @import_id = import_id
        # @user = user
        # @portal_form = portal_form
      end

      def call
        ActiveRecord::Base.transaction do
          fetch_import
          import
        end
      end

      private

      def fetch_import
        @import = Import.find_by(id: @import_id)
      end

      def import
        return [] unless @import

        quotes = @import.import_records.map do |record|
          create_quote(record)
        end

        # @import.import!
        quotes
      end

      def create_quote(record)

        quotes = Quote.find_or_create_by!(author: record.data['author'], content: record.data['content'])

        begin
          quotes.save!
        rescue StandardError => e
          Rails.logger.error "Failed to save portal: #{e.message}"
          raise e
        end
        quotes
      end
    end
