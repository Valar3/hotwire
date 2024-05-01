# frozen_string_literal: true

class ImportRecordsController < ApplicationController
  before_action :set_import

  def edit
    @import_records = @import.import_records
  end

  def update
    @import_record = ImportRecord.find(params[:id])
    if @import_record.update(import_record_params)
      respond_to do |format|
        format.html { redirect_to edit_import_path(@import), notice: 'Import record successfully updated.' }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream
      end
    end
  end

  private

  def set_import
    @import = Import.find(params[:import_id])
  end

  def import_record_params
    params.require(:import_record).permit(data: [:author, :content])
  end
end
