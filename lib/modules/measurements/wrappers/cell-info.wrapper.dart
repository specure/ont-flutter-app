import 'package:cell_info/cell_info.dart';

//CellInfo is wrapped in order to be able to mock its static getters
class CellInfoWrapper {
  Future<String?> getCellInfo() async {
    return await CellInfo.getCellInfo;
  }
  Future<String?> getSimInfo() async {
    return await CellInfo.getSIMInfo;
  }
}