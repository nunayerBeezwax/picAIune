class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
    	t.string :text
    	t.string :choice1
    	t.string :choice2
    	t.string :choice3
    	t.string :choice4
    	t.string :answer
    end
  end
end
