class ChangeXJobsStarColor < ActiveRecord::Migration[5.1]
  def change
    change_column :x_jobs, :star_color, :string,null: true
  end
end
