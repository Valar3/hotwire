# frozen_string_literal: true

class ImportService
  def initialize(file, import)
    @file = file
    @import = import
  end

  def call
    process_file(@file, @import)
  end

  private

  def process_file(file, _import)
    xlsx = Roo::Excelx.new(file)
    headers = xlsx.row(1)

    xlsx.each_row_streaming(offset:1, pad_cells: true) do |row|
      row_data = {}
      headers.each_with_index do |header, index|
        value = row[index]&.value

        row_data[header] = value
      end

      import_record = ImportRecord.new(
        data: row_data,
        import_id: @import.id
      )

      if import_record.valid?
        import_record.save
      else
        import_record.error_messages = import_record.errors.full_messages
        import_record.save(validate: false)
        @import.increment!(:errors_count, import_record.error_messages.count)
      end
    end
  end
end
