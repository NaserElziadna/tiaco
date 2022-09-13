class GameStat {
  final String? data;
  final int? wins, losses, draws;

  const GameStat({this.data, this.draws, this.losses, this.wins});

  factory GameStat.fromMap(Map<String, dynamic> map) => GameStat(
        data: map['data'],
        wins: map['wins'],
        losses: map['losses'],
        draws: map['draws'],
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'data': data,
        'wins': wins,
        'losses': losses,
        'draws': draws
      };
}
