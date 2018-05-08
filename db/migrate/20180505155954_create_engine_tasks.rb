class CreateEngineTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :engine_tasks do |t|
      t.string :engine,  null: false
      t.string :task, null:true
      t.boolean :is_started, null:false, default:false
      t.boolean :is_stopped, null:false, default:false
      t.boolean :is_error, null:false, default:false

      t.datetime :start , default: nil
      t.datetime :stop , default: nil
      t.timestamps
    end

    add_belongs_to :x_jobs, :engine_task, index: true, after: :id, default: nil
    add_foreign_key :x_jobs, :engine_tasks, column: :engine_task_id, primary_key: 'id',name: 'xjob_has_engine_task_fk'

  end
end
