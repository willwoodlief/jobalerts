class XJobSerializer < BaseSerializer
  attributes :internal_id,:is_read, :star_symbol, :star_color,:link,:price_hint,:created_at,
             :description, :title, :comments

  def internal_id
    return object.internal_id.to_s
  end
end
