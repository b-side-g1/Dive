import 'package:Dive/services/common/share/share_service.dart';
import 'package:Dive/services/common/share/templates/DefaultShareTemplate.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

import '../../../../commons/static.dart';

class ShareKakao extends DefaultShareTemplate {
  @override
  Future<void> doShare() async {
    bool isInstalled = await ShareClient.instance.isKakaoTalkSharingAvailable();
    if (isInstalled == false) {
      throw ("카카오톡이 설치되어 있지 않습니다..");
    }
    Uri url = await ShareClient.instance.shareCustom(templateId: ShareTemplateId);
    debugPrint("[share_service.dart] #doShare() url - >  $url");

    await ShareClient.instance.launchKakaoTalk(url);
  }
}
