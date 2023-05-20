class CreateUser < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :gender, null: false
      t.datetime :solar_birthday
      t.datetime :lunar_birthday
      t.string :year_gan
      t.string :year_zhi
      t.string :month_gan
      t.string :month_zhi
      t.string :day_gan
      t.string :day_zhi
      t.string :time_gan
      t.string :time_zhi
      t.string :qiyun # 起運
      t.string :dayun, array: true # 大運
      t.string :liunian, array: true # 流年
      t.integer :liunian_first_age # 流年首年歲數
      t.string :xunkong # 空亡
      t.string :qiangruo # 身強/弱
      t.string :xishen # 喜神
      t.string :jishen # 忌神
      t.string :xianshen # 閒神
      t.jsonb :notes

      t.timestamps
    end
  end
end
