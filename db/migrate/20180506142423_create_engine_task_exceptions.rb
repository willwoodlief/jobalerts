class CreateEngineTaskExceptions < ActiveRecord::Migration[5.1]
  def change
    create_table :engine_task_exceptions do |t|
      t.belongs_to :engine_task, index: true, null: false
      t.integer :line, null:true, default:nil
      t.string :exception_class, null:false
      t.text :file, null:true, default:nil
      t.string :snapshot_file, null:true, default:nil
      t.string :html_file, null:true, default:nil
      t.text  :extra_message, null: true, default:nil
      t.text :message, null:true, default:nil
      t.text :stack_trace_as_json, null:true, default:nil
      t.timestamps
    end

    add_index :engine_task_exceptions, [:exception_class],  :unique => false, :length => 80
    add_index :engine_task_exceptions, [:line],  :unique => false
    add_index :engine_task_exceptions, [:file],  :unique => false, :length => 200
    add_foreign_key :engine_task_exceptions, :engine_tasks, column: :engine_task_id, primary_key: 'id',name: 'eeei_exceptions_has_engine_task_fk'

  end
end
