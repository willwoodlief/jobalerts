class CreateXJobs < ActiveRecord::Migration[5.1]


  def change
    create_table :x_jobs do |t|
      t.boolean :is_read, null:false, default:false
      t.integer :star_color, default: nil, null: true
      t.string :star_symbol, default: nil, null: true
      t.string :internal_id,  null: false
      t.text :link, default: nil, null: true

      t.string :engine , default: nil, null:true
      t.text :price_hint, default: nil, null: true

      t.text :title, default: nil, null: true
      t.text :description, default: nil, null: true


      t.text :comments, default: nil, null: true
      t.timestamps
    end


    add_index :x_jobs, [:is_read]
    add_index :x_jobs, [:star_color]
    add_index :x_jobs, [:star_symbol], :length => 4
    add_index :x_jobs, [:link],  :unique => true, :length => 210
    add_index :x_jobs, [:internal_id],  :unique => true, :length => 20
  end
end
