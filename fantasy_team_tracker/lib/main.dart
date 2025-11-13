import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(
  const MaterialApp(home: FantasyApp(), debugShowCheckedModeBanner: false),
);

class Player {
  final String name;
  final String team;
  final String pos;
  final String line;
  const Player(this.name, this.team, this.pos, this.line);
}

class TradePlayer {
  final String label;
  final String name;
  final String team;
  final String pos;
  final int rec;
  final int yds;
  final int td;
  const TradePlayer(
    this.label,
    this.name,
    this.team,
    this.pos,
    this.rec,
    this.yds,
    this.td,
  );
}

class FantasyApp extends StatelessWidget {
  const FantasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Fantasy Football"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Lineup"),
              Tab(text: "Trade Analyzer"),
            ],
          ),
        ),
        body: const TabBarView(children: [LineupTab(), TradeAnalyzerTab()]),
      ),
    );
  }
}

class LineupTab extends StatelessWidget {
  const LineupTab({super.key});

  final List<Player> players = const [
    Player("Joe Flacco", "CIN", "QB", "31/47, 470 yds, 4 TD, 2 INT"),
    Player("Derrick Henry", "BAL", "RB", "19 rush, 119 yds; 1 rec, 2 yds"),
    Player("Drake London", "ATL", "WR", "9 rec, 118 yds, 3 TD"),
    Player("Colston Loveland", "CHI", "TE", "2 rec, 118 yds, 2 TD"),
    Player("Parker Romo", "ATL", "K", "FG 1/1 (38), XP 2/3"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: players.map((player) {
        return ListTile(
          leading: CircleAvatar(child: Text(player.pos)),
          title: Text("${player.name} • ${player.team}"),
          subtitle: Text(player.line),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PlayerPage(player: player)),
            );
          },
        );
      }).toList(),
    );
  }
}

class PlayerPage extends StatelessWidget {
  final Player player;
  const PlayerPage({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(player.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              player.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "${player.pos} • ${player.team}",
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Text(player.line, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class TradeAnalyzerTab extends StatelessWidget {
  const TradeAnalyzerTab({super.key});

  @override
  Widget build(BuildContext context) {
    const yourPlayer = TradePlayer(
      "Your Player",
      "Drake London",
      "ATL",
      "WR",
      47,
      587,
      5,
    );
    const theirPlayer = TradePlayer(
      "Receiving Player",
      "Jaxon Smith-Njigba",
      "SEA",
      "WR",
      58,
      948,
      4,
    );

    Widget box(TradePlayer player) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey.shade200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                player.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                player.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${player.pos} • ${player.team}",
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  stat("REC", player.rec.toString()),
                  stat("YDS", player.yds.toString()),
                  stat("TD", player.td.toString()),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: SizedBox(
        width: 720,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [box(yourPlayer), const SizedBox(width: 12), box(theirPlayer)],
          ),
        ),
      ),
    );
  }
}

Widget stat(String label, String value) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(color: Colors.grey.shade700)),
    ],
  );
}
