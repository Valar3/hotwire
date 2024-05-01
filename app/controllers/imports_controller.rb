# frozen_string_literal: true

class ImportsController < ApplicationController
  before_action :set_import, only: %i[edit update import]
  # before_action :set_import_record, only: %i[edit update]
  def new; end

  def create
    @import = Import.new(
      file: params[:file]
    )
    if @import.save
      service = ImportService.new(params[:file], @import)
      service.call
      redirect_to edit_import_path(@import)
    else
      render :new
      flash.now[:alert] = 'Failed to create import. Please check the form for errors.'
    end
  end

  def edit
    @import = Import.find(params[:id])
    @import_records = @import.import_records
  end

  def   update
    @import_record = ImportRecord.find(params[:id])

    if @import_record.update(import_record_params)
      flash.now[:notice] = 'Import record successfully updated.'
      redirect_to edit_import_path(@import)
    else
      flash.now[:alert] = 'Failed to update the import record.'
    end
  end

  def import

      importer = CreateQuotesService.new(@import.id)
      importer.call
      redirect_to quotes_path,
                  notice: 'Import completed successfully.'
  end

  private

  def set_import_record
    @import_records = ImportRecord.find(params[:id])
  end

  def set_import
    @import = Import.find(params[:id])
  end

  def import_record_params
    params.require(:import_record).permit(data: {})
  end
end
