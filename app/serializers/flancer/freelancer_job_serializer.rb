class Flancer::FreelancerJobSerializer < ActiveModel::Serializer
  attributes :id,:is_read, :star_symbol, :star_color,:link,:price_hint,:created_at,
             :description, :title, :comments

  def description
    # @type  [FreelancerJob] object
    out = ''
    out += object.description.to_s  unless object.description.blank?

    out += "\n " + object.number_bids.to_s unless object.number_bids.blank?
    out += "\n " + object.tags.to_s  unless object.tags.blank?
    out += "\n " + object.status.to_s  unless object.status.blank?
    return out
  end

  def star_color
    return nil if object.star_color.blank?
    return object.star_color.to_s(16).paint.to_name(true)
  end
end
