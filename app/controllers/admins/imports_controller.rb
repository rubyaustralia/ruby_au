class Admins::ImportsController <  Admins::BaseController
  def new
    @import = current_user.imports.build
  end

  def create
    attrs = params.require(:import)

    @import = current_user.imports.build
    @import.name = attrs[:name]
    @import.csv = attrs[:csv]&.read

    if @import.save
      ProcessCsvJob.perform_async(@import.id)

      redirect_to admins_import_path(@import)
    else
      render :new
    end
  end

  def index
    @imports = Import.all.order(id: :desc)
  end

  def show
    @import = Import.find(params[:id])
  end
end
