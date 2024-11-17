import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/base_html.dart';
import 'package:v2ex/components/base_slider.dart';
import 'package:v2ex/main.dart';
import 'package:v2ex/model/BaseController.dart';

class C extends GetxController {}

class LayoutPage extends StatelessWidget {
  BaseController bc = BaseController.to;
  IndexController ic = IndexController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('排版', style: TextStyle(fontSize: 17.sp))),
      body: GetBuilder(
          init: C(),
          builder: (_) {
            return Container(
              child: Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              '滕王阁序',
                              style: TextStyle(fontSize: bc.layout.fontSize * 1.2, height: bc.layout.lineHeight, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.w),
                            BaseHtml(html: '''
                　豫章故郡，洪都新府。星分翼轸，地接衡庐。襟三江而带五湖，控蛮荆而引瓯越。物华天宝，龙光射牛斗之墟；人杰地灵，徐孺下陈蕃之榻。雄州雾列，俊采星驰。台隍枕夷夏之交，宾主尽东南之美。都督阎公之雅望，棨戟遥临；宇文新州之懿范，襜帷暂驻。十旬休假，胜友如云；千里逢迎，高朋满座。腾蛟起凤，孟学士之词宗；紫电青霜，王将军之武库。家君作宰，路出名区；童子何知，躬逢胜饯。
                <br/>
                <br/>
                时维九月，序属三秋。潦水尽而寒潭清，烟光凝而暮山紫。俨骖騑于上路，访风景于崇阿。临帝子之长洲，得天人之旧馆。层峦耸翠，上出重霄；飞阁流丹，下临无地。鹤汀凫渚，穷岛屿之萦回；桂殿兰宫，即冈峦之体势。
                  <br/>
                <br/>
                披绣闼，俯雕甍，山原旷其盈视，川泽纡其骇瞩。闾阎扑地，钟鸣鼎食之家；舸舰弥津，青雀黄龙之舳。云销雨霁，彩彻区明。落霞与孤鹜齐飞，秋水共长天一色。渔舟唱晚，响穷彭蠡之滨，雁阵惊寒，声断衡阳之浦。
                  <br/>
                <br/>
                '''),
                          ],
                        ),
                      )),
                  Text(bc.layout.fontSize.toString()),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Text('字体'),
                      Expanded(
                          child: BaseSlider(
                              min: 12,
                              max: 26,
                              divisions: 14,
                              value: bc.layout.fontSize,
                              onChanged: (v) {
                                bc.layout.fontSize = v;
                                bc.update();
                                _.update();
                              })),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Text('间距'),
                      Expanded(
                          child: BaseSlider(
                              min: 1,
                              max: 2,
                              divisions: 10,
                              value: bc.layout.lineHeight,
                              onChanged: (v) {
                                bc.layout.lineHeight = v;
                                bc.update();
                                _.update();
                              })),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Text('缩放'),
                      Expanded(
                          child: BaseSlider(
                              min: 1,
                              max: 2,
                              divisions: 10,
                              value: ic.textScaleFactor,
                              onChanged: (v) {
                                ic.textScaleFactor = v;
                                ic.update();
                                _.update();
                              })),
                    ],
                  )
                ],
              ),
              padding: EdgeInsets.all(12.w),
            );
          }),
    );
  }
}
