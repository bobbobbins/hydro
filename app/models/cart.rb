class Cart < ActiveRecord::Base
  
  has_many :line_items, :dependent => :destroy

  accepts_nested_attributes_for :line_items

  def add_product(product, options, quantity)
    #current_item = line_items.where(product_id: product.id).first
    #if current_item
    # current_item.quantity += quantity
    #else
    if(!quantity.present? || quantity.to_i < 1)
      quantity = 1
    end
    pi = ProductImage.new
    current_image = pi.getImage(options, product.id)
    current_item = line_items.build(product_id: product.id, product_name: product.name, quantity: quantity, product_image_id: current_image[0].id, product_price: product.price)
    if(options.present?)
      current_options = OptionValue.find_all_by_id(options.values)
      current_options.each do |o|
        current_item.line_item_options.build(option_id: o.id, option_name: o.name)
      end
    end
    current_item
  end

end