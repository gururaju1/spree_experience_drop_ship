class Spree::Admin::ExperiencesController < Spree::Admin::ResourceController

  def edit
    @object.address = Spree::Address.default unless @object.address.present?
    respond_with(@object) do |format|
      format.html { render :layout => !request.xhr? }
      format.js   { render :layout => false }
    end
  end

  def new
    @object = Spree::Experience.new(address_attributes: {country_id: Spree::Address.default.country_id})
  end

  private

    def collection
      params[:q] ||= {}
      params[:q][:meta_sort] ||= "name.asc"
      @search = Spree::Experience.search(params[:q])
      @collection = @search.result.page(params[:page]).per(Spree::Config[:orders_per_page])
    end

    def find_resource
      Spree::Experience.friendly.find(params[:id])
    end

    def location_after_save
      spree.edit_admin_Experience_path(@object)
    end

end