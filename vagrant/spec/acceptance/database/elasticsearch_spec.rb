
# encoding: utf-8

require File.expand_path('../../../spec_helper', __FILE__)

module Backup
describe 'Database::Elasticsearch' do
  specify 'flush, no close' do
    create_model :my_backup, <<-EOS
      Backup::Model.new(:my_backup, 'a description') do
        database Elasticsearch do |db|
          db.invoke_flush = true
          db.invoke_close = false
          db.index = "fakedex"
          db.path = '/var/lib/elasticsearch/elasticsearch'
        end
        store_with Local
      end
    EOS

    job = backup_perform :my_backup

    expect( job.package.exist? ).to be_true
    expect( job.package ).to match_manifest(%q[
      40900..50000  my_backup/databases/Elasticsearch.tar
    ])
  end
end
end
