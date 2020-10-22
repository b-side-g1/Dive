import 'package:Dive/services/common/share/share_service.dart';
import 'package:Dive/services/common/share/templates/DefaultShareTemplate.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/link.dart';

import '../../../../commons/static.dart';

class ShareKakao extends DefaultShareTemplate {
  @override
  void doShare() async {
    LinkClient lc = LinkClient.instance;
    bool isInstalled = await isKakaoTalkInstalled();
    if(isInstalled == false) {
      throw("카카오톡이 설치되어 있지 않습니다..");
    }
    Uri url = await lc.customWithTalk(ShareTemplateId);
    debugPrint("[share_service.dart] #doShare() url - >  ${url}");

    await lc.launchKakaoTalk(url);
  }
}