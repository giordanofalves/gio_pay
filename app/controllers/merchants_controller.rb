class MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show, :chart_data]
  before_action :set_group_param, only: [:show, :chart_data]

  def index
    @merchants = Merchant.all
  end

  def show; end

  def chart_data
    @chart_data =  [
      {
        name: "Orders",
        data: parse_chart_data(@merchant.orders)
      },
      {
        name: "Disbursements",
        data: parse_chart_data(@merchant.disbursements)
      }
    ]
    render json: @chart_data
  end

  def update_chart_data
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('chart_data', partial: 'chart_data', locals: { merchant: @merchant })
      end
    end
  end

  private

  def set_merchant
    @merchant =Merchant.includes(:orders, :disbursements).find(params[:id])
  end

  def set_group_param
    @group_param = params[:group] || "group_by_month"
    @date_format =
      case @group_param
      when "group_by_day"
        "%d/%b/%y"
      when "group_by_week"
        "%d/%b/%y"
      when "group_by_month"
        "%b/%y"
      when "group_by_year"
        "%Y"
      end
  end

  def parse_chart_data(data)
    data.send(@group_param) { |u| u.created_at }.to_h { |k, v| [k.strftime(@date_format), v.pluck(:amount).sum] }
  end
end
