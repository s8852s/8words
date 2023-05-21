module UsersHelper
  def translate_shishen(myself, another)
    if User::GAN.include? myself
      myself_index = User::GAN.index(myself)
      myself_wuxing = User::GAN_WUXING[myself_index]
      myself_yinyang = User::GAN_YINYANG[myself_index]
    else
      myself_index = User::ZHI.index(myself)
      myself_wuxing = User::ZHI_WUXING[myself_index]
      myself_yinyang = User::ZHI_YINYANG[myself_index]
    end

    if User::GAN.include? another
      another_index = User::GAN.index(another)
      another_wuxing = User::GAN_WUXING[another_index]
      another_yinyang = User::GAN_YINYANG[another_index]
    else
      another_index = User::ZHI.index(another)
      another_wuxing = User::ZHI_WUXING[another_index]
      another_yinyang = User::ZHI_YINYANG[another_index]
    end

    relation = if myself_wuxing == another_wuxing
                 '同我'
               elsif User::XIANGKE[myself_wuxing.to_sym] == another_wuxing
                 '剋我'
               elsif User::XIANGKE[another_wuxing.to_sym] == myself_wuxing
                 '我剋'
               elsif User::XIANGSHENG[myself_wuxing.to_sym] == another_wuxing
                 '我生'
               elsif User::XIANGSHENG[another_wuxing.to_sym] == myself_wuxing
                 '生我'
               end

    shishen = { 
      '我剋': ['七殺', '正官'],
      '剋我': ['偏財', '正財'],
      '我生': ['食神', '傷官'],
      '生我': ['偏印', '正印'],
      '同我': ['比肩', '劫財'],
    }

    if myself_yinyang == another_yinyang
      shishen[relation.to_sym][0]
    else
      shishen[relation.to_sym][1]
    end
  end

  def translate_birthday(birthday)
    datetime_str = DateTime.parse(birthday.to_s)

    {
      year: datetime_str.year,
      month: datetime_str.month,
      day: datetime_str.day,
      time: datetime_str.strftime("%H:%M")
    }
  end

  def show_wuxing(user_gan_or_zhi)
    if User::GAN.include? user_gan_or_zhi
      User::GAN_WUXING[User::GAN.index("#{user_gan_or_zhi}")]
    else
      User::ZHI_WUXING[User::ZHI.index("#{user_gan_or_zhi}")]
    end
  end

  def changzhi(zhi) # 藏支
    return '' unless User::ZHI.include?(zhi)

    zhi_index = User::ZHI.index(zhi)
    User::CANGZHI[zhi_index].reverse
  end

  def changzhi_shishen(zhi, user_day_gan)
    return '' if User::ZHI.exclude?(zhi) || User::GAN.exclude?(user_day_gan)

    changzhi_str = changzhi(zhi).reverse
    changzhi_array = changzhi_str.split('')
    changzhi_array_remove_first = changzhi_array.drop(1)
    changzhi_array_remove_first.map { |gan| translate_shishen(user_day_gan, gan) }
  end

  def dayun_age(user_qiyun)
    qiyun_age = user_qiyun.split(',').first.to_i
    qiyun_age_array = (qiyun_age+1..qiyun_age+100).step(5).to_a
    dayun_age_gan = []
    dayun_age_zhi = []

    qiyun_age_array.each_with_index do |element, index|
      if index.odd?
        dayun_age_zhi << element
      else
        dayun_age_gan << element
      end
    end
    { dayun_age_gan: dayun_age_gan.take(8), dayun_age_zhi: dayun_age_zhi.take(8) }
  end

  def show_dayun(user_dayun)
    dayun_array = user_dayun.join('').split('')

    dayun_gan = []
    dayun_zhi = []

    dayun_array.each_with_index do |element, index|
      if index.odd?
        dayun_zhi << element
      else
        dayun_gan << element
      end
    end

    { dayun_gan: dayun_gan.take(8), dayun_zhi: dayun_zhi.take(8) }
  end

  def show_dayun_shishen(user_dayun, user_day_gan)
    dayun_hash = show_dayun(user_dayun)

    {
      dayun_shishen_gan: dayun_hash[:dayun_gan].take(8).map { |dayun_gan| translate_shishen(user_day_gan, dayun_gan) },
      dayun_shishen_zhi: dayun_hash[:dayun_zhi].take(8).map { |dayun_zhi| translate_shishen(user_day_gan, dayun_zhi) }
    }
  end

  def current_age(user_birthday)
    this_year = Time.now.year
    user_birth_year = translate_birthday(user_birthday)[:year].to_i
    this_year - user_birth_year
  end

  def liunian_age(user)
    first_age_arr = (user.liunian_first_age..user.liunian_first_age+59).to_a
    first_age_arr.each_slice((first_age_arr.size / 6.to_f).ceil).to_a
  end

  def show_liunian(user)
    user.liunian.each_slice((user.liunian.size / 6.to_f).ceil).to_a
  end

  def liunian_xi_yuan(user)
    user.liunian_year[:liunian_xi_yuan].each_slice((user.liunian_year[:liunian_xi_yuan].size / 6.to_f).ceil).to_a
  end

  def liunian_min_guo(user)
    user.liunian_year[:liunian_min_guo].each_slice((user.liunian_year[:liunian_min_guo].size / 6.to_f).ceil).to_a
  end

  def show_liunian_shishen(user)
    liunian_arr = user.liunian.join('').split('')

    liunian_gan = []
    liunian_zhi = []

    liunian_arr.each_with_index do |element, index|
      if index.odd?
        liunian_zhi << element
      else
        liunian_gan << element
      end
    end

    {
      liunian_shishen_gan: liunian_gan.map { |gan| translate_shishen(user.day_gan, gan) }.each_slice((liunian_gan.size / 6.to_f).ceil).to_a,
      liunian_shishen_zhi: liunian_zhi.map { |zhi| translate_shishen(user.day_gan, zhi) }.each_slice((liunian_zhi.size / 6.to_f).ceil).to_a
    }
  end

  def get_chinese_year(year)
    tian_gan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
    di_zhi = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]

    tian_gan_index = (year - 4) % 10
    di_zhi_index = (year - 4) % 12

    "#{tian_gan[tian_gan_index]}#{di_zhi[di_zhi_index]}"
  end
end
