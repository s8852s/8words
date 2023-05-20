$(document).ready(function() {
  var solar = Solar.fromYmdHms(1993,2,25,13,30,0);
  // // console.log(solar.toFullString());
  // // console.log(solar.getLunar().toFullString());
  // // console.log(solar.getLunar().getBaZi());
  // console.log(solar.getLunar().getBaZiShiShenYearZhi());
  // console.log(solar.getLunar().getEightChar().getYun(1,1));
  // console.log(solar.getLunar().getEightChar().getYun(1,1).getDaYun()[1].getGanZhi());
  // console.log(solar.getLunar().getEightChar().getYearXunKong());
  // console.log(solar.getLunar().getEightChar().getDayXunKong());
  // console.log('=======')
  // console.log(solar.getLunar().getEightChar().getYun(0,1).getDaYun()[1].getLiuNian()[1].getGanZhi());
  // console.log(solar.getLunar().getEightChar().getYun(0,1).getDaYun()[3].getLiuNian()[1].getYear());
  // console.log('=======')
  // console.log('大運')
  // // solar.getLunar().getEightChar().getYun(0,1).getDaYun().forEach(function(e){
  // //   console.log(e.getLiuNian()[0])
  // // });
  // console.log('######')
  // console.log(solar.getLunar().getEightChar().getYun(0,1).getDaYun()[1].getXiaoYun());
  // var arr = []
  // solar.getLunar().getEightChar().getYun(0,1).getDaYun().forEach(function(e){
  //   console.log(e.getGanZhi())
  //   arr.push(e.getGanZhi())
  //   // console.log(e.getYear())
  // });
  // console.log(arr)
  // console.log('######')
  
  // console.log(solar.getLunar().getEightChar().getYun(0,1).getDaYun()[1].getGanZhi());
  // console.log(solar.getLunar().getEightChar().getYun(0,1).getDaYun()[1].getXiaoYun()[0]);
  // console.log(solar.getLunar().getEightChar().getYun(0,1).getDaYun()[1].getXiaoYun()[0].getGanZhi());
  // console.log(solar.getLunar().getEightChar().getYun(0,1).getDaYun()[1].getXiaoYun()[0].getYear());

  $('.submit-btn').on('click', function(e) {
    // e.preventDefault();
    // 填入國曆生日
    var birth_str = `${$('#user_year').val()}-${$('#user_month').val()}-${$('#user_day').val()} ${$('#user_hour').val()}:${$('#user_minute').val()}`
    $('.solar_birthday').val(birth_str)

    // 轉換農曆生日
    var lunar = Solar.fromYmdHms($('#user_year').val(),$('#user_month').val(),$('#user_day').val(),$('#user_hour').val(),$('#user_minute').val(),0).getLunar();
    var lunar_birth_str = `${lunar.getYear()}-${lunar.getMonth()}-${lunar.getDay()} ${$('#user_hour').val()}:${$('#user_minute').val()}`
    $('.lunar_birthday').val(lunar_birth_str)
    // console.log(lunar.getYear());

    //  性別
    var gender = parseInt($('input[name="user[gender]"]:checked').val()); // 男1女0

    // 八字 
    var bazi = lunar.getBaZi()
    $('.year_gan').val(lunar.getBaZi()[0].charAt(0)) 
    $('.year_zhi').val(lunar.getBaZi()[0].charAt(1)) 
    $('.month_gan').val(lunar.getBaZi()[1].charAt(0)) 
    $('.month_zhi').val(lunar.getBaZi()[1].charAt(1)) 
    $('.day_gan').val(lunar.getBaZi()[2].charAt(0)) 
    $('.day_zhi').val(lunar.getBaZi()[2].charAt(1)) 
    $('.time_gan').val(lunar.getBaZi()[3].charAt(0)) 
    $('.time_zhi').val(lunar.getBaZi()[3].charAt(1)) 
    
    // 五行
    // console.log(lunar.getBaZiWuXing())

    // 天干主星 篇才篇印
    var bazi_shishen_gan = lunar.getBaZiShiShenGan()
    console.log(lunar.getBaZiShiShenGan())
    
    // 地支年柱主星 
    var bazi_shishen_zhi = lunar.getBaZiShiShenZhi()
    console.log(lunar.getBaZiShiShenZhi())
    
    // 地支年柱主副星
    console.log(lunar.getBaZiShiShenYearZhi())
    
    // 地支月柱主副星
    console.log(lunar.getBaZiShiShenMonthZhi())

    // 地支日柱主副星
    console.log(lunar.getBaZiShiShenDayZhi())

    // 地支時柱主副星
    console.log(lunar.getBaZiShiShenTimeZhi())

    // 大運
    var dayun_arr = []
    lunar.getEightChar().getYun(gender,1).getDaYun().forEach(function(e){
      console.log(e.getGanZhi())
      dayun_arr.push(e.getGanZhi())
    });
    $('.dayun').val(dayun_arr)
    console.log(dayun_arr)

    // 填入表格
    $('#name').text($('.name').val())
    $('#gender').text(gender === 1 ? '男' : '女')
    console.log(gender)
    $('#solar-year').text($('.solar-year').val())
    $('#solar-month').text($('.solar-month').val())
    $('#solar-day').text($('.solar-day').val())
    $('#solar-time').text(`${$('.solar-hour').val()} : ${$('.solar-minute').val()}`)

    $('#lunar-year').text(lunar.getYear()-1911)
    $('#lunar-month').text(lunar.getMonth())
    $('#lunar-day').text(lunar.getDay())
    $('#lunar-time').text(`${$('.solar-hour').val()}:${$('.solar-minute').val()}`)

    // bazi_shishen_gan
    $('#shishen-year-gen').text(bazi_shishen_gan[0])
    $('#shishen-month-gen').text(bazi_shishen_gan[1])
    $('#shishen-time-gen').text(bazi_shishen_gan[3])

    // 起運
    var qiyun = [lunar.getEightChar().getYun(gender,1).getStartYear(), lunar.getEightChar().getYun(gender,1).getStartMonth(), lunar.getEightChar().getYun(gender,1).getStartDay()]
    $('.qiyun').val(qiyun)

    // 八字天干
    $('#bazi-year-gen').text(bazi[0].charAt(0))
    $('#bazi-month-gen').text(bazi[1].charAt(0))
    $('#bazi-day-gen').text(bazi[2].charAt(0))
    $('#bazi-time-gen').text(bazi[3].charAt(0))
    
    // 八字地支
    $('#bazi-year-zhi').text(bazi[0].charAt(1))
    $('#bazi-month-zhi').text(bazi[1].charAt(1))
    $('#bazi-day-zhi').text(bazi[2].charAt(1))
    $('#bazi-time-zhi').text(bazi[3].charAt(1))

    // 地支十神 bazi_shishen_zhi
    $('#shishen-year-zhi').text(bazi_shishen_zhi[0])
    $('#shishen-month-zhi').text(bazi_shishen_zhi[1])
    $('#shishen-day-zhi').text(bazi_shishen_zhi[2])
    $('#shishen-time-zhi').text(bazi_shishen_zhi[3])

    // 空亡
    // var xunkong = [lunar.getEightChar().getYearXunKong(), lunar.getEightChar().getDayXunKong()]
    $('.xunkong').val(`${lunar.getEightChar().getYearXunKong()}${lunar.getEightChar().getDayXunKong()}`)
  

    // 地支年柱主副星
    var bazi_shishen_year_zhi = lunar.getBaZiShiShenYearZhi()
    bazi_shishen_year_zhi.shift()
    var bazi_shishen_year_fuxing = bazi_shishen_year_zhi
    // 地支月柱主副星
    var bazi_shishen_month_zhi = lunar.getBaZiShiShenMonthZhi()
    bazi_shishen_month_zhi.shift()
    var bazi_shishen_month_fuxing = bazi_shishen_month_zhi
    // console.log(lunar.getBaZiShiShenMonthZhi())
    // 地支日柱主副星
    var bazi_shishen_day_zhi = lunar.getBaZiShiShenDayZhi()
    bazi_shishen_day_zhi.shift()
    var bazi_shishen_day_fuxing = bazi_shishen_day_zhi
    console.log(lunar.getBaZiShiShenDayZhi())
    // 地支時柱主副星
    var bazi_shishen_time_zhi = lunar.getBaZiShiShenTimeZhi()
    bazi_shishen_time_zhi.shift()
    var bazi_shishen_time_fuxing = bazi_shishen_time_zhi
    console.log(lunar.getBaZiShiShenTimeZhi())

    $('#shishen-year-fuxing').text(bazi_shishen_year_fuxing)
    $('#shishen-month-fuxing').text(bazi_shishen_month_fuxing)
    $('#shishen-day-fuxing').text(bazi_shishen_day_fuxing)
    $('#shishen-time-fuxing').text(bazi_shishen_time_fuxing)
  })
});
