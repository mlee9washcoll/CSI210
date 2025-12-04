import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green.shade700,
        scaffoldBackgroundColor: Colors.grey.shade100,
        colorScheme: ColorScheme.light(
          primary: Colors.green.shade700,
          secondary: Colors.green.shade400,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade800,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardColor: Colors.white,
        listTileTheme: ListTileThemeData(
          tileColor: Colors.white,
          textColor: Colors.black,
          iconColor: Colors.green.shade800,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.greenAccent.shade400,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Colors.greenAccent,
          secondary: Colors.greenAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.greenAccent,
          elevation: 2,
        ),
        cardColor: const Color(0xFF1A1A1A),
        listTileTheme: const ListTileThemeData(
          tileColor: Color(0xFF1A1A1A),
          textColor: Colors.white,
          iconColor: Colors.greenAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
        ),
      ),
      home: LayoutDemo(
        isDark: _isDark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class LayoutDemo extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const LayoutDemo({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    final tabLabelColor = isDarkTheme ? Colors.greenAccent : Colors.white;
    final tabUnselectedColor = isDarkTheme ? Colors.grey : Colors.white70;
    final tabIndicatorColor = isDarkTheme ? Colors.greenAccent : Colors.white;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fantasy Football'),
          actions: [
            Row(
              children: [
                Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                Switch(
                  value: isDark,
                  onChanged: (_) => onToggleTheme(),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
          bottom: TabBar(
            labelColor: tabLabelColor,
            unselectedLabelColor: tabUnselectedColor,
            indicatorColor: tabIndicatorColor,
            tabs: const [
              Tab(text: 'Lineup'),
              Tab(text: 'Trade Analyzer'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LineupTab(),
            TradeAnalyzerTab(),
          ],
        ),
      ),
    );
  }
}

double calculatePoints({
  required String pos,
  required int passYds,
  required int passTd,
  required int passInt,
  required int yds,
  required int td,
  required int fg,
  required int xp,
}) {
  String inputPlayer = pos.toUpperCase().trim();
  double pts = 0;

  if (inputPlayer == 'QB') {
    pts += passYds / 25.0;
    pts += passTd * 4.0;
    pts -= passInt * 2.0;
  } else if (inputPlayer == 'RB' || inputPlayer == 'WR' || inputPlayer == 'TE') {
    pts += yds * 0.1;
    pts += td * 6.0;
  } else if (inputPlayer == 'K') {
    pts += fg * 3.0;
    pts += xp * 1.0;
  }

  return pts;
}

int weekFromDate(DateTime d) {
  List<int> monthLengths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  bool leap = (d.year % 4 == 0 && d.year % 100 != 0) || (d.year % 400 == 0);
  if (leap) {
    monthLengths[1] = 29;
  }
  int dayOfYear = d.day;
  for (int i = 0; i < d.month - 1; i++) {
    dayOfYear += monthLengths[i];
  }
  int realWeek = ((dayOfYear - 1) ~/ 7) + 1;
  int fantasyWeek = ((realWeek - 1) % 14) + 1;
  return fantasyWeek;
}

int _intFromJson(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return 0;
}

class Player {
  final String name;
  final String team;
  final String pos;
  final int passYds;
  final int passTd;
  final int passInt;
  final int yds;
  final int td;
  final int fg;
  final int xp;

  Player({
    required this.name,
    required this.team,
    required this.pos,
    required this.passYds,
    required this.passTd,
    required this.passInt,
    required this.yds,
    required this.td,
    required this.fg,
    required this.xp,
  });

  double get points {
    return calculatePoints(
      pos: pos,
      passYds: passYds,
      passTd: passTd,
      passInt: passInt,
      yds: yds,
      td: td,
      fg: fg,
      xp: xp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'team': team,
      'pos': pos,
      'passYds': passYds,
      'passTd': passTd,
      'passInt': passInt,
      'yds': yds,
      'td': td,
      'fg': fg,
      'xp': xp,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'] ?? '',
      team: map['team'] ?? '',
      pos: map['pos'] ?? '',
      passYds: _intFromJson(map['passYds']),
      passTd: _intFromJson(map['passTd']),
      passInt: _intFromJson(map['passInt']),
      yds: _intFromJson(map['yds']),
      td: _intFromJson(map['td']),
      fg: _intFromJson(map['fg']),
      xp: _intFromJson(map['xp']),
    );
  }
}

class LineupTab extends StatefulWidget {
  const LineupTab({super.key});

  @override
  State<LineupTab> createState() => _LineupTabState();
}

class _LineupTabState extends State<LineupTab> {
  final List<Player> players = [];
  int _week = weekFromDate(DateTime.now());

  int _toInt(String v) => int.tryParse(v.trim()) ?? 0;

  double get totalPoints {
    double total = 0;
    for (var player in players) {
      total += player.points;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    _loadLineup();
  }

  void _loadLineup() {
    String? data = html.window.localStorage['lineup'];
    if (data == null) return;
    try {
      List list = jsonDecode(data);
      List<Player> loaded =
          list.map((e) => Player.fromMap(Map<String, dynamic>.from(e))).toList();
      setState(() {
        players
          ..clear()
          ..addAll(loaded);
      });
    } catch (e) {
      // ignore decoding errors for now
    }
  }

  void _saveLineup() {
    List<Map<String, dynamic>> maps = players.map((p) => p.toMap()).toList();
    String data = jsonEncode(maps);
    html.window.localStorage['lineup'] = data;
  }

  Future<void> _pickWeek() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _week = weekFromDate(picked);
      });
    }
  }

  void _showAddPlayerDialog() {
    String name = "";
    String team = "";
    String pos = "";
    String passYds = "0";
    String passTd = "0";
    String passInt = "0";
    String yds = "0";
    String td = "0";
    String fg = "0";
    String xp = "0";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Player"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    decoration: const InputDecoration(labelText: "Name"),
                    onChanged: (value) => name = value),
                TextField(
                    decoration: const InputDecoration(labelText: "Team"),
                    onChanged: (value) => team = value),
                TextField(
                    decoration:
                        const InputDecoration(labelText: "Position (QB/RB/WR/TE/K)"),
                    onChanged: (value) => pos = value),
                const SizedBox(height: 8),
                TextField(
                    decoration: const InputDecoration(labelText: "Pass Yds"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => passYds = value),
                TextField(
                    decoration: const InputDecoration(labelText: "Pass TD"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => passTd = value),
                TextField(
                    decoration: const InputDecoration(labelText: "Interceptions"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => passInt = value),
                TextField(
                    decoration: const InputDecoration(labelText: "Total Yds"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => yds = value),
                TextField(
                    decoration: const InputDecoration(labelText: "Total TD"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => td = value),
                TextField(
                    decoration: const InputDecoration(labelText: "FG Made"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => fg = value),
                TextField(
                    decoration: const InputDecoration(labelText: "XP Made"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => xp = value),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                if (name.trim().isEmpty ||
                    team.trim().isEmpty ||
                    pos.trim().isEmpty) return;

                setState(() {
                  players.add(Player(
                    name: name.trim(),
                    team: team.trim(),
                    pos: pos.trim(),
                    passYds: _toInt(passYds),
                    passTd: _toInt(passTd),
                    passInt: _toInt(passInt),
                    yds: _toInt(yds),
                    td: _toInt(td),
                    fg: _toInt(fg),
                    xp: _toInt(xp),
                  ));
                });

                _saveLineup();
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _weekRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Week $_week"),
        const SizedBox(width: 8),
        TextButton(
          onPressed: _pickWeek,
          child: const Text("Change Week"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _weekRow(),
            const SizedBox(height: 20),
            const Text(
              "No players in your lineup.\nTap + to add one.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddPlayerDialog,
          child: const Icon(Icons.add),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 8),
          _weekRow(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Lineup Score: ${totalPoints.toStringAsFixed(1)} pts",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: players.map((player) {
                return ListTile(
                  leading: CircleAvatar(child: Text(player.pos.toUpperCase())),
                  title: Text("${player.name} • ${player.team}"),
                  subtitle:
                      Text("Fantasy: ${player.points.toStringAsFixed(1)} pts"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() => players.remove(player));
                      _saveLineup();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LoadingPlayerPage(player: player)),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlayerDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class LoadingPlayerPage extends StatefulWidget {
  final Player player;
  const LoadingPlayerPage({super.key, required this.player});

  @override
  State<LoadingPlayerPage> createState() => _LoadingPlayerPageState();
}

class _LoadingPlayerPageState extends State<LoadingPlayerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController c;

  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    c.repeat(reverse: true);
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      c.stop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PlayerPage(player: widget.player),
        ),
      );
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Loading")),
      body: Center(
        child: ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.2).animate(c),
          child: const Icon(Icons.sports_football, size: 72),
        ),
      ),
    );
  }
}

class PlayerPage extends StatelessWidget {
  final Player player;
  const PlayerPage({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary = theme.brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade700;

    return Scaffold(
      appBar: AppBar(title: Text(player.name)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: theme.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: theme.colorScheme.primary,
                          child: Text(
                            player.pos.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                player.team,
                                style: TextStyle(color: textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Fantasy Points:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            player.points.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Stats",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    _StatRowGroup(
                      title: "Passing",
                      rows: [
                        _StatRow(
                          label: "Pass Yards",
                          value: player.passYds.toString(),
                        ),
                        _StatRow(
                          label: "Pass TD",
                          value: player.passTd.toString(),
                        ),
                        _StatRow(
                          label: "Interceptions",
                          value: player.passInt.toString(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _StatRowGroup(
                      title: "Yards & Touchdowns",
                      rows: [
                        _StatRow(
                          label: "Total Yards",
                          value: player.yds.toString(),
                        ),
                        _StatRow(
                          label: "Total TD",
                          value: player.td.toString(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _StatRowGroup(
                      title: "Kicking",
                      rows: [
                        _StatRow(
                          label: "FG Made",
                          value: player.fg.toString(),
                        ),
                        _StatRow(
                          label: "XP Made",
                          value: player.xp.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatRowGroup extends StatelessWidget {
  final String title;
  final List<_StatRow> rows;

  const _StatRowGroup({
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final textSecondary = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        ...rows,
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textSecondary = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade700;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: textSecondary),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class LoadingTradePage extends StatefulWidget {
  const LoadingTradePage({super.key});

  @override
  State<LoadingTradePage> createState() => _LoadingTradePageState();
}

class _LoadingTradePageState extends State<LoadingTradePage>
    with SingleTickerProviderStateMixin {
  late AnimationController c;

  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    c.repeat();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      c.stop();
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analyzing Trade")),
      body: Center(
        child: SizedBox(
          width: 260,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 40,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(width: 10, height: 90, color: Colors.amber),
                        const SizedBox(width: 100),
                        Container(width: 10, height: 90, color: Colors.amber),
                      ],
                    ),
                    Container(width: 120, height: 10, color: Colors.amber),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: c,
                builder: (_, __) {
                  double t = c.value;
                  double y = 1.5 - 2.2 * t;
                  double size = 48 - (28 * t);
                  return Align(
                    alignment: Alignment(0, y),
                    child: Icon(
                      Icons.sports_football,
                      size: size,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TradeAnalyzerTab extends StatefulWidget {
  const TradeAnalyzerTab({super.key});

  @override
  State<TradeAnalyzerTab> createState() => _TradeAnalyzerTabState();
}

class _TradeAnalyzerTabState extends State<TradeAnalyzerTab> {
  Player? yourPlayer;
  Player? theirPlayer;
  String analysisMsg = "Set both players to compare the trade.";
  int _week = weekFromDate(DateTime.now());

  int _toInt(String value) => int.tryParse(value.trim()) ?? 0;

  Future<void> _pickWeek() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _week = weekFromDate(picked);
      });
    }
  }

  void _showEditPlayerDialog(String label) {
    String name = "";
    String team = "";
    String pos = "";
    String passYds = "0";
    String passTd = "0";
    String passInt = "0";
    String yds = "0";
    String td = "0";
    String fg = "0";
    String xp = "0";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Set $label"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    decoration: const InputDecoration(labelText: "Name"),
                    onChanged: (value) => name = value),
                TextField(
                    decoration: const InputDecoration(labelText: "Team"),
                    onChanged: (value) => team = value),
                TextField(
                    decoration: const InputDecoration(labelText: "Position"),
                    onChanged: (value) => pos = value),
                const SizedBox(height: 8),
                TextField(
                    decoration: const InputDecoration(labelText: "Pass Yds"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => passYds = value),
                TextField(
                    decoration: const InputDecoration(labelText: "Pass TD"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => passTd = value),
                TextField(
                    decoration:
                        const InputDecoration(labelText: "Interceptions"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => passInt = value),
                TextField(
                    decoration: const InputDecoration(labelText: "Total Yds"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => yds = value),
                TextField(
                    decoration: const InputDecoration(labelText: "Total TD"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => td = value),
                TextField(
                    decoration: const InputDecoration(labelText: "FG Made"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => fg = value),
                TextField(
                    decoration: const InputDecoration(labelText: "XP Made"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => xp = value),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                if (name.trim().isEmpty ||
                    team.trim().isEmpty ||
                    pos.trim().isEmpty) return;

                Player player = Player(
                  name: name.trim(),
                  team: team.trim(),
                  pos: pos.trim(),
                  passYds: _toInt(passYds),
                  passTd: _toInt(passTd),
                  passInt: _toInt(passInt),
                  yds: _toInt(yds),
                  td: _toInt(td),
                  fg: _toInt(fg),
                  xp: _toInt(xp),
                );

                setState(() {
                  if (label == "Your Player") {
                    yourPlayer = player;
                  } else {
                    theirPlayer = player;
                  }
                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String _analysis() {
    if (yourPlayer == null || theirPlayer == null) {
      return "Set both players to compare the trade.";
    }
    double yourPts = yourPlayer!.points;
    double theirPts = theirPlayer!.points;
    double diff = theirPts - yourPts;
    if (diff > 0) {
      return "Trade Edge: +${diff.toStringAsFixed(1)} pts (Receiving)";
    }
    if (diff < 0) {
      return "Trade Edge: ${diff.toStringAsFixed(1)} pts (Your side)";
    }
    return "Trade looks even.";
  }

  Future<void> _runAnalysis() async {
    String msg = _analysis();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoadingTradePage()),
    );
    if (!mounted) return;
    setState(() {
      analysisMsg = msg;
    });
  }

  Widget _buildBox(String label, Player? player) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color boxColor =
        isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade200;
    final Color borderColor =
        isDark ? Colors.greenAccent.withOpacity(0.6) : Colors.grey.shade400;

    if (player == null) {
      return Expanded(
        child: GestureDetector(
          onTap: () => _showEditPlayerDialog(label),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: const Center(
              child: Text(
                "Tap to set\nYour Player / Receiving Player",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    double pts = player.points;
    bool pass =
        player.passYds != 0 || player.passTd != 0 || player.passInt != 0;
    bool y = player.yds != 0 || player.td != 0;
    bool k = player.fg != 0 || player.xp != 0;

    List<Widget> stats = [];
    if (pass) {
      stats.add(Text(
          "Pass: ${player.passYds} yds, ${player.passTd} TD, ${player.passInt} INT"));
    }
    if (y) {
      stats.add(Text("Yds/TD: ${player.yds} yds, ${player.td} TD"));
    }
    if (k) {
      stats.add(Text("K: ${player.fg} FG, ${player.xp} XP"));
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => _showEditPlayerDialog(label),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              const SizedBox(height: 8),
              Text(
                player.name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text("${player.pos.toUpperCase()} • ${player.team}"),
              const SizedBox(height: 6),
              ...stats,
              if (stats.isNotEmpty) const SizedBox(height: 6),
              Text(
                "Fantasy: ${pts.toStringAsFixed(1)} pts",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _weekRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Week $_week"),
        const SizedBox(width: 8),
        TextButton(
          onPressed: _pickWeek,
          child: const Text("Change Week"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 720,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _weekRow(),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildBox("Your Player", yourPlayer),
                const SizedBox(width: 12),
                _buildBox("Receiving Player", theirPlayer),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _runAnalysis,
              child: const Text("Analyze Trade"),
            ),
            const SizedBox(height: 8),
            Text(analysisMsg, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

