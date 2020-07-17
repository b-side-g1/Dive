import 'package:flutter/cupertino.dart';

import 'feeling_tag.dart';

class FeelingTagBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 326.1,
      alignment: Alignment.centerLeft,
      child: GridView.count(
        crossAxisSpacing: 9.9,
        mainAxisSpacing: 9.9,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        crossAxisCount: 3,
        children: [
          FeelingTag(feelingTagId: 1,title: '신남', activeColor: Color.fromRGBO(255, 159, 222, 1)),
          FeelingTag(feelingTagId: 7,title: '복잡함', activeColor: Color.fromRGBO(60, 160, 217, 1)),
          FeelingTag(feelingTagId: 13,title: '무서움', activeColor: Color.fromRGBO(86, 113, 210, 1)),
          FeelingTag(feelingTagId: 2,title: '행복함', activeColor: Color.fromRGBO(255, 159, 222, 1)),
          FeelingTag(feelingTagId: 8,title: '생각많음', activeColor: Color.fromRGBO(60, 160, 217, 1)),
          FeelingTag(feelingTagId: 14,title: '답답함', activeColor: Color.fromRGBO(86, 113, 210, 1)),
          FeelingTag(feelingTagId: 3,title: '기분좋음', activeColor: Color.fromRGBO(255, 159, 222, 1)),
          FeelingTag(feelingTagId: 9,title: '쏘쏘', activeColor: Color.fromRGBO(60, 160, 217, 1)),
          FeelingTag(feelingTagId: 15,title: '우울함', activeColor: Color.fromRGBO(86, 113, 210, 1)),
          FeelingTag(feelingTagId: 4,title: '편안함', activeColor: Color.fromRGBO(255, 159, 222, 1)),
          FeelingTag(feelingTagId: 10,title: '지루함', activeColor: Color.fromRGBO(60, 160, 217, 1)),
          FeelingTag(feelingTagId: 16,title: '당황스러움', activeColor: Color.fromRGBO(86, 113, 210, 1)),
          FeelingTag(feelingTagId: 5,title: '사랑돋음', activeColor: Color.fromRGBO(255, 159, 222, 1)),
          FeelingTag(feelingTagId: 11,title: '짜증남', activeColor: Color.fromRGBO(60, 160, 217, 1)),
          FeelingTag(feelingTagId: 17,title: '슬픔', activeColor: Color.fromRGBO(86, 113, 210, 1)),
          FeelingTag(feelingTagId: 6,title: '설렘', activeColor: Color.fromRGBO(255, 159, 222, 1)),
          FeelingTag(feelingTagId: 12,title: '화남', activeColor: Color.fromRGBO(60, 160, 217, 1)),
          FeelingTag(feelingTagId: 18,title: '아픔', activeColor: Color.fromRGBO(86, 113, 210, 1)),
        ],
      ),
    );
  }

}