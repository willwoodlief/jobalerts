class BaseSerializer < ActiveModel::Serializer
  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.updated_at
  end

  def created_at_timestamp
    object.created_at.to_i if object.created_at
  end

  def updated_at_timestamp
    object.updated_at.to_i if object.updated_at
  end

end
