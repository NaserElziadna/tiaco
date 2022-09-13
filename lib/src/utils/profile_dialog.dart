import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/services/game_provider.dart';
import 'package:tictactoe/src/services/sound_service.dart';
import 'package:tictactoe/src/theme/prefrences.dart';
import 'text_data.dart';

class ProfileDialog extends StatelessWidget {
  final String photoUrl;
  ProfileDialog(this.photoUrl);

  final File file = File(GameProvider().photoUrl);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, value, child) => AlertDialog(
        scrollable: true,
        contentPadding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
        titlePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            file.existsSync() || photoUrl.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: photoUrl.isEmpty
                        ? FileImage(file) as ImageProvider<Object>?
                        : NetworkImage(photoUrl),
                    radius: 25,
                  )
                : CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    radius: 25,
                    child: Text(
                      value.name.initials(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600],
                      ),
                    ),
                  ),
            Text(
              value.name,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.times,
                color: Colors.red,
                size: 35,
              ),
              onPressed: () {
                SoundService().playSound('click');
                Navigator.pop(context);
              },
            )
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            'Game Statistics'.style(
              fontSize: 24.sp,
              color: crossColor,
            ),
            const SizedBox(height: 15),
            dataTable(heading: 'Single Player', value: value),
            const Divider(height: 15),
            multiDataTable(
              wins: value.multiPlayer.wins,
              losses: value.multiPlayer.losses,
              draws: value.multiPlayer.draws,
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                'Highest Streak: ${value.streak}'.style(
                    bold: false, color: Colors.deepOrange, fontSize: 16.sp),
                'Coins: ${value.bucks}'
                    .style(bold: false, color: Colors.green, fontSize: 16.sp)
              ],
            )
          ],
        ),
      ),
    );
  }

  dataTable({String? heading, GameProvider? value}) {
    return Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: heading!.style(
                fontSize: 20.sp, color: Colors.teal, bold: false)),
        DataTable(
          columnSpacing: 10,
          horizontalMargin: 5,
          columns: [
            DataColumn(
                label: getText('Mode', Colors.purpleAccent[400]!),
                numeric: true),
            DataColumn(label: getText('Wins', crossColor), numeric: true),
            DataColumn(label: getText('Losses', circleColor), numeric: true),
            DataColumn(label: getText('Draws', accentColor), numeric: true),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(getText('Easy', Colors.teal)),
                DataCell(getText('${value!.singlePlayer.wins}', Colors.teal)),
                DataCell(getText('${value.singlePlayer.losses}', Colors.teal)),
                DataCell(getText('${value.singlePlayer.draws}', Colors.teal)),
              ],
            ),
            DataRow(
              cells: [
                DataCell(getText('Medium', Colors.deepOrangeAccent)),
                DataCell(getText('${value.singlePlayerMedium.wins}',
                    Colors.deepOrangeAccent)),
                DataCell(getText('${value.singlePlayerMedium.losses}',
                    Colors.deepOrangeAccent)),
                DataCell(getText('${value.singlePlayerMedium.draws}',
                    Colors.deepOrangeAccent)),
              ],
            ),
            DataRow(
              cells: [
                DataCell(getText('Expert', Colors.redAccent)),
                DataCell(getText(
                    '${value.singlePlayerExpert.wins}', Colors.redAccent)),
                DataCell(getText(
                    '${value.singlePlayerExpert.losses}', Colors.redAccent)),
                DataCell(getText(
                    '${value.singlePlayerExpert.draws}', Colors.redAccent)),
              ],
            ),
          ],
          dividerThickness: 2,
        )
      ],
    );
  }

  multiDataTable({
    int? wins,
    int? losses,
    int? draws,
  }) {
    return Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: 'Multi Player'
                .style(fontSize: 20.sp, color: Colors.teal, bold: false)),
        DataTable(
          columnSpacing: 30,
          columns: [
            DataColumn(label: getText('Wins', crossColor), numeric: true),
            DataColumn(label: getText('Losses', circleColor), numeric: true),
            DataColumn(label: getText('Draws', accentColor), numeric: true),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(getText('$wins', Colors.teal)),
                DataCell(getText('$losses', Colors.teal)),
                DataCell(getText('$draws', Colors.teal)),
              ],
            ),
          ],
          dividerThickness: 2,
        )
      ],
    );
  }

  getText(String text, Color color) =>
      text.style(color: color, fontSize: 18.sp, letterSpacing: 1.2);
}
