///
/// Copyright (C) 2018 Andrious Solutions
///
/// This program is free software; you can redistribute it and/or
/// modify it under the terms of the GNU General Public License
/// as published by the Free Software Foundation; either version 3
/// of the License, or any later version.
///
/// You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  11 May 2018
///
import 'dart:io';
import 'dart:async';

import 'files.dart';

import 'package:uuid/uuid.dart';

class InstallFile {
  static const String FILE_NAME = ".install";

  static String sID;

  static bool _justInstalled = false;
  get justInstalled => _justInstalled;

  static Future<String> id() async {
    if (sID != null) return sID;

    File installFile = await Files.get(FILE_NAME);

    try {
      var exists = await installFile.exists();

      if (!exists) {
        _justInstalled = true;

        sID = writeInstallationFile(installFile);
      } else {
        sID = await readInstallationFile(installFile);
      }
    } catch (ex) {
      sID = "";
    }

    return sID;
  }

  static Future<String> readInstallationFile(File installFile) async {
    File file = await Files.get(FILE_NAME);

    String content = await Files.readFile(file);

    return content;
  }

  static String writeInstallationFile(File file) {
    var uuid = new Uuid();

    // Generate a v4 (random) id
    var id = uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'

    Files.writeFile(file, id);

    return id;
  }
}
