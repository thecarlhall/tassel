Tassel.register_command 'quit', :mnemonic => :q do
  Tassel.save!
  exit
end
