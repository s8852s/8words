require 'time'

class User < ApplicationRecord
  include UsersHelper

  has_rich_text :information

  attr_accessor :year, :month, :day, :hour, :minute

  after_save :update_liunian
  enum gender: { "男": 1, "女": 0 }
  XIANGKE = { '水': '火', '火': '金', '金': '木', '木': '土', '土': '水' }.freeze # 相剋
  XIANGSHENG = { '木': '火', '火': '土', '土': '金', '金': '水', '水': '木' }.freeze # 相生

  GAN = %w[甲 乙 丙 丁 戊 己 庚 辛 壬 癸].freeze # 天干
  GAN_WUXING = %w[木 木 火 火 土 土 金 金 水 水].freeze
  GAN_YINYANG = %w[陽 陰 陽 陰 陽 陰 陽 陰 陽 陰].freeze

  ZHI = %w[子 丑 寅 卯 辰 巳 午 未 申 酉 戌 亥].freeze # 地支
  ZHI_WUXING = %w[水 土 木 木 土 火 火 土 金 金 土 水].freeze
  ZHI_YINYANG = %w[陰 陰 陽 陰 陽 陽 陰 陰 陽 陰 陽 陽].freeze
  CANGZHI = %w[癸 己癸辛 甲丙戊 乙 戊乙癸 丙庚戊 丁己 己丁乙 庚戊壬 辛 戊辛丁 壬甲].freeze # 藏支

  GAN_XIANGHE = %w[甲己 乙庚 丙辛 丁壬 戊癸].freeze # 天干相合
  GAN_HEHUA_WUXING = %w[土 金 水 木 火].freeze # 天干合化五行
  GAN_XIANGKE = %w[甲戊 乙己 丙庚 丁辛 戊壬 己癸 庚甲 辛乙 壬丙 癸丁].freeze # 天干相剋

  ZHI_XIANGHE = %w[子丑 寅亥 卯戌 辰酉 巳申 午未].freeze # 地支六合
  ZHI_XIANGHE_WUXING = %w[土 木 火 金 水 火].freeze # 地支合化五行
  ZHI_XIANGCHONG = %w[子午 丑未 寅申 卯酉 辰戌 巳亥].freeze # 地支相沖
  ZHI_SANHUI = %w[寅卯辰 巳午未 申酉戌 亥子丑].freeze # 地支三會
  ZHI_SANHUI_WUXING = %w[木 火 金 水].freeze # 地支三會五行
  ZHI_SANHE = %w[亥卯未 巳酉丑 寅午戌 申子辰].freeze # 地支三合
  ZHI_SANHE_WUXING = %w[木 金 火 水].freeze # 地支三合五行
  ZHI_XIANGXING = %w[寅巳 寅申 巳申 丑未 丑戌 未戌 子卯 辰辰 午午 酉酉 亥亥].freeze # 地支相刑
  ZHI_XIANGXING_NOTES = %w[無恩之刑 無恩之刑 無恩之刑 持勢之刑 持勢之刑 持勢之刑 無禮之刑 自刑 自刑 自刑 自刑].freeze

  RELATIONSHIP = {
    gan_xianghe: GAN_XIANGHE,
    gan_xiangke: GAN_XIANGKE,
    zhi_xianghe: ZHI_XIANGHE,
    zhi_xiangchong: ZHI_XIANGCHONG,
    zhi_sanhui: ZHI_SANHUI,
    zhi_sanhe: ZHI_SANHE,
    zhi_xiangxing: ZHI_XIANGXING
  }

  def current_age
    this_year = Time.now.year
    user_birth_year = translate_birthday[:year].to_i
    this_year - user_birth_year
  end

  def gan
    [year_gan, month_gan, day_gan, time_gan]
  end

  def zhi
    [year_zhi, month_zhi, day_zhi, time_zhi]
  end

  def dayun_gan_zhi
    dayun_array = dayun.join('').split('')
    dayun_gan = []
    dayun_zhi = []

    dayun_array.each_with_index do |element, index|
      if index.odd?
        dayun_zhi << element
      else
        dayun_gan << element
      end
    end
    { gan: dayun_gan, zhi: dayun_zhi }
  end

  def key_gan
    he = gan.product(GAN_XIANGHE).map { |gan, xianghe| xianghe if xianghe.include?(gan) }.compact.uniq
    ke = gan.product(GAN_XIANGKE).map { |gan, xianghe| xianghe if xianghe.include?(gan) }.compact.uniq

    { he: he, ke: ke }
  end

  def key_zhi
    he = zhi.product(ZHI_XIANGHE).map { |zhi, xianghe| xianghe if xianghe.include?(zhi) }.compact.uniq
    chong = zhi.product(ZHI_XIANGCHONG).map { |zhi, xiangchong| xiangchong if xiangchong.include?(zhi) }.compact.uniq
    sanhui = zhi.product(ZHI_SANHUI).map { |zhi, sanhui| sanhui if sanhui.include?(zhi) }.compact.uniq
    sanhe = zhi.product(ZHI_SANHE).map { |zhi, sanhe| sanhe if sanhe.include?(zhi) }.compact.uniq
    xing = zhi.product(ZHI_XIANGXING).map { |zhi, xing| xing if xing.include?(zhi) }.compact.uniq

    { he: he,
      chong: chong,
      sanhui: sanhui,
      sanhe: sanhe,
      xing: xing
    }
  end

  # def all_key_gan_zhi
  #   user_keys = gan + zhi
  #   all_keys = GAN_XIANGHE + GAN_XIANGKE + ZHI_XIANGHE + ZHI_XIANGCHONG + ZHI_SANHUI + ZHI_SANHE + ZHI_XIANGXING
  #   result = user_keys.product(all_keys).map do |u_key, keys|
  #     # byebug
  #     matched = keys if keys.include?(u_key)
  #     if matched.present? && matched.chars.uniq.length != 1
  #       matched.gsub(u_key, '')
  #     elsif matched.present? && matched.chars.uniq.length == 1
  #       matched.chars.uniq.join("")
  #     end
  #   end.compact.uniq.join("")

  #   result.chars.uniq.join("")
  # end

  # private

  def translate_birthday
    datetime_str = DateTime.parse(lunar_birthday.to_s)

    {
      year: datetime_str.year,
      month: datetime_str.month,
      day: datetime_str.day,
      time: datetime_str.strftime("%H:%M")
    }
  end

  def get_chinese_year(year)
    tian_gan_index = (year - 4) % 10
    di_zhi_index = (year - 4) % 12

    "#{GAN[tian_gan_index]}#{ZHI[di_zhi_index]}"
  end

  def update_liunian_first_age
    qiyun_age = qiyun.split(',').first.to_i
    first_age = current_age < 60 ? qiyun_age + 1 : qiyun_age + 11
    update_columns(liunian_first_age: first_age)
  end

  def liunian_year
    liunian_first_year = liunian_first_age + translate_birthday[:year] - 1
    liunian_xi_yuan = (liunian_first_year..liunian_first_year + 59).to_a
    liunian_min_guo = (liunian_first_year..liunian_first_year + 59).to_a.map { |year| year - 1911 }
    { liunian_xi_yuan: liunian_xi_yuan, liunian_min_guo: liunian_min_guo }
  end

  def update_liunian
    update_liunian_first_age
    liunian_first_year = liunian_first_age + translate_birthday[:year] -1
    liunian_year_arr = (liunian_first_year..liunian_first_year+59).to_a

    liunian_year = [] # 干支紀年
    liunian_year_arr.each { |year| liunian_year << get_chinese_year(year) }
    update_columns(liunian: liunian_year)
  end

  def liunian_gan_zhi
    liunian_array = liunian.join('').split('')
    liunian_gan = []
    liunian_zhi = []

    liunian_array.each_with_index do |element, index|
      if index.odd?
        liunian_zhi << element
      else
        liunian_gan << element
      end
    end

    { gan: liunian_gan, zhi: liunian_zhi }
  end

  def myself_gan_relationship # 本命盤的天干剋合
    positon_year_month = [year_gan, month_gan] # 天干可能產生剋合的位置
    positon_month_day = [month_gan, day_gan]
    positon_day_time = [day_gan, time_gan]
    all_position = [positon_year_month, positon_month_day, positon_day_time]
    trans_gan_position = { '0' => 'year_month', '1' => 'month_day', '2' => 'day_time' }

    # 天干相合的判斷
    gan_xianghe_position = []
    GAN_XIANGHE.each_with_index { |gan, gan_index|
      all_position.each_with_index { |position, index|
        if gan.split('').sort == position.sort
          gan_xianghe_position << trans_gan_position[index.to_s]
          gan_xianghe_position << GAN_HEHUA_WUXING[gan_index.to_i]
        end
      }
    }

    # 天干相剋的判斷
    gan_xiangke_position = []
    GAN_XIANGKE.each { |gan|
      all_position.each_with_index { |position, index|
        if gan.split('').sort == position.sort
          gan_xiangke_position << trans_gan_position[index.to_s]
        end
      }
    }

    {
      self_gan_xianghe: gan_xianghe_position,
      self_gan_xiangke: gan_xiangke_position
    }
  end

  def myself_zhi_relationship # 本命盤的地支刑衝剋合
    positon_year_month = [year_zhi, month_zhi] # 地支可能產生刑衝剋合的位置
    positon_month_day = [month_zhi, day_zhi]
    positon_day_time = [day_zhi, time_zhi]
    positon_year_month_day = [year_zhi, month_zhi, day_zhi]
    positon_month_day_time = [month_zhi, day_zhi, time_zhi]
    all_position = [positon_year_month, positon_month_day, positon_day_time, positon_year_month_day, positon_month_day_time]
    trans_zhi_position = { '0' => 'year_month', '1' => 'month_day', '2' => 'day_time',
                           '3' => 'year_month_day', '4' => 'month_day_time'}
    # 地支相合的判斷
    zhi_xianghe_position = []
    ZHI_XIANGHE.each_with_index { |zhi, zhi_index|
      all_position.each_with_index { |position, p_index|
        if zhi.split('').sort == position.sort
          zhi_xianghe_position << trans_zhi_position[p_index.to_s]
          zhi_xianghe_position << ZHI_XIANGHE_WUXING[zhi_index.to_i]
        end
      }
    }

    # 地支相衝的判斷
    zhi_xiangchong_position = []
    ZHI_XIANGCHONG.each { |zhi|
      all_position.each_with_index { |position, p_index|
        if zhi.split('').sort == position.sort
          zhi_xiangchong_position << trans_zhi_position[p_index.to_s]
        end
      }
    }

    # 地支三會的判斷
    zhi_sanhui_position = []
    ZHI_SANHUI.each_with_index { |zhi, zhi_index|
      all_position.each_with_index { |position, p_index|
        if zhi.split('').sort == position.sort
          zhi_sanhui_position << trans_zhi_position[p_index.to_s]
          zhi_sanhui_position << ZHI_SANHUI_WUXING[zhi_index.to_i]
        end
      }
    }

     # 地支三合的判斷
     zhi_sanhe_position = []
     ZHI_SANHE.each_with_index { |zhi, zhi_index|
       all_position.each_with_index { |position, p_index|
         if zhi.split('').sort == position.sort
           zhi_sanhe_position << trans_zhi_position[p_index.to_s]
           zhi_sanhe_position << ZHI_SANHE_WUXING[zhi_index.to_i]
         end
       }
     }

     # 地支相刑的判斷
    zhi_xiangxing_position = []
    ZHI_XIANGXING.each_with_index { |zhi, zhi_index|
      all_position.each_with_index { |position, p_index|
        if zhi.split('').sort == position.sort
          zhi_xiangxing_position << trans_zhi_position[p_index.to_s]
          zhi_xiangxing_position << ZHI_XIANGXING_NOTES[zhi_index.to_i]
        end
      }
    }

    {
      self_zhi_xianghe: zhi_xianghe_position,
      self_zhi_xiangchong: zhi_xiangchong_position,
      self_zhi_sanhui: zhi_sanhui_position,
      self_zhi_sanhe: zhi_sanhe_position,
      self_zhi_xiangxing: zhi_xiangxing_position
    }
  end

  def dayun_gan_relationship # 本命盤與大運的天干剋合
    user_gan = [year_gan, month_gan, day_gan, time_gan]
    user_dayun_gan = dayun_gan_zhi[:gan]

    # 天干相合的判斷2
    dayun_gan_xianghe_position = []
    GAN_XIANGHE.each_with_index do |he_gan, he_index|
      arr = he_gan.chars
      dayun_gan_xianghe_position << [user_gan.index(arr[0]), user_dayun_gan.index(arr[1]), GAN_HEHUA_WUXING[he_index]]
    end

    dayun_gan_xianghe_position = dayun_gan_xianghe_position.select { |sub_arr| sub_arr.compact.size == 3 }

    # 天干相剋的判斷
    dayun_gan_xiangke_position = []
    GAN_XIANGKE.each do |ke_gan|
      arr = ke_gan.chars
      dayun_gan_xiangke_position << [user_gan.index(arr[0]), user_dayun_gan.index(arr[1])] 
    end

    dayun_gan_xiangke_position = dayun_gan_xiangke_position.select { |sub_arr| sub_arr.compact.size == 2 }

    {
      dayun_gan_xianghe: dayun_gan_xianghe_position,
      dayun_gan_xiangke: dayun_gan_xiangke_position,
    }
  end

  def update_relationship
    user_gan = [year_gan, day_gan, time_gan]
    user_zhi = [year_zhi, day_zhi, time_zhi]
  end

  def dayun_zhi_sanhe_sanhui # 本命與大運地支的三合三會
    user_zhi = self.zhi
    user_dayun_zhi = self.dayun_gan_zhi[:zhi]

    hash = User::ZHI_SANHE.map {|z| z.chars.permutation.map(&:join)}.flatten
    c = []
    a.combination(2).each do |pair|
      c << [a.index(pair[0]), a.index(pair[1])] if pair.all? { |elem| b.include?(elem) }
    end
  end
end
