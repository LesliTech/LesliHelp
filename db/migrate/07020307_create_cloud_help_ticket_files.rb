class CreateCloudHelpTicketFiles < ActiveRecord::Migration[6.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join('db','structure','00000000_files.json')))
        create_table :cloud_help_ticket_files do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        create_table :active_storage_blobs do |t|
            t.string   :key,        null: false
            t.string   :filename,   null: false
            t.string   :content_type
            t.text     :metadata
            t.bigint   :byte_size,  null: false
            t.string   :checksum,   null: false
            t.datetime :created_at, null: false
            t.index [ :key ], unique: true
        end
        create_table :active_storage_attachments do |t|
            t.string     :name,     null: false
            t.references :record,   null: false, polymorphic: true, index: false
            t.references :blob,     null: false
            t.datetime :created_at, null: false
            t.index [ :record_type, :record_id, :name, :blob_id ], name: "index_active_storage_attachments_uniqueness", unique: true
            t.foreign_key :active_storage_blobs, column: :blob_id
        end
        add_reference :cloud_help_ticket_files, :cloud_help_tickets, foreign_key: true
    end
end
