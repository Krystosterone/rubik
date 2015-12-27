module AlertHelper
  CLASSES = { success: 'alert-success',
              error: 'alert-danger',
              alert: 'alert-warning',
              notice: 'alert-info' }.with_indifferent_access

  def alert_class(type)
    CLASSES.fetch(type, type)
  end
end
