class XJob < ApplicationRecord
  belongs_to :engine_task
  attr_accessor :copy_original

  def self.from_native(object_from:)
    x = XJob.new
    a = object_from.class

    case
    when a <= Flancer::FreelancerJob then
      x.id= object_from.id
      x.engine = 'Flancer'
      x.is_read = object_from.is_read
      x.star_symbol = object_from.star_symbol
      x.star_color = object_from&.star_color&.paint&.to_name(true)
      x.description = ''
      x.description += object_from.description.to_s  unless object_from.description.blank?
      # noinspection RubyResolve
      x.description += "\n " + object_from.number_bids.to_s unless object_from.number_bids.blank?
      x.description += "\n " + object_from.tags.to_s  unless object_from.tags.blank?
      x.description += "\n " + object_from.status.to_s  unless object_from.status.blank?

      # noinspection RubyArgCount
      x.link = object_from.link

      x.price_hint = object_from.price_hint
      x.created_at = object_from.created_at
      x.updated_at = object_from.updated_at
      x.title = object_from.title
      x.comments = object_from.comments
      x.copy_original = object_from.dup
      x.copy_original.id = object_from.id
      x.copy_original.created_at = object_from.created_at
      x.copy_original.updated_at = object_from.updated_at
      x.internal_id = x.engine + ':' + x.copy_original.id.to_s
    else
      raise "Class #{a.to_s} not in XJob Conversion"
    end

    return x
  end

  def self.color_to_hex_string(color_string:)
    return nil if color_string.blank?
    return color_string.paint.to_hex
  end




  def self.native_by_internal_id(iid:)
    engine, id = iid.split(':')
    case engine
    when 'Flancer'
      return Flancer::FreelancerJob.find(id)
    else
      raise "cannot convert from internal id, engine not recognized [#{engine}]"
    end
  end




  def self.id_by_internal_id(iid:)
    raise "need internal id" if iid.blank?
    return iid.split(':').second
  end
end
