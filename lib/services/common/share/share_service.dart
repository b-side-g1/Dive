import 'package:Dive/services/common/share/templates/DefaultShareTemplate.dart';

class ShareService extends DefaultShareTemplate{
  DefaultShareTemplate template;

  ShareService.template(this.template);

  @override
  void doShare() async {
    await template.doShare();
  }

}