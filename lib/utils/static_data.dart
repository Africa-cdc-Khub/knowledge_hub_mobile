
import 'package:khub_mobile/models/theme_model.dart';

class StaticData {

    static List<ThemeModel> getThemeList() {
      List<ThemeModel> list = [];
      list.add(ThemeModel(id: 1, description: 'Health Workforce', icon: 'fa-users',   displayIndex: 1));
      list.add(ThemeModel(id: 2, description:'Health Risk Environment',  icon: 'fa-seedling',   displayIndex: 1));
      list.add(ThemeModel(id: 3, description:'Health Systems',  icon: 'fa-suitcase-medical',  displayIndex: 1));
      list.add(ThemeModel(id: 4, description:'Response', icon:  'fa-ambulance',   displayIndex: 1));
      list.add(ThemeModel(id: 5, description:'Detection', icon:  'fa-microscope',  displayIndex: 1));
      list.add(ThemeModel(id: 6, description:'Prevention',  icon: 'fa-ban',  displayIndex: 1));
      list.add(ThemeModel(id: 7, description:'Global Health Security',  icon: 'fa-shield-halved',   displayIndex: 1));

      return list;
    }
}
