# frozen_string_literal: true

# SequencingRuns Controller
class SequencingRunsController < ApplicationController
  attr_reader :sequencing_runs, :sequencing_run

  before_action :set_sequencing_run, only: %i[show]
  before_action :sequencing_runs, only: %i[index]

  def index; end

  def new
    @sequencing_run = SequencingRun.new
  end

  def create
    @sequencing_run = SequencingRun.new(sequencing_run_params)
    if sequencing_run.save
      redirect_to sequencing_run_path(sequencing_run), notice: 'Sequencing run successfully created'
    else
      render :new
    end
  end

  def show; end

  protected

  def sequencing_runs
    @sequencing_runs = SequencingRun.all
  end

  def set_sequencing_run
    @sequencing_run ||= current_resource
  end

  def current_resource
    @current_resource = SequencingRun.find(params[:id]) if params[:id].present?
  end

  def sequencing_run_params
    params.require(:sequencing_run).permit(:instrument_name,
                                           flowcells_attributes:
                                           %i[flowcell_id position work_order_id])
  end

  helper_method :sequencing_runs, :sequencing_run
end
